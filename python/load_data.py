import io
import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

# ---------- SETTINGS: edit these ----------
DATA_DIR = r"C:\Users\USER\Desktop\data analysis portfolio\PORT 1"
DB_PASSWORD = "15December2002#"
DB_NAME = "medicare_claims"
# ------------------------------------------

url = URL.create(
    "postgresql+psycopg2",
    username="postgres",
    password=DB_PASSWORD,
    host="localhost",
    port=5432,
    database=DB_NAME,
)
engine = create_engine(url)

# file name -> table name (adjust names if yours differ)
FILES = [
    ("DE1_0_2008_Beneficiary_Summary_File_Sample_1.csv", "beneficiary_2008", True),
    ("DE1_0_2009_Beneficiary_Summary_File_Sample_1.csv", "beneficiary_2009", True),
    ("DE1_0_2010_Beneficiary_Summary_File_Sample_1.csv", "beneficiary_2010", True),
    ("DE1_0_2008_to_2010_Inpatient_Claims_Sample_1.csv", "inpatient_claims", True),
    ("DE1_0_2008_to_2010_Outpatient_Claims_Sample_1.csv", "outpatient_claims", True),
    ("DE1_0_2008_to_2010_Carrier_Claims_Sample_1A.csv", "carrier_claims", True),
    ("DE1_0_2008_to_2010_Carrier_Claims_Sample_1B.csv", "carrier_claims", False),  # appends to same table
    ("DE1_0_2008_to_2010_Prescription_Drug_Events_Sample_1.csv", "prescription_drug_events", True),
]

def load_csv(filename, table, reset):
    path = f"{DATA_DIR}\\{filename}"
    print(f"Loading {filename} -> {table}")
    first = True
    total = 0
    conn = engine.raw_connection()
    cur = conn.cursor()
    for chunk in pd.read_csv(path, dtype=str, chunksize=200_000):
        chunk.columns = [c.lower() for c in chunk.columns]
        if first and reset:
            # create (or replace) the table using the CSV's column names, all as text
            chunk.head(0).to_sql(table, engine, if_exists="replace", index=False)
        first = False
        buf = io.StringIO()
        chunk.to_csv(buf, index=False, header=False)
        buf.seek(0)
        cur.copy_expert(f"COPY {table} FROM STDIN WITH CSV", buf)
        conn.commit()
        total += len(chunk)
        print(f"  {total:,} rows loaded")
    cur.close()
    conn.close()

for filename, table, reset in FILES:
    load_csv(filename, table, reset)

print("Done.")
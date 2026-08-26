import dlt
from dlt.sources.sql_database import sql_database
from dotenv import load_dotenv


load_dotenv()

source = sql_database()

# Corrige o tipo de dados das colunas "time" para "text"
for resource in source.resources.values():
    @dlt.defer
    def fix_resource_schema(res=resource):
        time_cols = {
            col_name: {"data_type": "text"}
            for col_name, col_meta in res.columns.items()
            if col_meta.get("data_type") == "time"
        }
        if time_cols:
            res.apply_hints(columns=time_cols)

pipeline = dlt.pipeline(
    pipeline_name="local_postgres_to_databricks5",
    destination="databricks",
    dataset_name="postgres_adventureworks"
)

print("Iniciando migração")

load_info = pipeline.run(source)

print("Migração concluída com sucesso!")
print(load_info)
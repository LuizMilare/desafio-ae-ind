import dlt
from dlt.sources.sql_database import sql_database
from dotenv import load_dotenv


load_dotenv()

# Só as tabelas que o dbt lê (models/staging/_sources.yml), agrupadas por schema do Postgres.
# As colunas sensíveis ficam de fora por meio de included_columns em .dlt/config.toml.
TABLES_BY_SCHEMA = {
    "sales": [
        "salesorderheader",
        "salesorderdetail",
        "salesorderheadersalesreason",
        "salesreason",
        "customer",
        "store",
        "creditcard",
    ],
    "person": ["person", "address", "stateprovince", "countryregion"],
    "production": ["product", "productsubcategory", "productcategory"],
}

pipeline = dlt.pipeline(
    pipeline_name="local_postgres_to_databricks6",
    destination="databricks",
    dataset_name="postgres_adventureworks"
)

print("Iniciando migração")

for schema, tables in TABLES_BY_SCHEMA.items():
    source = sql_database(schema=schema, table_names=tables)

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

    # replace recarrega a tabela inteira a cada execução, sem duplicar linhas
    load_info = pipeline.run(source, write_disposition="replace")

    print(f"Schema {schema} carregado")
    print(load_info)

print("Migração concluída com sucesso!")

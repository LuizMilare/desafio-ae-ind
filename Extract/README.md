# Etapa de Extract-Load configurada com dlt

Neste projeto, a carga dos dados consiste em uma etapa simples. O script de EL está descrito em el_script.py, e as credenciais da fonte (Postgres) e target (Databricks) constam nos arquivos .env e .dlt.

O projeto é baseado no repo https://github.com/dpavancini/analytics-engineering. O Banco de dados Adventureworks é hospedado localmente.

Para o funcionamento adequado do script, dentro da pasta Extract/, crie o arquivo .env:

```
# Databricks target credentials
DESTINATION__DATABRICKS__CREDENTIALS__SERVER_HOSTNAME="seu-hostname.cloud.databricks.com"
DESTINATION__DATABRICKS__CREDENTIALS__HTTP_PATH="/sql/1.0/warehouses/seu-path"
DESTINATION__DATABRICKS__CREDENTIALS__ACCESS_TOKEN = "seu-personal-acess-token"
DESTINATION__DATABRICKS__CREDENTIALS__CATALOG="dev" # Ou inserir o catálogo desejado
```

Ainda na pasta Extract, crie outra pasta chamada .dlt. Nela, crie o arquivo config.toml:
```
[sources.sql_database]
schema_names = ["sales"]

[data_writer]
timestamp_timezone = "UTC"
```

Neste arquivo, será possível especificar quais Schemas do banco devem ser replicados.
Ainda na pasta .dlt, crie o arquivo secrets.toml:
```
[sources.sql_database]
credentials = "postgresql://seu-user:sua-senha@localhost:5432/Adventureworks"
```

Então, execute o el_script.py
# Etapa de Extract-Load configurada com dlt

Neste projeto, a carga dos dados consiste em uma etapa simples. O script de EL está descrito em el_script.py, e as credenciais da fonte (Postgres) e target (Databricks) constam nos arquivos .env e .dlt.

O projeto é baseado no repo https://github.com/dpavancini/analytics-engineering. O Banco de dados Adventureworks é hospedado localmente.

## O que é extraído

O script carrega só as 14 tabelas que o dbt lê (`models/staging/_sources.yml`), de três schemas do Postgres. O dlt aceita um schema por vez em `sql_database`, por isso o script faz uma chamada por schema, com `table_names`.

| Schema | Tabelas |
|---|---|
| `sales` | `salesorderheader`, `salesorderdetail`, `salesorderheadersalesreason`, `salesreason`, `customer`, `store`, `creditcard` |
| `person` | `person`, `address`, `stateprovince`, `countryregion` |
| `production` | `product`, `productsubcategory`, `productcategory` |

Tabelas que o projeto não usa e que têm dados sensíveis (`personcreditcard`, `salesperson`, `shoppingcartitem`, `person.password`, `person.emailaddress`, entre outras) não são extraídas.

## Dados sensíveis

Além de limitar as tabelas, o `.dlt/config.toml` lista, por tabela, as colunas permitidas (`included_columns`). O que não está na lista não sai do Postgres:

| Tabela | Colunas não extraídas |
|---|---|
| `creditcard` | `cardnumber`, `expmonth`, `expyear` |
| `address` | `addressline1`, `addressline2`, `postalcode`, `spatiallocation`, `rowguid` |
| `person` | `title`, `middlename`, `suffix`, `emailpromotion`, `additionalcontactinfo`, `demographics`, `rowguid` |
| `store` | `demographics` |
| `salesorderheader` | `accountnumber`, `creditcardapprovalcode`, `comment` |

Os modelos de staging do dbt não leem essas colunas. Se uma coluna for adicionada à lista, o modelo `stg_postgres__<tabela>` correspondente precisa ser ajustado.

## Configuração

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
[data_writer]
timestamp_timezone = "UTC"

[sources.sql_database.creditcard]
included_columns = ["creditcardid", "cardtype", "modifieddate"]

[sources.sql_database.address]
included_columns = ["addressid", "stateprovinceid", "city", "modifieddate"]

[sources.sql_database.person]
included_columns = ["businessentityid", "persontype", "firstname", "lastname", "modifieddate"]

[sources.sql_database.store]
included_columns = ["businessentityid", "name", "salespersonid", "rowguid", "modifieddate"]

[sources.sql_database.salesorderheader]
included_columns = [
    "salesorderid", "revisionnumber", "orderdate", "duedate", "shipdate", "status",
    "onlineorderflag", "purchaseordernumber", "customerid", "salespersonid", "territoryid",
    "billtoaddressid", "shiptoaddressid", "shipmethodid", "creditcardid", "currencyrateid",
    "subtotal", "taxamt", "freight", "totaldue", "rowguid", "modifieddate",
]
```

Os nomes de tabela e coluna precisam coincidir com os do Postgres (minúsculas).
Ainda na pasta .dlt, crie o arquivo secrets.toml:
```
[sources.sql_database]
credentials = "postgresql://seu-user:sua-senha@localhost:5432/Adventureworks"
```

Então, execute o el_script.py

## Recarga limpa

O dlt não remove colunas já criadas no destino. Para que colunas sensíveis carregadas em execuções anteriores desapareçam:

1. No Databricks, apague o schema de destino: `drop schema dev.postgres_adventureworks cascade`.
2. Use um `pipeline_name` novo no `el_script.py` (o atual é `local_postgres_to_databricks6`), para que o dlt não reaproveite o schema salvo em `~/.dlt/pipelines`.
3. Execute o `el_script.py` e depois `dbt build`.

Depois da carga, confira no `information_schema.columns` que `cardnumber` e as demais colunas da tabela acima não existem.

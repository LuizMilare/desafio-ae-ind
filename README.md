# desafio-ae-ind

Projeto dbt do desafio de Analytics Engineering sobre o dataset AdventureWorks:
transforma os dados brutos de vendas em um modelo dimensional (star schema) no
Databricks, com documentação e testes, para alimentar um dashboard de vendas.

## Perguntas de negócio

O modelo foi desenhado para responder:

- **a.** Pedidos, quantidade e valor por produto, tipo de cartão, motivo de venda,
  data, cliente, status, cidade, estado e país.
- **b.** Produtos com maior valor médio por pedido ((vendas brutas − descontos) /
  pedidos), por mês, ano, cidade, estado e país.
- **c.** Top 10 clientes por valor.
- **d.** Top 5 cidades por valor.
- **e.** Série temporal de pedidos, quantidade e valor por mês e ano.
- **f.** Produto mais vendido (em unidades) no motivo de venda "Promoção".

As definições das métricas e as decisões de modelagem estão em
[docs/regras_de_negocio.md](docs/regras_de_negocio.md).

## Stack

- Data warehouse: Databricks (catálogo `dev`)
- Carga: dlt, para o schema `postgres_adventureworks`
- Transformação: dbt (executado no dbt Cloud)
- Visualização: dashboard Databricks AI/BI sobre as tabelas da camada `marts`

## Dashboard

Dashboard publicado: [Adventure Works Sales](https://dbc-61d8a12f-9c38.cloud.databricks.com/dashboardsv3/01f1e2e694fb1db5a3fb7ee4571db86b/published).
A definição está em `dashboard/` e a descrição dos visuais e dos cálculos em
[docs/dashboard.md](docs/dashboard.md).

## Camadas

```
models/
  staging/        stg_postgres__<tabela>.sql + _sources.yml   (views)
  intermediate/   int_<nome>.sql                              (views)
  marts/          dim_*, fact_*, bridge_*                     (tabelas)
  marts/schema/   um .yml por modelo de mart (docs e testes)
tests/            testes singulares de regras de negócio
```

- **staging:** renomeia e tipa as colunas de cada tabela de origem. Não carrega
  o número do cartão de crédito.
- **intermediate:** junta as tabelas de origem e calcula as medidas.
- **marts:** modelo dimensional final, materializado como tabela.

## Modelo dimensional

`fact_sales` tem grão de item de pedido (`salesorderdetail`) e se liga a:

| Tabela | Descrição | Chave na fato |
|---|---|---|
| `dim_products` | produtos, subcategorias e categorias | `fk_productid` |
| `dim_customers` | clientes (loja ou pessoa) | `fk_customerid` |
| `dim_addresses` | endereço, cidade, estado e país | `fk_shiptoaddressid`, `fk_billtoaddressid` |
| `dim_credit_cards` | tipo do cartão | `fk_creditcardid` |
| `dim_dates` | calendário diário | `orderdate` |
| `dim_sales_reasons` | motivos de venda | via `bridge_sales_order_reasons` |

Pedidos e motivos de venda são muitos-para-muitos, por isso existe a tabela
ponte `bridge_sales_order_reasons` (pedido × motivo), ligada à fato por
`fk_salesorderid`.

Medidas da fato: `salesorderdetailsubtotal` (vendas brutas),
`salesorderdetaildiscount` (desconto) e `salesorderdetailnetsubtotal` (vendas
líquidas). Os valores `subtotal`, `taxamt`, `freight` e `totaldue` são do
cabeçalho do pedido e se repetem em cada linha; não devem ser somados.

## Como executar

No dbt Cloud (ou em qualquer ambiente dbt com acesso ao Databricks):

```bash
dbt run                       # constrói staging, intermediate e marts
dbt test --select source:*    # testes nas tabelas de origem
dbt test                      # todos os testes
dbt docs generate             # documentação e linhagem
```

`dbt build` executa modelos e testes em ordem de dependência.

## Testes

Os testes cobrem:

- chaves únicas e não nulas nas fontes e em todas as tabelas dos marts;
- integridade referencial (`relationships`) entre a fato, as dimensões e a ponte;
- valores aceitos (status do pedido, tipo de cliente);
- regras de negócio em `tests/`, incluindo a validação das vendas brutas de 2011
  (US$ 12.646.112,16), consistência entre vendas brutas, desconto e líquidas, e
  consistência do `totaldue`.

A lista completa e a justificativa de cada regra estão em
[docs/regras_de_negocio.md](docs/regras_de_negocio.md).

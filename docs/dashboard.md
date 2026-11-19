# Dashboard de vendas (Databricks AI/BI)

Dashboard **Adventure Works Sales**, construído no Databricks AI/BI sobre as
tabelas da camada `marts` (`fact_sales`, dimensões e ponte de motivos de venda).

- **Link:** https://dbc-61d8a12f-9c38.cloud.databricks.com/dashboardsv3/01f1e2e694fb1db5a3fb7ee4571db86b/published
- **Definição (JSON):** [dashboard/adventure_works_sales.lvdash.json](../dashboard/adventure_works_sales.lvdash.json)

O dashboard foi publicado com credenciais embutidas, então quem tem acesso ao
workspace vê os dados sem precisar de permissão no warehouse. O workspace é
Databricks Free Edition e o link exige login.

## Páginas e perguntas de negócio

| Página | Visuais | Pergunta |
|---|---|---|
| Overview | KPIs (vendas líquidas, vendas brutas, pedidos, unidades, valor médio por pedido, taxa de desconto); vendas, pedidos e unidades por mês e canal; tabela por ano; vendas por categoria; pizzas por canal | a, e |
| Products and reasons | Top 10 produtos por valor médio por pedido; top 10 produtos por vendas; top 5 produtos do motivo "Promotion"; pedidos por motivo de venda; vendas por tipo de cartão | a, b, f |
| Customers and geography | Contagem de clientes; top 10 clientes; top 5 cidades; vendas por país; top 10 estados | a, c, d |
| Filters (global) | Ano, mês, canal, país, estado, cidade, categoria, tipo de cartão, status do pedido e motivo de venda | a |

## Como os números são calculados

Cada visual lê de um dataset com SQL próprio. Os datasets agregam e ordenam no
SQL (por exemplo `order by ... limit 10` nos rankings) e recebem os filtros por
parâmetros: cada filtro é multi-seleção, e seleção vazia significa "todos".

| Dataset | Grão | Usado em |
|---|---|---|
| `kpi` | uma linha | KPIs da Overview |
| `monthly` | mês × canal | vendas, pedidos e unidades por mês |
| `yearly` | ano | tabela por ano |
| `categories` | categoria | vendas por categoria |
| `channels` | canal | pizzas por canal |
| `products_aov` | produto (top 10) | valor médio por pedido |
| `products_top` | produto (top 10) | produtos por vendas |
| `customers_top` | cliente (top 10) | ranking de clientes |
| `cities_top` | cidade (top 5) | ranking de cidades |
| `countries` | país | vendas por país |
| `states_top` | estado (top 10) | ranking de estados |
| `cards` | tipo de cartão | vendas por cartão |
| `customer_stats` | uma linha | contagem de clientes e compra única |
| `reasons` | motivo de venda | pedidos por motivo |
| `promo_products` | produto (top 5) | produtos do motivo "Promotion" |
| `filter_values`, `reason_values` | valores distintos | opções dos filtros |

Definições das métricas (as mesmas de [regras_de_negocio.md](regras_de_negocio.md)):

- **Vendas líquidas** = `salesorderdetailnetsubtotal` (vendas brutas menos desconto).
- **Pedidos** = `count(distinct fk_salesorderid)`.
- **Valor médio por pedido** = vendas líquidas / pedidos. No ranking por produto,
  só entram produtos com 30 ou mais pedidos na seleção atual; com filtros muito
  restritos, o gráfico pode mostrar poucas barras.
- **Taxa de desconto** = desconto / vendas brutas.
- **Cidade, estado e país** vêm do endereço de envio.
- **Motivos de venda** existem apenas para pedidos online, e um pedido pode ter
  mais de um motivo. Por isso os motivos não somam o total de pedidos. Os filtros
  de motivo afetam somente os visuais de motivo.

## Como recriar

O arquivo `.lvdash.json` pode ser importado no workspace do Databricks
(Workspace, Import). As consultas usam o schema `dev.dbt_lmilaremietto`; para
outro ambiente, troque o nome do schema nas consultas do arquivo antes de
importar e publique com um warehouse SQL.

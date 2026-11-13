# Regras de negócio — AdventureWorks

Este documento registra as definições e decisões usadas na modelagem dbt
(`models/`) e no dashboard. Quando uma regra está implementada no dbt, o modelo
ou teste responsável é indicado.

## 1. Escopo dos dados

- Fonte: schema `postgres_adventureworks` (Databricks, catálogo `dev`), carregado
  pelo dlt a partir do banco AdventureWorks.
- Período dos pedidos: 31/05/2011 a 30/06/2014. **2011 e 2014 são anos
  parciais** (2011 começa em 31/05; 2014 termina em 30/06 e junho/2014 tem
  volume muito baixo). Comparações ano a ano só são justas entre 2012 e 2013.
- Granularidade da tabela fato (`fact_sales`): uma linha por item de pedido
  (`salesorderdetail`). Total: 121.317 linhas, 31.465 pedidos.

## 2. Definição das métricas

| Métrica | Definição | Onde |
|---|---|---|
| Pedidos | `count(distinct fk_salesorderid)` | dashboard |
| Quantidade | `sum(orderqty)` | `fact_sales.orderqty` |
| Vendas brutas | `orderqty * unitprice`, antes de descontos | `fact_sales.salesorderdetailsubtotal` |
| Desconto | `orderqty * unitprice * unitpricediscount` | `fact_sales.salesorderdetaildiscount` |
| Vendas líquidas | vendas brutas − desconto | `fact_sales.salesorderdetailnetsubtotal` |
| Valor médio por pedido | (vendas brutas − descontos de produto) / pedidos | dashboard (pergunta b) |

Decisões:

- **"Valor" nas perguntas a, c, d e e = vendas líquidas.** Vendas brutas aparecem
  ao lado como métrica de apoio. A validação do CEO (vendas brutas de 2011 =
  US$ 12.646.112,16) usa vendas brutas e está coberta pelo teste
  `assert_order_gross_sales_2011`.
- **Pedidos nunca são somados a partir de linhas da fato.** Um pedido tem vários
  itens, então a contagem usa `distinct`.
- **Valores do cabeçalho não são somados.** `subtotal`, `taxamt`, `freight` e
  `totaldue` se repetem em todas as linhas do pedido; somá-los na fato infla o
  resultado. Para valor de venda, use as três medidas de item acima.
- `totaldue` inclui impostos e frete, por isso não é usado como "valor de
  venda". O teste `assert_fact_sales_totaldue_matches_components` verifica que
  ele é consistente com `subtotal + taxamt + freight`.
- Descontos são em média 0,48% das vendas brutas. Quase todo o valor vem de
  preço cheio.

## 3. Geografia (cidade, estado, país)

O pedido tem dois endereços: cobrança (`fk_billtoaddressid`) e envio
(`fk_shiptoaddressid`), ambos ligados a `dim_addresses`.

- **Regra: cidade, estado e país usam o endereço de envio (ship-to)**, que
  representa para onde a venda foi entregue.
- Na prática a escolha pesa pouco: dos 31.465 pedidos, 99 têm endereços de
  cobrança e envio diferentes, 13 diferem na cidade e nenhum difere no país.
- No modelo de BI, a relação com o endereço de envio é a ativa e a de cobrança
  fica inativa (ou é omitida).
- O nome do país vem de `dim_addresses.countryregion_name`.

## 4. Clientes

- `dim_customers` combina cliente, pessoa e loja.
- **Nome do cliente:** nome da loja para clientes do tipo `Store`; para os demais
  (`Individual`), nome completo da pessoa.
- Tipos aceitos: `Store` e `Individual` (teste `accepted_values`).
- O ranking de clientes (pergunta c) usa `customer_name`, mas a chave de
  agrupamento é `pk_customerid`, para não juntar clientes com nomes iguais.

## 5. Cartão de crédito

- `dim_credit_cards` traz apenas o tipo do cartão (`cardtype`). **O número do
  cartão não é carregado** (dado sensível); o modelo de staging o exclui.
- 1.131 pedidos não têm cartão (`fk_creditcardid` nulo). No dashboard esses
  pedidos aparecem como "Sem cartão", sem serem descartados.

## 6. Motivos de venda

Um pedido pode ter mais de um motivo, então a relação é muitos-para-muitos e
está na tabela ponte `bridge_sales_order_reasons` (pedido × motivo), ligada a
`dim_sales_reasons`.

- **Duplicidade entre motivos:** um pedido com dois motivos entra uma vez em
  cada. Somar pedidos ou valores por motivo gera total maior que o real.
  Não some entre motivos e use `count(distinct fk_salesorderid)` para pedidos.
- **Pedidos sem motivo** (cerca de 8.453) não aparecem na ponte. Para análises
  por motivo eles ficam de fora; para totais gerais, use a fato sem a ponte.
- **"Promoção" (pergunta f):** corresponde ao motivo `On Promotion`
  (`reasontype` = `Promotion`). O produto de maior quantidade nesse motivo é a
  garrafa d'água, com 546 unidades.
- A ponte tem teste de unicidade da combinação pedido × motivo
  (`assert_bridge_sales_order_reasons_unique`).

## 7. Status do pedido

- A coluna `status` aceita os valores 1 a 6 (teste `accepted_values`).
- **No dataset, todos os pedidos têm status 5.** O filtro por status existe no
  dashboard por exigência da pergunta a, mas hoje não separa nada.

## 8. Datas

- A data de referência é `orderdate`, ligada a `dim_dates` (calendário diário de
  1º de janeiro do primeiro ano até 31 de dezembro do último).
- Mês e ano das séries temporais (pergunta e) vêm de `dim_dates.year_month` e
  `calendar_year`.

## 9. Produtos

- Categorias e subcategorias vêm de `dim_products`. A categoria **Bikes**
  concentra cerca de 86% das vendas brutas.
- Margem, se usada, parte do custo padrão atual do produto, não do custo na data
  da venda.

## 10. Qualidade e testes

Os testes rodam com `dbt test` e cobrem:

- **Fontes:** `unique` e `not_null` nas chaves de cada tabela de origem
  (`dbt test --select source:*`).
- **Chaves primárias dos marts:** `unique` e `not_null`.
- **Chaves estrangeiras:** `relationships` da fato para cada dimensão e da ponte
  para a fato e `dim_sales_reasons`.
- **Regras de negócio** (pasta `tests/`):
  - vendas brutas de 2011 = US$ 12.646.112,16 (validação do CEO);
  - fato não vazia;
  - quantidade e preço positivos;
  - desconto entre 0 e 1;
  - datas em ordem (pedido, vencimento, envio);
  - `totaldue` coerente com subtotal, impostos e frete;
  - vendas líquidas nunca acima das brutas, e bruta − desconto = líquida;
  - combinação pedido × motivo única na ponte.

## 11. Pontos em aberto

- Confirmar com a área comercial se "valor" nos rankings deve ser líquido (como
  definido aqui) ou bruto.
- O território de vendas (`fk_territoryid`) não tem dimensão; as perguntas a–f
  não dependem dele.

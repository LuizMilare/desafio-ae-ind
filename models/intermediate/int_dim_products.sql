with
    products as (
        select *
        from {{ ref('stg_postgres__product') }}
    )

    , productsubcategories as (
        select *
        from {{ ref('stg_postgres__productsubcategory') }}
    )

    , productcategories as (
        select *
        from {{ ref('stg_postgres__productcategory') }}
    )

    , joined as (
        select
            products.pk_productid
            , products.product_name
            , products.productnumber
            , products.color
            , products.standardcost
            , products.listprice
            , products.size
            , products.sizeunitmeasurecode
            , products.weightunitmeasurecode
            , products.weight
            , products.productline
            , products.class
            , products.style
            , products.sellstartdate
            , products.sellenddate
            , products.discontinueddate
            , productsubcategories.productsubcategory_name
            , productcategories.productcategory_name
        from products
        left join productsubcategories on products.fk_productsubcategoryid = productsubcategories.pk_productsubcategoryid
        left join productcategories on productsubcategories.fk_productcategoryid = productcategories.pk_productcategoryid
    )

select *
from joined

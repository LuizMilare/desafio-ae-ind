with
    fonte_product as (
        select *
        from {{ source('postgres', 'product') }}
    )
    
    , renomeado as (
        select
            cast(productid as int) as pk_productid
            , cast(productsubcategoryid as int) as fk_productsubcategoryid
            , cast(productmodelid as int) as fk_productmodelid
            , cast(name as string) as product_name
            , cast(productnumber as string) as productnumber
            , cast(makeflag as boolean) as makeflag
            , cast(finishedgoodsflag as boolean) as finishedgoodsflag
            , cast(color as string) as color
            , cast(safetystocklevel as int) as safetystocklevel
            , cast(reorderpoint as int) as reorderpoint
            , cast(standardcost as float) as standardcost
            , cast(listprice as float) as listprice
            , cast(size as string) as size
            , cast(sizeunitmeasurecode as string) as sizeunitmeasurecode
            , cast(weightunitmeasurecode as string) as weightunitmeasurecode
            , cast(weight as float) as weight
            , cast(daystomanufacture as int) as daystomanufacture
            , cast(productline as string) as productline
            , cast(class as string) as class
            , cast(style as string) as style
            , cast(sellstartdate as date) as sellstartdate
            , cast(sellenddate as date) as sellenddate
            , cast(discontinueddate as date) as discontinueddate
            , cast(rowguid as string) as rowguid
            , cast(modifieddate as timestamp) as modifieddate
            , cast(_dlt_load_id as string) as _dlt_load_id
            , cast(_dlt_id as string) as _dlt_id
        from fonte_product
    )

select *
from renomeado
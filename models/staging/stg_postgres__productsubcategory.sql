with
    fonte_productsubcategory as (
        select *
        from {{ source('postgres', 'productsubcategory') }}
    )
    
    , renomeado as (
        select
            cast(productsubcategoryid as int) as pk_productsubcategoryid
            , cast(productcategoryid as int) as fk_productcategoryid
            , cast(name as string) as productsubcategory_name
            , cast(rowguid as string) as rowguid
            , cast(modifieddate as timestamp) as modifieddate
            , cast(_dlt_load_id as string) as _dlt_load_id
            , cast(_dlt_id as string) as _dlt_id
        from fonte_productsubcategory
    )

select *
from renomeado
with
    fonte_productcategory as (
        select *
        from {{ source('postgres', 'productcategory') }}
    )
    
    , renomeado as (
        select
            cast(productcategoryid as int) as pk_productcategoryid
            , cast(name as string) as productcategory_name
            , cast(rowguid as string) as rowguid
            , cast(modifieddate as timestamp) as modifieddate
            , cast(_dlt_load_id as string) as _dlt_load_id
            , cast(_dlt_id as string) as _dlt_id
        from fonte_productcategory
    )

select *
from renomeado
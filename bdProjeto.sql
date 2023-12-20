DROP DATABASE IF EXISTS peiBD;

CREATE DATABASE peiBD;
USE peiBD;

CREATE TABLE product (
    _id                  Object,
    product_id           int, -- id do csv
    list_price           float,

    -- O pedro tinha razão nesta
    categories [            array
        name                varchar(255),   
        sub_categories [    array
            name            varchar(255),
        ]
    ]

    brand               varchar(255),
    model               varchar(255),
    5g                  boolean,
    processor_brand     varchar(255),
    battery_capacity    float,
    fast_charging       boolean,
    ram_capacity        int,
    internal_memory     int,
    screen_size         int,
    os                  varchar(255),
    primary_camera      int,

);

CREATE TABLE customer (
    _id                 Object,
    customer_id         int, -- id do csv
    first_name          varchar(255),
    last_name           varchar(255),
    email               varchar(255),
    ative               boolean,
    create_date         date,
    gender              varchar(255),
    birthDate           date,

    address_data {      Object
        address         varchar(255),
        address2        varchar(255),
        district        varchar(255),
        country         varchar(255),
        city            varchar(255),
        postal_code     varchar(20)
    }
);

CREATE TABLE sales (
    invoice_id              Object,
    date                    date,

    -- infomração importante sobre os clientes para pesquisas
    customer {
        customer_id     Object
        first_name      varchar(255),
        last_name       varchar(255),
        address {
            country         varchar(255),
            city            varchar(255),
            postal_code     varchar(20),
        }
    }

    -- infomração importante sobre os produtos para pesquisas
    

    sales_lines: {          array -- tinha outro nome isto
        product_mongo_id    Object  -- _id from the product
        product_id          int, -- id from the csv
        product {
            product_id              int,
            brand                   varchar(255),
            categories [            array
                name                varchar(255),   
                sub_categories [    array
                    name            varchar(255),
                ]
            ]      
        }
        total_with_vat      float,
        quantity            int,
    }            
        
);


CREATE TABLE returns (
    invoice_id                  Object,
    product_id                  Object,
    date                        date,

    -- infomração importante sobre os clientes para pesquisas
    customer {                  Object,
        customer_id             int, -- id do csv
        first_name              varchar(255),
        last_name               varchar(255),
        email                   varchar(255),
        create_date             date,
        address {               Object
            country             varchar(255),
            city                varchar(255),
            postal_code         varchar(20),
        }
    }

    -- infomração importante sobre os produtos para pesquisas
    product {
        product_id              int, -- id do csv
        brand                   varchar(255),
        categories [            array
            name                varchar(255),   
            sub_categories [    array
                name            varchar(255),
            ]
    ]        
    }

);
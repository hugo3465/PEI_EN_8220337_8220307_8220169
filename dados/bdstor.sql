DROP DATABASE IF EXISTS peiBD;

CREATE DATABASE peiBD;
USE peiBD;

CREATE TABLE category (
    id      int,
    name    varchar(255),

    PRIMARY KEY (id)
);

CREATE TABLE country (
    country_id      int,
    country         varchar(255),

    PRIMARY KEY (country_id)
);

CREATE TABLE city (
    city_id         int,
    city            varchar(255),
    country_id      int,

    PRIMARY KEY (city_id),
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

CREATE TABLE address (
    address_id      int,
    address         varchar(255),
    address2        varchar(255),
    district        varchar(255),
    city_id         int,
    postal_code     varchar(20),

    PRIMARY KEY (address_id),
    FOREIGN KEY (city_id) REFERENCES city(city_id)
);

CREATE TABLE product (
    id                  int,
    list_price          float,
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

    PRIMARY KEY (id)
);

CREATE TABLE customer (
    id              int,
    first_name      varchar(255),
    last_name       varchar(255),
    email           varchar(255),
    address_id      int,
    ative           boolean,
    create_date     date,
    gender          varchar(255),
    birthDate       date,

    PRIMARY KEY (id),
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

CREATE TABLE sales_header (
    invoice_id          int,
    date                date,
    customer_id         int,

    PRIMARY KEY (invoice_id),
    FOREIGN KEY (customer_id) REFERENCES customer(id)
);

CREATE TABLE sales_lines (
    id                  int,
    total_with_vat      float,
    quantity            int,
    product_id          int,
    invoice_id          int,

    PRIMARY KEY (id),
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (invoice_id) REFERENCES sales_header(invoice_id)
);

CREATE TABLE sub_category (
    id                  int,
    name                varchar(255),
    category_id         int,

    PRIMARY KEY (id),
    FOREIGN KEY (category_id) REFERENCES category(id)
);

CREATE TABLE sub_category_product (
    sub_category_id    int,
    product_id         int,

    FOREIGN KEY (sub_category_id) REFERENCES sub_category(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE returns (
    invoice_id          int,
    product_id          int,
    date                date,

    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (invoice_id) REFERENCES sales_header(invoice_id)
);
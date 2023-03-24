create database Hero ;

use Hero;
-- Table to store item data

  CREATE TABLE item_data (
  item_id int not null,
  venue_id Varchar(255) NOT NULL,
  timestamp VARCHAR(255),
  brand VARCHAR(255),
  manufacturer VARCHAR(255),
  cost_per_unit DECIMAL(10,4),
  cost_per_unit_eur DECIMAL(10,4),
  currency VARCHAR(255),
  applicable_tax_perc REAL,
  product_id varchar(255),
  item_identifier VARCHAR(100) NOT NULL,
  external_id VARCHAR(100) NOT NULL,
  PRIMARY KEY (item_id, item_identifier)
); 

-- Table to store purchase data
CREATE TABLE purchase_data
 (  index_no int not null,
  purchase_id Varchar(255)NOT NULL PRIMARY KEY,
  time_received datetime,
  time_delivered datetime,
  currency VARCHAR(255) ,
  country VARCHAR(50) ,
  venue_id Varchar(255),
  FOREIGN KEY (venue_id) REFERENCES item_data(venue_id)
);

-- Table to store purchase item data 
 CREATE TABLE purchase_item_data (
 index_no int not null,
  product_id Varchar(255),
  purchase_id Varchar(255) NOT NULL,
  count INT NOT NULL,
  venue_id Varchar(255) NOT NULL,
  base_price DECIMAL(10,2) NOT NULL,
  vat_percentage DECIMAL(4,2) NOT NULL,
  FOREIGN KEY (purchase_id) REFERENCES purchase_data(purchase_id),
  FOREIGN KEY (venue_id) REFERENCES item_data(venue_id)
);


Show  variables like "local_infile";
set global local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/umang/OneDrive/Desktop/New folder/item.csv'
INTO TABLE Hero.item_data
FIELDS TERMINATED BY ','  LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/umang/OneDrive/Desktop/New folder/purchase_data.csv'
INTO TABLE Hero.purchase_data
FIELDS TERMINATED BY ','  LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/umang/OneDrive/Desktop/New folder/purchase_item.csv'
INTO TABLE Hero.purchase_item_data
FIELDS TERMINATED BY ','  LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- calculating profitability of each product
SELECT
  purchase_id,
  time_received,
  time_delivered,
  currency,
  country,
  venue_id,
  SUM(count * base_price * (1 + vat_percentage) / (1 + applicable_tax_perc) - cost_per_unit_eur * count) AS profit
FROM
  (SELECT
    p.purchase_id,
    p.time_received,
    p.time_delivered,
    p.currency,
    p.country,
    p.venue_id,
    pid.count,
    pid.base_price,
    pid.vat_percentage,
    id.applicable_tax_perc,
    id.cost_per_unit_eur
  FROM
    purchase_data p
    JOIN purchase_item_data pid ON p.purchase_id = pid.purchase_id
    JOIN item_data id ON pid.product_id = id.product_id AND pid.venue_id = id.venue_id) AS intermediate
GROUP BY
  purchase_id,
  time_received,
  time_delivered,
  currency,
  country,
  venue_id ;
  


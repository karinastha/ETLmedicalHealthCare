-----------------------ANALYTICAL FUNCTION ---------------------------

CREATE TABLE "medicalHealthCare".tbltest (
	id int4 NOT NULL,
	laptopname varchar(50) NOT NULL,
	brand varchar(50) NOT NULL,
	price numeric(50) NOT NULL,
	CONSTRAINT tbltest_pkey PRIMARY KEY (id)
);

insert into "medicalHealthCare".tbltest (id , laptopname, brand , price) values
(101, 'Dell XPS', 'Dell' , 500000 ),
(102, 'Dell G5' , 'Dell', 2500000),
(103, 'Apple Macbook Pro', 'Apple' , 600000),
(104, 'Apple Macbook Pro M1', 'Apple' , 200000),
(105 , 'HP Chromebook' , 'HP', 850000);

select * from "medicalHealthCare".tbltest;

insert into "medicalHealthCare".tbltest (id , laptopname, brand , price) values
(109, 'HP Chromebook x pro', 'HP' , 550000 );

update  "medicalHealthCare".tbltest set price = 450000 where id =107 ;

SELECT 
    laptopname,
   	brand,
   	price,
    RANK() OVER( partition by brand order by price desc) AS rank_laptop_brand
from "medicalHealthCare".tbltest ;


--it calculates the number of rows with a value less that or equal to the
-- current row'values , divided by the
-- total no. of rows in the group or partition
SELECT 
    laptopname, 
    brand,  
    price,
    CUME_DIST() OVER(ORDER BY price) AS price_cume_dist
FROM "medicalHealthCare".tbltest;


SELECT 
    laptopname,
   	brand,
    price,
    FIRST_VALUE(laptopname) OVER() AS first_value_laptop_name,
      LAST_VALUE(laptopname) OVER() AS last_value_laptop_name
FROM "medicalHealthCare".tbltest;

SELECT 
    laptopname,
   	brand,
    price,
    LAST_VALUE(laptopname) OVER() AS last_value_laptop_name
FROM "medicalHealthCare".tbltest;

SELECT 
    laptopname,
   	brand,
    price,
    NTH_VALUE(laptopname) OVER() AS last_value_laptop_name
FROM "medicalHealthCare".tbltest;

SELECT
    laptopname, 
    brand,
    price,
    LAG(price, 1) OVER (
        PARTITION BY group_id
        ORDER BY year
    ) last_year_sales
FROM
    sales;

select * from (
select
	laptopname ,
	brand , 
	price,
	row_number() over (order by price desc) as row_number 
from "medicalHealthCare".tbltest
) x where x.row_number = 2;

select * 
from "medicalHealthCare".tbltest;

select 
	laptopname,
	brand,
	price,
	--SUM(price) as total_price,
	dense_rank() over(order by price desc) as dense_rank 
from "medicalHealthCare".tbltest;
--group by laptopname;

select 
	laptopname,
	brand,
	price,
	--SUM(price) as total_price,
	 RANK() OVER( order by price desc) AS rank_laptop_brand,
	dense_rank() over(order by price desc) as dense_rank 
from "medicalHealthCare".tbltest;

--lead allows u to access the value of a given column in a row that is ahead of the current row
select laptopname , brand , price,
lead(price) over(order by ID) as next_price
from "medicalHealthCare".tbltest;

select laptopname , brand , price,
lead(laptopname) over(order by price desc) as next_price
from "medicalHealthCare".tbltest;


--LAG opp of LEAD
select laptopname , brand , price,
lag(price) over(order by ID) as previous_price
from "medicalHealthCare".tbltest;

select laptopname , brand , price,
lag(laptopname) over(order by price desc) as next_price
from "medicalHealthCare".tbltest;

----NTILE function is useful for analyzing data that is distributed unevenly across a range of values. It can help identify patterns
-- and trends in the data and provide insights into how the data is distributed.
select 
	laptopname,
	brand,
	price,
	NTILE(4) over(order by price DESC) as quartile
	from "medicalHealthCare".tbltest;


--percent_rank = (rank -1 ) / (total rows in partition - 1)
--calculates the rank of that row based on the order specifies by the ORDER BY 
select 
	laptopname,
	brand,
	price,
	PERCENT_RANK() over (order by price) as percentile
	from "medicalHealthCare".tbltest order by percentile ;

select 
	laptopname,
	brand,
	price,
	percent_rank() over(order by sum(price) desc) AS percentile_rank
from "medicalHealthCare".tbltest;


	
	
	
	




























select * from public.test1;

CREATE EXTENSION tablefunc;
ALTER SYSTEM SET shared_preload_libraries = 'tablefunc';
SELECT pg_reload_conf();
select * from pg_catalog.pg_extension ;

SELECT * FROM crosstab(
  'SELECT laptopname , brand , price
   FROM "medicalHealthCare".tbltest
   ORDER BY 1',
  'SELECT DISTINCT brand FROM "medicalHealthCare".tbltest ORDER BY 1'
) AS ct(
			laptopname varchar(50),
			Apple varchar(50), 
			Dell varchar(50),
			HP varchar(50)
		);
	
	SELECT name FROM pg_available_extensions WHERE name LIKE 'tablefunc%';

SELECT * FROM pg_extension WHERE extname = 'tablefunc';

CREATE EXTENSION tablefunc;

		
SHOW data_directory;
SELECT * FROM pg_proc WHERE proname='crosstab'; --

SELECT * FROM crosstab(
  'SELECT laptopname, brand, price 
   FROM "medicalHealthCare".tbltest
   ORDER BY 1',
  'SELECT DISTINCT brand FROM "medicalHealthCare".tbltest ORDER BY 1'
) AS ct(
  laptopname varchar(50),
  brand varchar(50), 
  price int,
);

select version();
create table sales(year int, month int, qty int);
insert into sales values(2007, 1, 1000);
insert into sales values(2007, 2, 1500);
insert into sales values(2007, 7, 500);
insert into sales values(2007, 11, 1500);
insert into sales values(2007, 12, 2000);
insert into sales values(2008, 1, 1000);

select * from crosstab(
'select year, month, qty from sales order by 1',
'select m from generate_series(1,12) m'
) as (
year int,
"Jan" int,
"Feb" int,
"Mar" int,
"Apr" int,
"May" int,
"Jun" int,
"Jul" int,
"Aug" int,
"Sep" int,
"Oct" int,
"Nov" int,
"Dec" int
);




































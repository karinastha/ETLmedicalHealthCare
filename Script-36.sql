-----------------------------PIVOT----------------------------------
--CROSS TAB is library 

CREATE EXTENSION tablefunc;
ALTER SYSTEM SET shared_preload_libraries = 'tablefunc';
SELECT pg_reload_conf();
select * from pg_catalog.pg_extension ; --kun kun extension install bhako check


SELECT * FROM tablefunc.crosstab(
  'SELECT laptopname , brand , price 
   FROM "medicalHealthCare".tbltest
   ORDER BY 1',
  'SELECT DISTINCT brand FROM "medicalHealthCare".tbltest ORDER BY 1'
) AS ct(
			laptopname varchar(50),
			brand varchar(50), 
			price numeric(50)
		);

select * from "medicalHealthCare".tbltest;


CREATE TABLE "medicalHealthCare".tbltest (
	id int4 NOT NULL,
	laptopname varchar(50) NOT NULL,
	brand varchar(50) NOT NULL,
	price numeric(50) NOT NULL,
	CONSTRAINT tbltest_pkey PRIMARY KEY (id)
);
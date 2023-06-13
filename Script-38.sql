
CREATE TABLE "medicalHealthCare".tblJsonTest (
	id INTEGER NOT NULL,
	data Json
);
insert into "medicalHealthCare".tblJsonTest(id , data)
values (101, '{"name": "John", "age": 30}'),
(102, '{"name": "Ram", "age": 15}'),
(103, '{"name": "Sita", "age": 19}'),
(104, '{"name": "Hari", "age": 25}'),
(105, '{"name": "Zayn", "age": 32}'),
(106, '{"name": "Gigi", "age": 38}'),
(107, '{"name": "Jack", "age": 27}');

select * from "medicalHealthCare".tblJsonTest;
SELECT data->'name' AS name, data->>'age' AS age FROM "medicalHealthCare".tblJsonTest WHERE id = 101;

UPDATE "medicalHealthCare".tblJsonTest SET data = data #= '{"name": "Daisy"}' WHERE id = 102;

UPDATE "medicalHealthCare".tblJsonTest SET data = data - 'age' WHERE id = 1;

SELECT json_agg(data) AS all_data FROM "medicalHealthCare".tblJsonTest;

-------------------------------------DYNAMIC FUNCTION-----------------------------------------
--tblPatient ( RETURNS SETOF patient AS $$ )
--RETURNS SETOF: This clause indicates that the function will return multiple rows as a result.
--patient: This refers to the data type of the rows being returned. In this case, it suggests that the function will return rows of the patient type.
--AS $$: This signifies the beginning of the function's body.

select * from "medicalHealthCare".tblpatdes;
select * from  "lookupSchema".tblpatientstage;
CREATE OR REPLACE FUNCTION search_patients(
  search_column TEXT,
  search_value TEXT
)
--RETURNS SETOF patient AS $$ 
RETURNS text $$ 
BEGIN
  RETURN QUERY EXECUTE format('SELECT * FROM "medicalHealthCare".tblpatient WHERE %I = $1', search_column)
    USING search_value;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM search_patients('patientfirstname', 'Tilda');

CREATE OR REPLACE FUNCTION search_patients(
  search_column VARCHAR,
  search_value VARCHAR
)
RETURNS SETOF VARCHAR AS $$
BEGIN
  RETURN QUERY EXECUTE format('SELECT * FROM "medicalHealthCare".tblpatient WHERE %I = $1', search_column)
    USING search_value;
END;
$$ LANGUAGE plpgsql;

select * from "medicalHealthCare".tblpatient;
select * from "lookupSchema".tblpatdesstage;
select * from "lookupSchema".tbldocspecstage;

CREATE OR REPLACE PROCEDURE "lookupSchema".patdocspecproc()
 LANGUAGE plpgsql
AS $procedure$
begin
	insert into "lookupSchema".tbldocspecstage
select x.row_number ,x.specid , x.specialization , x.degree, x.doctorid, x.yearsofexp, x.CountEXPbyDegree,
x.dense_rank_speicialization, x.dense_rank_degree
from (
	select specid ,specialization, doctorid,
	degree,
	yearsofexp,
row_number() over() as row_number ,
row_number() over(partition by degree, yearsofexp order by yearsofexp) as CountEXPbyDegree,
dense_rank() over(order by specialization) as dense_rank_speicialization,
dense_rank() over(order by degree) as dense_rank_degree
from "medicalHealthCare".tbldocspec) x;
end;
$procedure$
;
CREATE OR REPLACE PROCEDURE "lookupSchema".patdesproc()
 LANGUAGE plpgsql
AS $procedure$
	declare result varchar;
begin
	insert into "lookupSchema".tblpatdesStage
select x.row_number ,x.pdescid , x.summary , x.heightInFt, x.weightinkg, x.bloodpressure, x.patientId ,
ROUND (avg(x.weightinkg) over (), 2) as AVG_weightInKG,
ROUND (avg(x.heightinft) over (), 2) as AVG_heightinFT,
case
WHEN (x.weightinkg - AVG(x.weightinkg) OVER () ) > 0 THEN 'Overweight'
WHEN (x.weightinkg - AVG(x.weightinkg) OVER () ) < 0 THEN 'Underweight'
ELSE 'normal'
END as weightClass,
case
WHEN (heightinft - AVG(heightinft) OVER () ) > 0 THEN 'Over'
WHEN (heightinft - AVG(heightinft) OVER () ) < 0 THEN 'Under'
ELSE 'normal'
END as heightClass,  x.dense_summary ,
case
when x.ntile_bpsystolic = 3 then 'Critical'
when x.ntile_bpsystolic = 2 then 'High'
else 'Normal'
end as ntileBpHighLevel,
case
when x.ntile_bpdystolic = 3 then 'Critical'
when x.ntile_bpdystolic = 2 then 'Low'
else 'Normal'
end as ntileBpLowLevel
from (
	select pdescid, summary, 
case
WHEN heightIn = 'in' THEN round(height/12,2)
WHEN heightIn = 'cm' then round(height/30.48,2)
ELSE height 
END as heightInFt, 
case
WHEN weightIn = 'pd' THEN round(weight * 0.45,2)
ELSE weight 
END as weightInKg, 
case
WHEN bpSystolic > 110 AND bpDystolic > 90 then 1
WHEN bpSystolic < 90 AND bpDystolic < 60 then  -1
ELSE 0
END as bloodpressure, patientid,
 row_number() over() as row_number,
 dense_rank() over(order by summary) as dense_summary,
 NTILE(3) over(order by bpsystolic) as ntile_bpsystolic,
 NTILE(3) over(order by bpdystolic) as ntile_bpdystolic
from "medicalHealthCare".tblpatdes) x;
end;
$procedure$
;

-----------------------------pateintDesc AND doctorSpecialization (In one procedure)---------------------------------------------------
CREATE OR REPLACE FUNCTION "lookupSchema".combined_proc()
  RETURNS VOID AS $$
BEGIN
  EXECUTE '
    INSERT INTO "lookupSchema".tblpatdesStage
    SELECT x.row_number, x.pdescid, x.summary, x.heightInFt, x.weightinkg, x.bloodpressure, x.patientId,
      ROUND(AVG(x.weightinkg) OVER (), 2) AS AVG_weightInKG,
      ROUND(AVG(x.heightinft) OVER (), 2) AS AVG_heightinFT,
      CASE
        WHEN (x.weightinkg - AVG(x.weightinkg) OVER ()) > 0 THEN ''Overweight''
        WHEN (x.weightinkg - AVG(x.weightinkg) OVER ()) < 0 THEN ''Underweight''
        ELSE ''normal''
      END AS weightClass,
      CASE
        WHEN (heightinft - AVG(heightinft) OVER ()) > 0 THEN ''Over''
        WHEN (heightinft - AVG(heightinft) OVER ()) < 0 THEN ''Under''
        ELSE ''normal''
      END AS heightClass,
      x.dense_summary,
      CASE
        WHEN x.ntile_bpsystolic = 3 THEN ''Critical''
        WHEN x.ntile_bpsystolic = 2 THEN ''High''
        ELSE ''Normal''
      END AS ntileBpHighLevel,
      CASE
        WHEN x.ntile_bpdystolic = 3 THEN ''Critical''
        WHEN x.ntile_bpdystolic = 2 THEN ''Low''
        ELSE ''Normal''
      END AS ntileBpLowLevel
    FROM (
      SELECT pdescid, summary,
        CASE
          WHEN heightIn = ''in'' THEN ROUND(height / 12, 2)
          WHEN heightIn = ''cm'' THEN ROUND(height / 30.48, 2)
          ELSE height
        END AS heightInFt,
        CASE
          WHEN weightIn = ''pd'' THEN ROUND(weight * 0.45, 2)
          ELSE weight
        END AS weightInKg,
        CASE
          WHEN bpSystolic > 110 AND bpDystolic > 90 THEN 1
          WHEN bpSystolic < 90 AND bpDystolic < 60 THEN -1
          ELSE 0
        END AS bloodpressure,
        patientid,
        row_number() OVER () AS row_number,
        dense_rank() OVER (ORDER BY summary) AS dense_summary,
        NTILE(3) OVER (ORDER BY bpsystolic) AS ntile_bpsystolic,
        NTILE(3) OVER (ORDER BY bpdystolic) AS ntile_bpdystolic
      FROM "medicalHealthCare".tblpatdes
    ) x';

  EXECUTE '
    INSERT INTO "lookupSchema".tbldocspecstage
    SELECT x.row_number, x.specid, x.specialization, x.degree, x.doctorid, x.yearsofexp, x.CountEXPbyDegree,
      x.dense_rank_speicialization, x.dense_rank_degree
    FROM (
      SELECT specid, specialization, doctorid,
        degree,
        yearsofexp,
        row_number() OVER () AS row_number,
        row_number() OVER (PARTITION BY degree, yearsofexp ORDER BY yearsofexp) AS CountEXPbyDegree,
        dense_rank() OVER (ORDER BY specialization) AS dense_rank_speicialization,
        dense_rank() OVER (ORDER BY degree) AS dense_rank_degree
      FROM "medicalHealthCare".tbldocspec
    ) x';
END;

----------------------------------CURSOR -------------------------------------------------------
CREATE OR REPLACE PROCEDURE "lookupSchema".patdesproc()
LANGUAGE plpgsql
AS $procedure$
DECLARE
  result varchar;
BEGIN
  EXECUTE 'SELECT combined_proc()' INTO result;
END;
$procedure$;
select * from "lookupSchema".tbltestemployee;
------------------------------------------CORRECT-------------------------------------
DO $$
declare
	result varchar;
BEGIN
  EXECUTE 'SELECT CURRENT_DATE' INTO result;
  -- You can perform additional operations with the result variable or do other tasks here
END;
$$ LANGUAGE plpgsql;
select CURRENT_DATE; 

select * from "lookupSchema".tbltestemployee;

DO $$
-- Declare the cursor
declare
my_cursor CURSOR FOR SELECT * FROM "lookupSchema".tbltestemployee;
 my_row "lookupSchema".tbltestemployee%ROWTYPE;
-- Open the cursor
begin
	OPEN my_cursor;
-- Fetch and process the rows
LOOP
  FETCH NEXT FROM my_cursor INTO my_row ;
  EXIT WHEN NOT FOUND;
 -- Perform operations on the fetched row(s)
  -- For example, you can print the values
  RAISE NOTICE 'Employee ID: %, FirstName:% , LastName: %, hiredate: %' , 
my_row.employeeid , 
my_row.firstname ,
my_row.lastname ,
my_row.hiredate;
END LOOP;
-- Close the cursor
CLOSE my_cursor;
END;
$$ LANGUAGE plpgsql;

------------------------CURSOR PARAM-------------------
DO $$
-- Declare the cursor
declare
	vemployeeId INT8 := 2;
    my_cursor CURSOR (p_employeeid INT8 ) FOR
SELECT * FROM "lookupSchema".tbltestemployee where employeeid = p_employeeid;
 my_row "lookupSchema".tbltestemployee%ROWTYPE;
-- Open the cursor
begin
	OPEN my_cursor(vemployeeId);
-- Fetch and process the rows
RAISE NOTICE '-----------------------------------------';
LOOP
  FETCH NEXT FROM my_cursor INTO my_row ;
  EXIT WHEN NOT FOUND;
 -- Perform operations on the fetched row(s)
  -- For example, you can print the values

  RAISE NOTICE 'Employee ID: %, FirstName:% , LastName: %, hiredate: %' , 
my_row.employeeid , 
my_row.firstname ,
my_row.lastname ,
my_row.hiredate;
END LOOP;
-- Close the cursor
CLOSE my_cursor;

END;
$$ LANGUAGE plpgsql;

--------------------------OR----------------------------------
DO $$
-- Declare the cursor
declare
	vemployeeId INT8;
    my_cursor CURSOR (p_employeeid INT8 ) FOR
SELECT * FROM "lookupSchema".tbltestemployee where employeeid = p_employeeid;
 my_row "lookupSchema".tbltestemployee%ROWTYPE;
-- Open the cursor
begin
	OPEN my_cursor(3);
-- Fetch and process the rows
RAISE NOTICE '-----------------------------------------';
LOOP
  FETCH NEXT FROM my_cursor INTO my_row ;
  EXIT WHEN NOT FOUND;
 -- Perform operations on the fetched row(s)
  -- For example, you can print the values

  RAISE NOTICE 'Employee ID: %, FirstName:% , LastName: %, hiredate: %' , 
my_row.employeeid , 
my_row.firstname ,
my_row.lastname ,
my_row.hiredate;
END LOOP;
-- Close the cursor
CLOSE my_cursor;

END;
$$ LANGUAGE plpgsql;

select * from "medicalHealthCare".tblbilling;
select * from "lookupSchema".tblbillingstage;






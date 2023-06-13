
CREATE TABLE "lookupSchema".tbltestemployee (
	employeeid int8 NOT NULL,
	firstname VARCHAR(50) not null,
	lastname VARCHAR(50) not null,
	hireDate date not NULL
);

insert into "lookupSchema".tbltestemployee (employeeid , firstname , lastname , hireDate)
values (1 , 'Ram', 'Nepali' , '5-13-2021'),
(2 , 'Harry', 'Styles' , '2-15-2020'),
(3 , 'Liam', 'Loren' , '7-23-2019'),
(4 , 'Gigi', 'Hadid' , '4-14-2017'),
(5 , 'Bella', 'Hadid' , '9-19-2022'),
(6 , 'Zayn', 'Malik' , '10-14-2015'),
(7 , 'Kristen', 'Rai' , '5-17-2012'),
(8 , 'Taylor', 'Swift' , '9-23-2020'),
(9 , 'Selena', 'Gomez' , '5-13-2015'),
(10 , 'Prabesh', 'Nepali' , '2-11-2011'),
(11 , 'Sita', 'Tamang' , '5-10-2012');

select * from tbltestemployee;

do $$
DECLARE
  -- Declare a record using %ROWTYPE attribute
 emp_rec  tbltestemployee%ROWTYPE;
--emp emp_record;
 --TYPE emp_record IS RECORD (
   -- employeeid   VARCHAR(20)
    /*firstname    "lookupSchema".tbltestemployee.firstname%TYPE,
    lastname    "lookupSchema".tbltestemployee.lastname%TYPE,
    hiredate     "lookupSchema".tbltestemployee.hiredate%TYPE*/
 -- );
  emp emp_rec;

BEGIN
  -- Assign values to record fields
  /*emp_rec := "lookupSchema".tbltestemployee(12, 'John', 'Doe', SYSDATE);
  
  -- Access record fields
  DBMS_OUTPUT.PUT_LINE(emp_rec.employeeid || ' ' || emp_rec.firstname || ' ' ||
                       emp_rec.lastname || ' ' || emp_rec.hiredate);

  -- Assign values to explicitly defined record fields
  emp.employeeid := 102;
  emp.firstname := 'Jane';
  emp.lastname := 'Smith';
  emp.hiredate := SYSDATE;
  
  -- Access explicitly defined record fields
  DBMS_OUTPUT.PUT_LINE(emp.employeeid || ' ' || emp.firstname || ' ' ||
                       emp.lastname || ' ' || emp.hiredate);*/
end $$;
/


DECLARE
  -- Declare a record using %ROWTYPE attribute
  emp_rec employees%ROWTYPE;

  -- Declare a record explicitly
  emp emp_record;

  -- Declare variables to match the record structure
  emp_employee_id employees.employee_id%TYPE;
  emp_first_name employees.first_name%TYPE;
  emp_last_name employees.last_name%TYPE;
  emp_hire_date employees.hire_date%TYPE;
BEGIN
  -- Assign values to record fields
  emp_rec := (101, 'John', 'Doe', current_date);
  
  -- Access record fields
  emp_employee_id := emp_rec.employee_id;
  emp_first_name := emp_rec.first_name;
  emp_last_name := emp_rec.last_name;
  emp_hire_date := emp_rec.hire_date;
  
  RAISE NOTICE '% % % %', emp_employee_id, emp_first_name, emp_last_name, emp_hire_date;

  -- Assign values to explicitly defined record fields
  emp.employee_id := 102;
  emp.first_name := 'Jane';
  emp.last_name := 'Smith';
  emp.hire_date := current_date;
  
  -- Access explicitly defined record fields
  RAISE NOTICE '% % % %', emp.employee_id, emp.first_name, emp.last_name, emp.hire_date;

END;
/

CREATE OR REPLACE PROCEDURE "lookupSchema".testproc()
 LANGUAGE plpgsql
AS $procedure$
declare 
-- emp_rec tbltestemployee%ROWTYPE;
begin
	
end;
$procedure$
;
select  "lookupSchema".testproc(9 , 'Hi');
--------------------------------------- CORRECT FORM-------------------------------------
CREATE OR REPLACE FUNCTION "lookupSchema".testfunc() 
RETURNS VOID AS $$
DECLARE
   emp_rec RECORD;
BEGIN
    -- Perform desired actions
    -- ... additional logic
    
    RAISE NOTICE 'HELLO';
END;
$$ LANGUAGE plpgsql;

select from "lookupSchema".testfunc();

CREATE TYPE emp_rec_type AS (
  employeeid   VARCHAR(20),
  firstname    VARCHAR(50),
  lastname     VARCHAR(50),
  hiredate     DATE
);




----
CREATE TYPE emp_rec_type AS (
  employeeid   VARCHAR(20),
  firstname    VARCHAR(50),
  lastname     VARCHAR(50),
  hiredate     DATE
);

DO $$
DECLARE
  emp_rec emp_rec_type;
  emp emp_rec_type;
BEGIN
  -- Assign values to record fields
  emp_rec.firstname := (SELECT  firstname FROM "lookupSchema".tbltestemployee WHERE employeeid = 1 LIMIT 1);
  
  -- Access record fields
  RAISE NOTICE '% % % %', emp_rec.employeeid, emp_rec.firstname, emp_rec.lastname, emp_rec.hiredate;

  -- Assign values to explicitly defined record fields
  emp.employeeid := 102;
  emp.firstname := 'Jane';
  emp.lastname := 'Smith';
  emp.hiredate := CURRENT_DATE;
  
  -- Access explicitly defined record fields
  RAISE NOTICE '% % % %', emp.employeeid, emp.firstname, emp.lastname, emp.hiredate;
END $$;














































declare
 type nametype is VARCHAR;
name nametype;

begin
	name := 'Karina';
	 DBMS_OUTPUT.PUT_LINE(name);
end
/

DO $$
DECLARE
  name VARCHAR;
BEGIN
  name := 'Karina';
  RAISE NOTICE 'Name: %', name;
END $$;

CREATE OR REPLACE FUNCTION "lookupSchema".testproc(param1 INT, param2 VARCHAR) 
RETURNS VOID AS $$
DECLARE
    -- Declare local variables
    local_var INT;
BEGIN
    -- Perform desired actions
    local_var := param1 + 1;
    RAISE NOTICE 'Local variable value: %', local_var;
    RAISE NOTICE 'Input parameter value: %', param2;
    -- ... additional logic
    
    -- Return value (if needed)
    -- RETURN value;
END;
$$ LANGUAGE plpgsql;

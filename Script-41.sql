------------------------CURSOR WITH PARAM-------------------
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

-----------------------------------EXCEPTION HANDLING ------------------------------------------------
DO $$
-- Declare the cursor
DECLARE
	vemployeeId INT8 := 2;
	my_cursor CURSOR (p_empfirstname VARCHAR(50) , p_emplastname VARCHAR(50)) FOR
		SELECT * FROM "lookupSchema".tbltestemployee WHERE firstname = p_empfirstname and lastname = p_emplastname;
	my_row "lookupSchema".tbltestemployee%ROWTYPE;
BEGIN
	-- Open the cursor
	OPEN my_cursor('Gigi' , 'Hadid');
	
	-- Fetch and process the rows
	RAISE NOTICE '-----------------------------------------';
	LOOP
		BEGIN
			FETCH NEXT FROM my_cursor INTO my_row;
			
			EXIT WHEN NOT FOUND;
			
			-- Perform operations on the fetched row(s)
			-- For example, you can print the values
			RAISE NOTICE 'Employee ID: %, FirstName:%, LastName: %, hiredate: %',
				my_row.employeeid,
				my_row.firstname,
				my_row.lastname,
				my_row.hiredate;
		EXCEPTION
			WHEN OTHERS THEN
				RAISE NOTICE 'Error occurred while processing the row: %', SQLERRM;
		END;
	END LOOP;
	
	-- Close the cursor
	CLOSE my_cursor;
END;
$$ LANGUAGE plpgsql;

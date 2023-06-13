create or replace function fn_mid(varchar, integer, integer)
returns varchar
as 
$$
begin 
	return substring($1,$2,$3);
end
$$
language plpgsql;

select fn_mid()


--use alias
create or replace function fn_mid(buffer varchar, startPos integer, len integer)
returns varchar
as 
$$		
begin 
	return substring(buffer , startPos , len);
end
$$
language plpgsql;

select fn_mid('software', 1,4)


selct 'use template'
create or replace function fnMakeFull(firstNme varchar, lastName varchar)
returns varchar 
as 
$$
begin 
	if firstName is null and lastName is null then 
		return null;
	elseif firstName is null and lastName is not null then 
		return lastName;
	elseif firstName is not null and lastName is null then 
		return firstName;
	else
		return concat(firstName,' ',lastName);
	end if;
end;
$$
language plpgsql

select * from fnMakeFull('Karina', 'Shrestha');

--use inout
--parameter type(in*|out|inout|VARIADIC***) *default **variable number of arguments
create or replace function fnSwap(inout num1 int, inout num2 int)
as 
$$
begin 
	select num1,num2 into num2,num1;

end;
$$
language plgsql;

select * from fnSwap(4,3);

create or replace function fnMean(numeric[])
returns numeric 
as 
$$
declare total numeric := 0;
			val numeric;
			cnt int :=0;
			n_array ALIAS for $1;
begin
	foreach val in array n_array
	loop
		total := total + val;
		cnt := cnt + 1;
	end loop;
	return total/cnt;
end;
$$
language plpgsql;

select fnMean(array[10,20,30,40,50])

select * from "lookupSchema".tbldoctor;
select * from "lookupSchema".tblheightstage;
select * from "lookupSchema".tblpatdes;
select * from "lookupSchema".tblpatdesstage;

select * from "medicalHealthCare".tblpatdoc;

















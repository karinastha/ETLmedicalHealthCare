-------------------------BASIC OF DYNAMIC FUNCTION -----------------------------------
--to create a parameterized stored function in PostgreSQL and call identity 
create or REPLACE function public.testing_function (p_num numeric , p_msg text)
returns text 
language 'plpgsql'
cost 100
volatile 
as $BODY$
declare 
v_return_msg text;
begin 
	v_return_msg := p_msg || ' ' || p_num;
end;
$BODY$

select public.testing_function (10 , 'Hello');

select * from "lookupSchema".tblpatdesstage;
select * from "lookupSchema".tblpatientstage;
select * from "lookupSchema".tbldocspecstage;

-----------------DETERMINING WHICH PATIENT IS SUFFERING FROM WHICH DISEASE (PATDES TABLE AND PATIENT TABLE)---------------------------------
CREATE OR REPLACE FUNCTION get_patient_details(patientid INT)
  RETURNS TABLE (firstname VARCHAR, summary VARCHAR)
  LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY EXECUTE 
    'SELECT p.firstname, d.summary
    FROM "lookupSchema".tblpatientstage p
    JOIN "lookupSchema".tblpatdesstage d ON p.patientid = d.patientid
    WHERE p.patientid = $1'
    USING patientid;
END;
$$;

SELECT * FROM get_patient_details(9);
SELECT * FROM get_patient_details(CAST(15 AS INT));

CREATE OR REPLACE FUNCTION patient_details(patientid INT)
  RETURNS TABLE (firstname VARCHAR, lastname VARCHAR , summary VARCHAR)
  LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY EXECUTE 
    'SELECT p.firstname, p.lastname, d.summary
    FROM "lookupSchema".tblpatientstage p
    JOIN "lookupSchema".tblpatdesstage d ON p.patientid = d.patientid
    WHERE p.patientid = $1'
    USING patientid;
END;
$$;

SELECT * FROM get_patient_details(1);

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



























select * from "lookupSchema".tblpatientstage;
select * from "lookupSchema".tblpatdesstage;
select * from "lookupSchema".tblbillingstage;
select * from "lookupSchema".tbldocspecstage;
select * from "lookupSchema".tbldoctorstage;
select * from"lookupSchema".tblstagedocappoint;
select * from"medicalHealthCare".tbldocspec;
select * from "medicalHealthCare".tbldoctor;
select * from "medicalHealthCare".tbldoctorroutine;
select * from "medicalHealthCare".tblpatient;
select * from "lookupSchema".tblstagedocappoint;
select * from "lookupSchema".tbldocspecstage;

select * from "medicalHealthCare".tblappointment;
select * from "lookupSchema".tblappointmentstage;

select * from "medicalHealthCare".tblpatdes;

select * from 


select count(*) , degree  from "medicalHealthCare".tbldocspec group by (degree) order by 1 desc;
update "medicalHealthCare".tbldocspec set degree = 'MBBS' where specid > 0 and specid <= 200;
update "medicalHealthCare".tbldocspec set degree = 'MD' where specid > 200 and specid <= 400;
update "medicalHealthCare".tbldocspec set degree = 'BDS' where specid > 400 and specid <= 600;
update "medicalHealthCare".tbldocspec set degree = 'PHD' where specid > 600 and specid <= 800;
update "medicalHealthCare".tbldocspec set degree = 'PSYD' where specid > 800 and specid <= 1000;
commit;
select * from"medicalHealthCare".tbldocspec;

update "medicalHealthCare".tbldocspec set specialization = 'Anesthesiology' where specid > 0 and specid <= 100;
update "medicalHealthCare".tbldocspec set specialization = 'Oncology' where specid > 40 and specid <= 80;
update "medicalHealthCare".tbldocspec set specialization = 'Cardiology' where specid > 100 and specid <= 200;
update "medicalHealthCare".tbldocspec set specialization = 'Dermatology' where specid > 200 and specid <= 300;
update "medicalHealthCare".tbldocspec set specialization = ' Endocrinology' where specid > 300 and specid <= 400;
update "medicalHealthCare".tbldocspec set specialization = ' Gastroenterology' where specid > 400 and specid <= 500;
update "medicalHealthCare".tbldocspec set specialization = 'Hematology' where specid > 500 and specid <= 600;
update "medicalHealthCare".tbldocspec set specialization = 'Infectious Disease' where specid > 600 and specid <= 700;
update "medicalHealthCare".tbldocspec set specialization = 'Nephrology' where specid > 700 and specid <= 800;
update "medicalHealthCare".tbldocspec set specialization = 'Neurology' where specid > 800 and specid <= 900;
update "medicalHealthCare".tbldocspec set specialization = 'Obstetrics and Gynecology' where specid > 900 and specid <= 1000;

alter table "medicalHealthCare".tbldocspec add column YearsOfExp numeric(15);
update "medicalHealthCare".tbldocspec set yearsofexp = 15 where specid > 0 and specid <= 50;
update "medicalHealthCare".tbldocspec set yearsofexp = 5 where specid > 50 and specid <= 80;
update "medicalHealthCare".tbldocspec set yearsofexp = 12 where specid > 80 and specid <= 100;
update "medicalHealthCare".tbldocspec set yearsofexp = 20 where specid > 100 and specid <= 150;
update "medicalHealthCare".tbldocspec set yearsofexp = 7 where specid > 150 and specid <= 200;
update "medicalHealthCare".tbldocspec set yearsofexp = 25 where specid > 200 and specid <= 250;
update "medicalHealthCare".tbldocspec set yearsofexp = 6 where specid > 250 and specid <= 300;
update "medicalHealthCare".tbldocspec set yearsofexp = 13 where specid > 300 and specid <= 350;
update "medicalHealthCare".tbldocspec set yearsofexp = 30 where specid > 350 and specid <= 450;
update "medicalHealthCare".tbldocspec set yearsofexp = 28 where specid > 450 and specid <= 550;
update "medicalHealthCare".tbldocspec set yearsofexp = 3 where specid > 550 and specid <= 650;
update "medicalHealthCare".tbldocspec set yearsofexp = 28 where specid > 650 and specid <= 750;
update "medicalHealthCare".tbldocspec set yearsofexp = 11 where specid > 750 and specid <= 800;
update "medicalHealthCare".tbldocspec set yearsofexp = 21 where specid > 800 and specid <= 950;
update "medicalHealthCare".tbldocspec set yearsofexp = 40 where specid > 800 and specid <= 1000;

----------------------------------DENSE_RANK---------------------------------------------------------------
---specializtion, degree, experience kati ota cha identify [1,2,3,4,5]
select 
	specialization,
	degree,
	yearsofexp,
	row_number() over() as row_number ,
	row_number() over(partition by degree, yearsofexp order by yearsofexp) as CountEXPbyDegree,
	dense_rank() over(order by specialization) as dense_rank_speicialization,
	dense_rank() over(order by degree) as dense_rank_degree
from "medicalHealthCare".tbldocspec;


select distinct specialization from "medicalHealthCare".tbldocspec;

--each no . of exp bhako kati jana DR. available
select degree, yearsofexp, row_number() over(partition by degree, yearsofexp order by yearsofexp) as row_yearsOfExperience from
"medicalHealthCare".tbldocspec;

----------------------------------------------ROW_NUMBER-----------------------------------------------------------------
select
	specialization,
	degree,
	yearsofexp,
	row_number() over() as row_number 
from "medicalHealthCare".tbldocspec;

select
	specialization,
	degree,
	yearsofexp,
	row_number() over() as row_number 
from "medicalHealthCare".tbldocspec;

select * from "medicalHealthCare".tbldoctorroutine;
select
	time,
	days,
	row_number() over() as row_number 
from "medicalHealthCare".tbldoctorroutine;


-----------------------------------------------------NTILE------------------------------------------------------------
-- (1000/4) we wil use this record in CASE TO identify the shift of doctor LIKE 1,2 -early morning(whose quartile is 1),
-- 3,4 
select 
	doctorid,
	time,
	row_number() over() as row_number,
	NTILE(8) over(order by time) as quartile
	from "medicalHealthCare".tbldoctorroutine;

select * from "medicalHealthCare".tblpatdes;
select * from "lookupSchema".tblpatdesstage;

-- normal , high , critical-3
select 
	--row_number() over(partition by summary) as row_number,
    row_number() over() as row_number,
	pdescid , summary , 
	dense_rank() over(order by summary) as dense_summary, height ,heightin , weight , weightin ,patientid ,
	dense_rank() over(order by summary) as dense_summary, bpsystolic ,
	NTILE(3) over(order by bpsystolic) as ntile_bpsystolic, bpdystolic ,
	NTILE(3) over(order by bpdystolic) as ntile_bpdystolic
	from "medicalHealthCare".tblpatdes;

select * from "lookupSchema".tblbillingstage;
select * from "medicalHealthCare".tblbilling;

select 
    row_number() over() as row_number,
	dateofadmission , dateofdischarge , dateofbill, dateofpayment ,
	--dense_rank() over(order by summary) as dense_summary, height ,heightin , weight , weightin ,patientid ,
	NTILE(2) over(partition by EXTRACT(YEAR FROM dateofpayment) order by totalamount) as ntile_dateOfPayment , totalamount 
	--NTILE(6) over(order by totalamount) as ntile_totalamount
	from "medicalHealthCare".tblbilling;

SELECT EXTRACT(YEAR FROM dateofpayment) AS year FROM "medicalHealthCare".tblbilling;
select EXTRACT(YEAR FROM dateofpayment) ,totalamount , NTILE(2) over(partition by EXTRACT(YEAR FROM dateofpayment) 
order by totalamount) FROM "medicalHealthCare".tblbilling;


select * from "medicalHealthCare".tblpatdes;

select * from "lookupSchema".tblbillingstage;

select * from "lookupSchema".tblpatdesstage;
select * from "lookupSchema".tbldoctorstage;

select * from "lookupSchema".tblappointmentstage;

select * from "lookupSchema".tblpatientstage;
select * from "lookupSchema".tblstagedocappoint;
select * from "lookupSchema".tblpatdocstage;

select * from "lookupSchema".tblstagedocappoint;

select * from 
"lookupSchema".tbldoctorstage;

select * from "medicalHealthCare".tblpatdes;

call "dbMedicalLoad".procbillingload();




update "medicalHealthCare".tblpatdes set bpsystolic = 130 where pdescid = 8;
update "medicalHealthCare".tblpatdes set bpdystolic = 90 where pdescid = 9;
update "medicalHealthCare".tblpatdes set bpdystolic = 120 where pdescid = 1;
update "medicalHealthCare".tblpatdes set bpdystolic = 100 where pdescid = 2;

CREATE OR REPLACE PROCEDURE "lookupSchema".patientproc()
 LANGUAGE plpgsql
AS $procedure$
	declare result varchar;
begin
	insert into "lookupSchema".tblpatientstage
select x.patientid , x.patientfirstname ,x.patientlastname, x.patientaddress , x.gender, x.contact, x.dateofbirth,
x.age, x.agecategory from (
	select patientid, patientfirstname, patientlastname, patientaddress ,concat(984,contact) contact  ,
	date_part('year',age(dateofbirth)) age,
case
WHEN upper(gender) ='FEMALE' or gender = 'F' then '0'
WHEN upper(gender) ='MALE' or gender = 'M' then '1'
ELSE gender 
END as gender, 
case
when date_part('year',age(dateofbirth)) >= 41 then 'OLD'
when date_part('year',age(dateofbirth)) <= 40 and date_part('year',age(dateofbirth)) >= 26 then 'MID'
when date_part('year',age(dateofbirth)) <= 25  then 'YOUNG'
END as ageCategory,dateofbirth 
from "medicalHealthCare".tblpatient
) x;	
end;
$procedure$
;






update "medicalHealthCare".tbldoctorroutine set time = '1:21' where doctorroutineid > 0 and doctorroutineid<= 50;
update "medicalHealthCare".tbldoctorroutine set time = '2:30' where doctorroutineid > 50 and doctorroutineid<= 100;
update "medicalHealthCare".tbldoctorroutine set time = '3:40' where doctorroutineid > 100 and doctorroutineid<= 150;
update "medicalHealthCare".tbldoctorroutine set time = '4:12' where doctorroutineid > 150 and doctorroutineid<= 200;
update "medicalHealthCare".tbldoctorroutine set time = '5:45' where doctorroutineid > 200 and doctorroutineid<= 250;
update "medicalHealthCare".tbldoctorroutine set time = '6:49' where doctorroutineid > 250 and doctorroutineid<= 300;
update "medicalHealthCare".tbldoctorroutine set time = '7:16' where doctorroutineid > 300 and doctorroutineid<= 350;
update "medicalHealthCare".tbldoctorroutine set time = '8:37' where doctorroutineid > 350 and doctorroutineid<= 400;
update "medicalHealthCare".tbldoctorroutine set time = '9:00' where doctorroutineid > 400 and doctorroutineid<= 450;
update "medicalHealthCare".tbldoctorroutine set time = '10:01' where doctorroutineid > 450 and doctorroutineid<= 500;
update "medicalHealthCare".tbldoctorroutine set time = '11:21' where doctorroutineid > 500 and doctorroutineid<= 550;
update "medicalHealthCare".tbldoctorroutine set time = '12:41' where doctorroutineid > 550 and doctorroutineid<= 600;
update "medicalHealthCare".tbldoctorroutine set time = '13:47' where doctorroutineid > 600 and doctorroutineid<= 650;
update "medicalHealthCare".tbldoctorroutine set time = '14:38' where doctorroutineid > 650 and doctorroutineid<= 700;
update "medicalHealthCare".tbldoctorroutine set time = '15:34' where doctorroutineid > 700 and doctorroutineid<= 750;
update "medicalHealthCare".tbldoctorroutine set time = '16:21' where doctorroutineid > 750 and doctorroutineid<= 800;
update "medicalHealthCare".tbldoctorroutine set time = '17:28' where doctorroutineid > 800 and doctorroutineid<= 850;
update "medicalHealthCare".tbldoctorroutine set time = '18:15' where doctorroutineid > 850 and doctorroutineid<= 900;
update "medicalHealthCare".tbldoctorroutine set time = '19:11' where doctorroutineid > 900 and doctorroutineid<= 925;
update "medicalHealthCare".tbldoctorroutine set time = '20:26' where doctorroutineid > 925 and doctorroutineid<= 945;
update "medicalHealthCare".tbldoctorroutine set time = '21:38' where doctorroutineid > 945 and doctorroutineid<= 965;
update "medicalHealthCare".tbldoctorroutine set time = '22:16' where doctorroutineid > 965 and doctorroutineid<= 975;
update "medicalHealthCare".tbldoctorroutine set time = '23:05' where doctorroutineid > 975 and doctorroutineid<= 985;
update "medicalHealthCare".tbldoctorroutine set time = '24:09' where doctorroutineid > 985 and doctorroutineid<= 1000;



















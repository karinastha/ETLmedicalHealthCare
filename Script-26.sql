select t1.days,count(t1.appointdate) as numberoftimes from (
select "medicalHealthCare".tbldoctor.doctorid , patientid, appointdate, firstname, appointtime, appointstatus, days
from 
"medicalHealthCare".tbldoctor inner join "medicalHealthCare".tblappointment
on ("medicalHealthCare".tbldoctor.doctorid ="medicalHealthCare".tblappointment.doctorid )
inner join "medicalHealthCare".tbldoctorroutine
on ("medicalHealthCare".tbldoctor.doctorid ="medicalHealthCare".tbldoctorroutine.doctorid)
) as t1 group by days;


CREATE TABLE "lookupSchema".tblStageDocAppoint(
	id int4 NOT NULL,
	doctorid int4 NOT NULL,
	patientid int4 NOT NULL,
	firstname varchar(50) not null,
	lastname varchar(50) not null,
	appointtime time not null,
	appointdate date not null,
	appointStatus varchar(50) not null,
	days varchar(50) not null,
	CONSTRAINT tbldocappoint_pkey PRIMARY KEY (id),
	CONSTRAINT fk_doctor FOREIGN KEY(doctorId) REFERENCES "medicalHealthCare".tbldoctor(doctorId),
	CONSTRAINT fk_patient FOREIGN KEY(patientId) REFERENCES "medicalHealthCare".tblpatient(patientId)
);


--creating sequence, auto increment
create sequence docappoint_seq  start 1 increment 1 OWNED BY "lookupSchema".tblstagedocappoint.id;
alter table "lookupSchema".tblstagedocappoint alter column id SERIAL primary key;
ALTER TABLE "lookupSchema".tblstagedocappoint ALTER COLUMN id SET DEFAULT nextval('docappoint_seq');


ALTER TABLE test1 ADD COLUMN id INTEGER;
CREATE SEQUENCE test_id_seq OWNED BY test1.id; 
ALTER TABLE test1 ALTER COLUMN id SET DEFAULT nextval('test_id_seq');
UPDATE test1 SET id = nextval('test_id_seq');

select * from "lookupSchema".tblStageDocAppoint;

insert into "lookupSchema".tblStageDocAppoint (doctorid, patientid,firstname,lastname,appointtime,appointdate,appointstatus,days) 
select "medicalHealthCare".tbldoctor.doctorid , patientid,  firstname, lastname, appointtime, appointdate, appointstatus, days
from 
"medicalHealthCare".tbldoctor inner join "medicalHealthCare".tblappointment
on ("medicalHealthCare".tbldoctor.doctorid ="medicalHealthCare".tblappointment.doctorid )
inner join "medicalHealthCare".tbldoctorroutine
on ("medicalHealthCare".tbldoctor.doctorid ="medicalHealthCare".tbldoctorroutine.doctorid);

select * from "lookupSchema".tblpatientstage;
select * from "lookupSchema".tblpatdocstage;
select * from "lookupSchema".tbldoctorstage;


select * from "lookupSchema".tblpatientstage
right outer join "lookupSchema".tblpatdocstage on
("lookupSchema".tblpatientstage.patientid = "lookupSchema".tblpatdocstage.patientid);
--left outer join "lookupSchema".tbldoctorstage 
--on ("lookupSchema".tbldoctorstage.doctorid = "lookupSchema".tblpatdocstage.doctorid ) ;


--stage data for number of patients who are critical in each genre whose are older than average patient age
select count(patientId) , appointgenre from  "lookupSchema".tblappointmentstage group by appointgenre ;
select count(patientId) , isCritical from "lookupSchema".tblappointmentstage group by isCritical;


select count(patientId) , appointgenre from  "lookupSchema".tblappointmentstage where isCritical = 1  group by appointgenre  ;

select count(patientId) , appointgenre   from  "lookupSchema".tblappointmentstage where
patientid in (
select patientid from "lookupSchema".tblpatientstage where age > (
	select AVG(age) from "lookupSchema".tblpatientstage )
) and 
isCritical = 0 group by appointgenre ;


-- "lookupSchema".tblstagedocappoint definition

-- Drop table

-- DROP TABLE "lookupSchema".tblstagedocappoint;
create sequence criticalGenre_seq  start 1 increment 1 OWNED BY "lookupSchema".tblCriticalByGenre.id;
alter table "lookupSchema".tblCriticalByGenre alter column id SERIAL primary key;
ALTER TABLE "lookupSchema".tblCriticalByGenre ALTER COLUMN id SET DEFAULT nextval('criticalGenre_seq');


CREATE TABLE "lookupSchema".tblCriticalByGenre (
	id int4 NOT NULL,
	count numeric(15) not null,
	Genre varchar(50) not null,
	CONSTRAINT tblCriticalgenre_pkey PRIMARY KEY (id)
);

CREATE TABLE "lookupSchema".tblNotCriticalByGenre (
	id int4 NOT NULL,
	count numeric(15) not null,
	Genre varchar(50) not null,
	CONSTRAINT tblNotCriticalgenre_pkey PRIMARY KEY (id)
);

create sequence NotcriticalGenre_seq  start 1 increment 1 OWNED BY "lookupSchema".tblNotCriticalByGenre.id;
alter table "lookupSchema".tblCriticalByGenre alter column id SERIAL primary key;
ALTER TABLE "lookupSchema".tblNotCriticalByGenre ALTER COLUMN id SET DEFAULT nextval('NotcriticalGenre_seq');

insert into "lookupSchema".tblCriticalByGenre (count , Genre)
select count(patientId) , appointgenre   from  "lookupSchema".tblappointmentstage where
patientid in (
select patientid from "lookupSchema".tblpatientstage where age > (
	select AVG(age) from "lookupSchema".tblpatientstage )
) and 
isCritical = 1 group by appointgenre ;

select * from "lookupSchema".tblNotcriticalbygenre;
truncate table "lookupSchema".tblNotcriticalbygenre;

insert into "lookupSchema".tblNotCriticalByGenre (count , Genre)
select count(patientId) , appointgenre   from  "lookupSchema".tblappointmentstage where
patientid in (
select patientid from "lookupSchema".tblpatientstage where age > (
	select AVG(age) from "lookupSchema".tblpatientstage )
) and 
isCritical = 0 group by appointgenre ;

select * from "lookupSchema".tblcriticalbygenre;

select * from "lookupSchema".tblbillingstage;

CREATE OR REPLACE PROCEDURE "lookupSchema".NotCriticalproc() 
LANGUAGE plpgsql
as
$$
begin
	insert into "lookupSchema".tblNotCriticalByGenre (count , Genre)
select count(patientId) , appointgenre   from  "lookupSchema".tblappointmentstage where
patientid in (
select patientid from "lookupSchema".tblpatientstage where age > (
	select AVG(age) from "lookupSchema".tblpatientstage )
) and 
isCritical = 0 group by appointgenre ;	
end;
$$;

call "lookupSchema".NotCriticalproc(); 
commit;

CREATE OR REPLACE PROCEDURE "lookupSchema".Criticalproc() 
LANGUAGE plpgsql
as
$$
begin
	insert into "lookupSchema".tblCriticalByGenre (count , Genre)
select count(patientId) , appointgenre   from  "lookupSchema".tblappointmentstage where
patientid in (
select patientid from "lookupSchema".tblpatientstage where age > (
	select AVG(age) from "lookupSchema".tblpatientstage )
) and 
isCritical = 1 group by appointgenre ;
end;
$$;

select * from "lookupSchema".tblcriticalbygenre;
truncate table "lookupSchema".tblcriticalbygenre;
call "lookupSchema".Criticalproc(); 


CREATE OR REPLACE PROCEDURE "lookupSchema".DocAppointproc() 
LANGUAGE plpgsql
as
$$
begin
insert into "lookupSchema".tblStageDocAppoint (doctorid, patientid,firstname,lastname,appointtime,appointdate,appointstatus,days) 
select "medicalHealthCare".tbldoctor.doctorid , patientid,  firstname, lastname, appointtime, appointdate, appointstatus, days
from 
"medicalHealthCare".tbldoctor inner join "medicalHealthCare".tblappointment
on ("medicalHealthCare".tbldoctor.doctorid ="medicalHealthCare".tblappointment.doctorid )
inner join "medicalHealthCare".tbldoctorroutine
on ("medicalHealthCare".tbldoctor.doctorid ="medicalHealthCare".tbldoctorroutine.doctorid);
end;
$$;
call "lookupSchema".DocAppointproc();
select * from "lookupSchema".tblstagedocappoint;
truncate table "lookupSchema".tblstagedocappoint;

select * from "lookupSchema".tblnotcriticalbygenre;
select * from "lookupSchema".tblcriticalbygenre;

alter table "lookupSchema".tblnotcriticalbygenre add constraint genre unique(GENRE) deferrable initially IMMEDIATE;
alter table "lookupSchema".tblcriticalbygenre add constraint genre_critical unique(GENRE) deferrable initially IMMEDIATE;

 

--pivot
id INTEGER, product TEXT, month TEXT, amount INTEGER


CREATE TABLE "lookupSchema".tbltest (
	id int4 NOT NULL,
	product varchar(50) NOT NULL,
	month varchar(50) NOT NULL,
	amount int8 NOT NULL
	--CONSTRAINT tblpatient_pkey PRIMARY KEY (id)
);
 insert into "lookupSchema".tbltest values  (105, 'p1','m2',2000),
 (106, 'p2','m3',76000), (107, 'p3','m1',90000) ,  (108, 'p4','m1',85000);
select * from "lookupSchema".tbltest;

SELECT * FROM "lookupSchema".tbltest 
cross(
SUM(amount) FOR month in
('m1', 'm2', 'm3', 'm4'
)) 
AS pivot_table ORDER BY product;

SELECT * FROM  
crosstab(
select product , month , SUM(amount) from "lookupSchema".tbltest FOR month in
('m1', 'm2', 'm3', 'm4')) 
AS pivot_table ORDER BY product;

CREATE EXTENSION IF NOT EXISTS tablefunc;
SELECT * FROM crosstab( 'SELECT product, month, sum(sales) 
FROM sales GROUP BY 1, 2 ORDER BY 1, 2', 'SELECT DISTINCT month FROM sales ORDER BY 1' ) 
AS pivot_table(product TEXT, "January" INTEGER, "February" INTEGER, "March" INTEGER, "April" INTEGER, "May" INTEGER, "June" INTEGER);


product | January | February | March | April | May | June
---------+---------+----------+-------+-------+-----+-----
Gizmo   |   500   |    750   |  800  |  900  | 700 | 650
Widget  |   700   |    850   | 1000  |  900  | 750 | 600



select * from "lookupSchema".tblpatientstage;
select * from "lookupSchema".tblbillingstage;
select * from "lookupSchema".tblstagedocappoint;
select * from "lookupSchema".tblpatientstage;

SELECT *
FROM crosstab( 'select student, subject, evaluation_result from evaluations order by 1,2')
     AS final_result(Student TEXT, Geography NUMERIC,History NUMERIC,Language NUMERIC,Maths NUMERIC,Music NUMERIC);
    
SELECT * FROM  
crosstab(
select product , month , SUM(amount) from "lookupSchema".tbltest FOR month in
('m1', 'm2', 'm3', 'm4')) 
AS pivot_table ORDER BY product;

SELECT student, subject, evaluation_result FROM evaluations ORDER BY 1,2
AS final_result(Student TEXT, Geography NUMERIC,History NUMERIC,Language NUMERIC,Maths NUMERIC,Music NUMERIC)

SELECT *
FROM crosstab( 'select student, subject, evaluation_result from evaluations order by 1,2')
     AS final_result(Student TEXT, Geography NUMERIC,History NUMERIC,Language NUMERIC,Maths NUMERIC,Music NUMERIC);

select * from "lookupSchema".tbltest 
as 
final_test(pro)













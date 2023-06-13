CREATE OR REPLACE PROCEDURE "lookupSchema".billingproc()
 LANGUAGE plpgsql
AS $procedure$
begin
	insert into "lookupSchema".tblbillingstage
select x.billid , x.row_number , x.patientid ,x.doctorid, x.dateofadmission ,
x.dateofdischarge,x.stayduration, x.dateofbill, x.dateofpayment,
x.ntiledateofpayment,
case 
when ntiledateofpayment = 1 then 'Q1'
when ntiledateofpayment = 2 then 'Q2'
when ntiledateofpayment = 3 then 'Q3'
else 'Q4'
end as QuaterDateOfPayment,  x.ntiletotalamount ,
case 
when ntiletotalamount = 1 then 'Q1'
when ntiletotalamount = 2 then 'Q2'
when ntiletotalamount = 3 then 'Q3'
else 'Q4'
end as QuaterTotalAmount,
ROUND(x.amountdollar,2) as amountdollar,
"lookupSchema".calculateVatTax(x.totalamount, x.tax, x.vat) as calculatevattax
from (
	select billid, patientid, doctorid, dateofadmission ,dateofdischarge,
case 
WHEN dateofdischarge is null then null
when ( dateofdischarge - dateofadmission) >= 0 then dateofdischarge - dateofadmission
when ( dateofdischarge - dateofadmission) < 0 then 0
END as stayduration ,dateofbill , dateofpayment , tax , vat,
case 
when currency = 'Rs' then totalamount / 130
when currency = 'Pound' then totalamount * 0.8
else totalamount 
end as amountdollar,
 row_number() over() as row_number,
	NTILE(4) over(partition by EXTRACT(YEAR FROM dateofpayment) order by totalamount) as ntiledateOfPayment , totalamount ,
	NTILE(4) over(order by totalamount) as ntiletotalamount
from "medicalHealthCare".tblbilling ) x;	
end;
$procedure$
;
call "dbMedicalLoad".procbillingload();

CREATE OR REPLACE PROCEDURE "dbMedicalLoad".procbillingload()
 LANGUAGE plpgsql
AS $procedure$
begin
--create EXTENSION dblink;
insert into "dbMedicalFinal"."dbMedicalLoad".tblbillingload 
SELECT * FROM dblink('dbname=dbMedical user=postgres password=rootpassword host=localhost', 
'SELECT * FROM "lookupSchema".tblbillingstage')
AS t(
	billid int8,
	row_number numeric(15),
	patientid int8,
	doctorid int8,
	dateofadmission date,
	dateofdischarge date,
	stayduration numeric(50),
	dateofbill date,
	dateofpayment date,
	ntileDateOfPayment numeric(15),
	QuarterDateOfPayment varchar(30),
	ntileTotalAmount numeric(15),
	QuarterTotalAmount varchar(30),
	amountdollar numeric,
	calculatevattax numeric(50)
);	--temporary data mapping 
end;
$procedure$
;

call "dbMedicalLoad".procbillingload();


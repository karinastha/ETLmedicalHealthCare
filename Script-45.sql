-- "medicalHealthCare".tblbilling definition

-- Drop table

-- DROP TABLE "medicalHealthCare".tblbilling;

CREATE TABLE "stagingSchema".tblbilling (
	billid int8 NULL,
	patientid int8 NOT NULL,
	doctorid int8 NOT NULL,
	dateofadmission date NOT NULL,
	dateofdischarge date NOT NULL,
	dateofbill date NOT NULL,
	dateofpayment date NOT NULL,
	totalamount numeric NOT NULL,
	tax numeric NOT NULL,
	vat numeric NOT NULL,
	currency varchar(50) NOT NULL
);

COPY  "stagingSchemas".tblbillpayment(billid, dateofbill , dateofpayment) 
FROM '"D:\Csvfile\billPayment.csv"' 
WITH (FORMAT csv, HEADER);


COPY "stagingSchemas".tblbillpayment (billid, dateofbill, dateofpayment)
FROM 'D:/Csvfile/billPayment.csv' 
WITH (FORMAT csv, HEADER);

create table "stagingSchemas".tblbillPayment(
	billid int8 null,
	dateofbill date not null,
	dateofpayment date not NULL
);
select * from "stagingSchemas".tblbillpayment;



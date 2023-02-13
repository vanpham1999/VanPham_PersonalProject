
start "C:\Users\16828\Desktop\Project2bc_vp.sql"

--Create your output file (include the full path). This will start logging to the specified file.
spool 'C:\Users\16828\Desktop\Project3_vp.txt'

-- This will ensure that all input and output is logged to the file.
set echo on

--Van Pham
--INSY 3304-002
--Project 3

--1. Set the default column width format to accommodate the column heading sizes (for CHAR and VARCHAR columns)
COLUMN 	BillingType 		FORMAT 	a20
COLUMN 	BlockCode 	FORMAT 	a10
COLUMN 	ApptReasonCode		FORMAT 	a15
COLUMN 	ApptStatusCode		FORMAT	a15
COLUMN 	PmtStatusCode		FORMAT 	a15
COLUMN  PatientPhone		FORMAT  a13

ALTER SESSION SET nls_date_format = 'DD-MON-YYYY hh24:mi';

--2. Line size should be set to 125 to minimize column wrapping.

SET LINESIZE 125

--3. Properly use table aliases and dot notation where applicable.

--4. Change the name of the ApptDate column to ApptDateTime 

ALTER TABLE APPOINTMENT_vp
RENAME COLUMN ApptDate TO ApptDateTime;

--Update all appointments with their correct date and time values in the ApptDateTime column.

UPDATE APPOINTMENT_vp
SET	ApptDateTime = '25-SEP-2021 09:00'
WHERE 	ApptID = 101;

UPDATE APPOINTMENT_vp
SET	ApptDateTime = '25-SEP-2021 09:00'
WHERE 	ApptID = 102;

UPDATE APPOINTMENT_vp
SET	ApptDateTime = '25-SEP-2021 10:00'
WHERE 	ApptID = 103;

UPDATE APPOINTMENT_vp
SET	ApptDateTime = '25-SEP-2021 10:30'
WHERE 	ApptID = 104;

UPDATE APPOINTMENT_vp
SET	ApptDateTime = '25-SEP-2021 10:30'
WHERE 	ApptID = 105;

UPDATE APPOINTMENT_vp
SET	ApptDateTime = '25-SEP-2021 10:30'
WHERE 	ApptID = 106;

UPDATE APPOINTMENT_vp
SET	ApptDateTime = '25-SEP-2021 11:00'
WHERE 	ApptID = 107;

UPDATE APPOINTMENT_vp
SET	ApptDateTime = '25-SEP-2021 11:30'
WHERE 	ApptID = 108;

UPDATE APPOINTMENT_vp
SET	ApptDateTime = '25-SEP-2021 02:30'
WHERE 	ApptID = 109;

UPDATE APPOINTMENT_vp
SET	ApptDateTime = '26-SEP-2021 08:30'
WHERE 	ApptID = 110;

UPDATE APPOINTMENT_vp
SET	ApptDateTime = '26-SEP-2021 08:30'
WHERE 	ApptID = 111;

COMMIT;

--Drop the ApptTime column.

ALTER TABLE APPOINTMENT_vp
DROP  COLUMN 	ApptTime;


--5. ALready changed the data type

--6. Add a new appointment.  Generate the ApptID by incrementing the max ApptID by 1.  

INSERT INTO APPOINTMENT_vp
VALUES ((SELECT MAX(ApptID) FROM APPOINTMENT_vp) + 1, '26-SEP-2021 11:00', 15, 'SP', NULL, 1, 'CN', 'NP');


INSERT INTO APPTDETAIL_vp
VALUES ((SELECT MAX(ApptID) FROM APPOINTMENT_vp), 'PT', 'L4');


--7. Add a new appointment.  Generate the ApptID for by incrementing the max ApptID by 1.

INSERT INTO APPOINTMENT_vp
VALUES ((SELECT MAX(ApptID) FROM APPOINTMENT_vp) + 1, '26-SEP-2021 1:00', 101, 'I', 323, 3, 'NC', 'NP');


INSERT INTO APPTDETAIL_vp
VALUES ((SELECT MAX(ApptID) FROM APPOINTMENT_vp), 'PT', 'L4') ;


--8.Add a new appointment status

INSERT INTO APPTSTATUS_vp
VALUES ('RS','Rescheduled');


--9.Change the ApptStatus for ApptID 108 to “RS”

UPDATE APPOINTMENT_vp
SET	ApptStatusCode = 'RS'
WHERE 	ApptID = 108;

--10.Commit all changes above before proceeding to the next step.

COMMIT;

--11.List the patient ID, first name, and last name for all patients for whom no phone number exists.

SELECT PatientID, PatientFName, PatientLName 
      FROM PATIENT_vp 
     WHERE PatientPhone IS NULL ;

--12.List the count of unique insurance companies found in the Appointment table.  Use Insurance Co Count as the column heading. 

SELECT COUNT(DISTINCT InsCoID) AS "Insurance Co Count"
      FROM APPOINTMENT_vp ;

--13.List the ApptReasonCode and count of appointments for each reason code.  Use the following column headings:  ReasonCode, ApptCount.  Hint:  Use a GROUP BY clause.

SELECT ApptReasonCode AS "ReasonCode", Count(ApptID) AS "ApptCount"
FROM APPTDETAIL_vp 
GROUP BY ApptReasonCode;

--14. List the BillingType and count of appointments for each billing type.  Sort by count.  Hint:  Use a GROUP BY clause.

SELECT BillingType AS "BillingType", Count(ApptID) AS "Count of Appointments"
FROM APPOINTMENT_vp 
GROUP BY BillingType
ORDER BY COUNT(ApptID);

--15. List all rows and all columns from the ApptDetail table; sort by ApptID then by ReasonCode, both in ascending order.Use the following column headings: ApptID, ReasonCode, BlockCode.

SELECT ApptID AS "ApptID", ApptReasonCode AS "ReasonCode", BlockCode  
FROM APPTDETAIL_vp
ORDER BY ApptID, ApptReasonCode;

--16. List the average number of minutes for all rows in the ApptDetail table.  Use “Avg Appt Time” as the column heading and format the result as “# Minutes” (where “#” represents the calculated number of minutes). 

SELECT TO_CHAR(AVG(BlockMinutes), '00')|| ' Minutes is the Avg time' AS "Avg Appt Time"  
FROM BLOCK_vp R, APPTDETAIL_vp RD
WHERE R.BlockCode = RD.BlockCode;

--17. List the appt ID, date, patient ID, patient last name, doctor ID, doctor last name, appt status desc for all appointments on or after 9/25/21.  Show the date formatted as “mm/dd/yy.”
SELECT ApptID, TO_CHAR(ApptDateTime, 'MM/DD/YY') AS "Date", 
R.PatientID, PatientLName, R.DrID , DrLName, ApptStatusDesc
FROM APPOINTMENT_vp R, PATIENT_vp C, DOCTOR_vp A, APPTSTATUS_vp RT 
WHERE R.PatientID = C.PatientID AND 
R.DrID = A.DrID AND
R.ApptStatusCode = RT.ApptStatusCode AND
ApptDateTime >= '25-SEP-21';

--18.    List the appt ID, date/time, and total number of minutes for each appointment.  Use the following column headings:  Appt ID, DateTime, Total Minutes.  Hint:  Use a GROUP BY clause.

SELECT A.ApptID, B.ApptDateTime AS "DateTime", SUM(C.BlockMinutes) AS "Total Minutes"
FROM APPTDETAIL_vp A
JOIN APPOINTMENT_vp B ON A.ApptID = B.ApptID
JOIN BLOCK_vp C ON A.BlockCode = C.BlockCode
GROUP BY A.ApptID, B.ApptDateTime;

--19. List the block code, block code description, and count of appointments for each block code.  Sort by count in descending order. Use the following column headings:  BlockCode, Description, Count.  Hint:  Use a GROUP BY clause. 
SELECT BLOCK_vp.BlockCode, BlockDesc AS "Description",
COUNT(ApptID) AS "Count"
FROM BLOCK_vp, APPTDETAIL_vp
WHERE BLOCK_vp.BlockCode = APPTDETAIL_vp.BlockCode
GROUP BY BLOCK_vp.BlockCode, BlockDesc
ORDER BY COUNT(ApptID) DESC;


--20. List the patient ID, first name, last name, and phone number for all patients.  Show the phone number formatted as ‘(###) ###-####’ and sort by patient ID.  Use the following column headings:  Patient ID, First Name, Last Name, Phone. 

SELECT PatientID AS "Patient ID", PatientFName AS "First Name", PatientLName AS "Last Name", 
	 SUBSTR(PatientPhone, 0, 0)|| '(' || SUBSTR(PatientPhone, 1, 3)|| ') ' || SUBSTR(PatientPhone, 4, 3) || '-' || SUBSTR(PatientPhone, 7, 4) AS "Phone"
FROM PATIENT_vp;


--21.List the pay type, pay type description, and count of appointments for each pay type.  Use the following column headings:  Pay Type, Description, Count.  Sort by count in descending order.  Hint:  use a GROUP BY clause.


SELECT BILLINGTYPE_vp.BillingType AS "Pay Type", BillingTypeDesc AS "Description", COUNT (ApptID) AS "COUNT"
FROM BILLINGTYPE_vp, APPOINTMENT_vp
WHERE BILLINGTYPE_vp.BillingType = APPOINTMENT_vp.BillingType
GROUP BY BILLINGTYPE_vp.BillingType, BillingTypeDesc
ORDER BY COUNT(ApptID) DESC;

--22.List the patient ID, first name, last name, and phone number for all “self pay” patients.  Show the phone number formatted as ‘(###) ###-####’ and use the following column headings:  PatientID, FirstName, LastName, Phone.

SELECT PATIENT_vp.PatientID "Patient ID", PatientFName "First Name", PatientLName "Last Name",
SUBSTR(PatientPhone, 0, 0)|| '(' || SUBSTR(PatientPhone, 1, 3)|| ') ' || SUBSTR(PatientPhone, 4, 3) || '-' || SUBSTR(PatientPhone, 7, 4) AS "Phone"
FROM PATIENT_vp, APPOINTMENT_vp
WHERE APPOINTMENT_vp.PatientID = PATIENT_vp.PatientID AND APPOINTMENT_vp.BillingType = 'SP';

--23. List the appt ID, date/time, patient ID, last name, doctor ID, doctor last name, pay type description, and appointment status description for all appointments on or before 9/25/21.  Format the date/time as “mm-dd-yyyy 00:00” and use the following column headings:  Appt ID, DateTime, Patient ID, Patient Name, Dr ID, Dr Name, Pay Type, Appt Status.  Sort by Appt ID.

SELECT ApptID,TO_CHAR(ApptDateTime,'mm-dd-yy') "DateTime", Patient_vp.PatientID "Patient ID", PatientLName "Patient Name", DOCTOR_vp.DrID "Dr ID", DrLName "Dr Name", BillingTypeDesc "Pay Type", ApptStatusDesc "Appt Status"
FROM APPOINTMENT_vp, BILLINGTYPE_vp, PATIENT_vp, DOCTOR_vp, APPTSTATUS_vp
WHERE BILLINGTYPE_vp.BillingType = APPOINTMENT_vp.BillingType AND
PATIENT_vp.PatientID = APPOINTMENT_vp.PatientID AND
Doctor_vp.DrID = APPOINTMENT_vp.DrID AND
APPTSTATUS_vp.ApptStatusCode = APPOINTMENT_vp.ApptStatusCode AND
ApptDateTime BETWEEN '25-SEP-2000' AND '26-SEP-2021'
ORDER BY ApptID;

--24. List the doctor ID, first name, last name, and count of appointments for each doctor.  Combine the first and last name into one column and use the following column headings:  Dr ID, Dr Name, Appt Count.  Sort by doctor last name.

SELECT DOCTOR_vp.DrID AS "Dr ID", DrLName ||' '||DrFName AS "Dr Name",
COUNT(APPTID) "Appt Count"
FROM DOCTOR_vp, APPOINTMENT_vp
WHERE DOCTOR_vp.DrID = APPOINTMENT_vp.DrID
GROUP BY DOCTOR_vp.DrID, DrLName, DrFName
ORDER BY DrLName;

--25. List the patient ID, patient first name, patient last name, and total number of appointments for each patient.  Sort by appointment count in descending order.  Use the following column headings:  Patient ID, Patient First Name, Patient Last Name, Appt Count.  Hint:  use a GROUP BY clause.

SELECT PATIENT_vp.PatientID AS "Patient ID", PatientFName AS "Patient First Name", PatientLName AS "Patient Last Name",
COUNT(ApptID) AS "Appt Count"
FROM PATIENT_vp, APPOINTMENT_vp
WHERE PATIENT_vp.PatientID = APPOINTMENT_vp.PatientID
GROUP BY PATIENT_vp.PatientID, PatientFName , PatientLName
ORDER BY COUNT(ApptID) DESC;

/*26 For each appointment, list the appt ID, date/time, patient ID, patient first name, patient last name, 
doctor ID, doctor last name, and count of reason codes; combine the patient first and last name 
into one column, and sort by count of reason codes in descending order, then by appt ID in 
ascending order.  Show the date/time formatted as ‘mm-dd-yyyy 00:00.’  Use the following 
column headings:  Appt, DateTime, Patient ID, Patient Name, Dr ID, Dr Name, Code Count. 
Hint:  use a GROUP BY clause. */

SELECT APPOINTMENT_vp.ApptID, TO_CHAR(ApptDateTime, 'mm-dd-yyyy HH24:MI') AS "DateTime", 
PATIENT_vp.PatientID AS "Patient ID", PatientFName ||' '|| PatientLName AS "Patient Name", 
DOCTOR_vp.DrID AS "Dr ID", DrLName AS "Dr Name", COUNT(ApptReasonCode) AS "Code Count"
FROM APPOINTMENT_vp, PATIENT_vp , DOCTOR_vp, APPTDETAIL_vp
WHERE PATIENT_vp.PatientID = APPOINTMENT_vp.PatientID AND
DOCTOR_vp.DrID = APPOINTMENT_vp.DrID 
GROUP BY APPOINTMENT_vp.ApptID, ApptDateTime, PATIENT_vp.PatientID, DOCTOR_vp.DrID, DrLName, PatientFName, PatientLName
ORDER BY COUNT(ApptReasonCode) DESC, ApptID ASC;

/*27 List the appt ID, appt date, appt time, and total number of minutes for the appointment(s) with 
the highest total minutes.  Sort by appt ID.  Use the following column headings:  ApptID, Date, 
Time, TotalMinutes.  Hint:  use a GROUP BY clause and a HAVING clause with a nested SELECT.*/

SELECT AD.ApptID AS "ApptID", TO_CHAR(A.ApptDateTime, 'mm-dd-yyyy') AS "Date", 
			      TO_CHAR(A.ApptDateTime, 'hh24:mi') AS "Time",  
			      B.BlockMinutes AS "Total Minutes" 
FROM APPOINTMENT_vp A, APPTDETAIL_vp AD, BLOCK_vp B 
WHERE 	A.ApptID = AD.ApptID AND 
	AD.BlockCode = B.BlockCode AND
(AD.ApptID, B.BlockMinutes) 
IN (SELECT ApptID, MAX(BlockMinutes) 
FROM  APPTDETAIL_vp 
GROUP BY ApptID);


/*28 List the doctor ID, first name, last name, and count of appointments for the doctor with the least 
number of appointments.  Combine the first and last names into one column, use the following 
column headings:  Dr ID, Name, Appt Count.  Hint:  use a GROUP BY clause and a HAVING 
clause with a nested SELECT.*/
SELECT*FROM (SELECT D.DrID AS "Dr ID", D.DrFName||' '||D.DrLName AS "Name",
COUNT(A.ApptID) AS "Appt Count"
FROM DOCTOR_vp D, APPOINTMENT_vp A
WHERE D.DrID = A.DrID
GROUP BY D.DrID, D.DrFName||' '||D.DrLName
ORDER BY COUNT(A.ApptID) ASC)
WHERE ROWNUM = 1;


/*29 List the appt ID, Date/time, patient ID, patient last name, doctor ID, and doctor last name for all 
appointments with a total number of minutes greater than or equal to 30 minutes.  Sort by total 
minutes in descending order, then by appt ID in ascending order.  Use the following column 
headings:  Appt ID, DateTime, Patient ID, Patient Name, Doctor ID, Doctor Name.*/

SELECT R.ApptID, ApptDateTime AS "DateTime", R.PatientID, PatientLName AS "Patient Name", 
R.DrID AS "Dr ID", DrLName, SUM(BlockMinutes)
FROM APPOINTMENT_vp R, APPTDETAIL_vp RD, PATIENT_vp C, DOCTOR_vp A, BLOCK_vp
WHERE 	R.ApptID = RD.ApptID AND 
	R.PatientID = C.PatientID AND
	R.DrID = A.DrID 
GROUP BY R.ApptID, ApptDateTime, R.PatientID, PatientLName, R.DrID, DrLName
HAVING SUM(BLOCK_vp.BlockMinutes) > = 30
ORDER BY SUM(BLOCK_vp.BlockMinutes) DESC, ApptID ASC;

/*30 List the appt ID, date, patient last name, and doctor last name for all appointments that have a 
total number of minutes greater than the average total minutes for all appointments.  Use the 
following column headings:  ApptID, Date, Patient, Doctor, TotalMinutes.  Sort by appt ID.  Hint:  use a nested SELECT.*/  

SELECT ROUND(AVG(TO_NUMBER(SUBSTR(b.BlockMinutes, 1, 2))))
FROM APPOINTMENT_vp A, APPTDETAIL_vp AD, BLOCK_vp B
WHERE A.ApptID = AD.ApptID AND AD.BlockCode = B.BlockCode;
SELECT A.ApptID AS "Appt ID", A.ApptDateTime AS "Date", P.PatientLName AS "Patient", D.DrLName AS "Doctor", 
TO_NUMBER(SUBSTR(b.BlockMinutes,1,2)) as "TotalMinutes"
FROM APPOINTMENT_vp A, PATIENT_vp P, DOCTOR_vp D, APPTDETAIL_vp AD, BLOCK_vp B
WHERE A.PatientID = P.PatientID AND 
A.DrID = D.DrID and 
A.ApptID = AD.ApptID and 
AD.BlockCode = B.BlockCode and 
TO_NUMBER(SUBSTR(BlockMinutes,1,2))>(SELECT ROUND(AVG(TO_NUMBER(SUBSTR(b.BlockMinutes,1,2))))
FROM APPOINTMENT_vp A, APPTDETAIL_vp AD, BLOCK_vp B
WHERE A.ApptID = AD.ApptID AND AD.BlockCode = B.BlockCode) 
ORDER BY A.ApptID;

/*31 List the appt ID, date, patient last name, billing type description, insurance company, and count 
of reason codes for all appointments that have 2 or more reason. Sort by count of reason codes in 
descending order, then by appt ID in ascending order.  Use the following column headings:  
ApptID, Date, Patient, BillType, InsCo, ReasonCount.*/

SELECT A.ApptID AS "ApptID", A.ApptDateTime AS "Date", P.PatientLName AS "Patient", 
BT.BillingTypeDesc AS "BillType", I.InsCoName AS "InsCo",
COUNT(AD.ApptReasonCode) AS "ReasonCount"
FROM APPOINTMENT_vp A , PATIENT_vp P , BILLINGTYPE_vp BT, INSURANCECO_vp I, APPTDETAIL_vp AD
WHERE A.PatientID = P.PatientID AND
A.BillingType = BT.BillingType AND 
A.InsCoID = I.InsCoID AND 
A.ApptID = AD.ApptID
GROUP BY A.ApptID, A.ApptDateTime, P.PatientLName, BT.BillingTypeDesc, I.InsCoName
HAVING COUNT(AD.ApptReasonCode)>= 2
ORDER BY COUNT(AD.ApptReasonCode) DESC, A.ApptID ASC;



/*32 List the reason code, reason description, block code, block minutes for the appt detail row with 
the highest number of minutes in each appointment.  Show the minutes formatted as “# minutes” 
and use the following column headings:  Reason Code, Description, Block Code, Minutes.  Hint:  
use a NESTED SELECT with a GROUP BY.*/

SELECT 	AD.ApptReasonCode AS "Reason Code", ApptReasonDesc "Description", AD.BlockCode, (TO_CHAR(BlockMinutes, '00') || ' Minutes') AS "Minutes"
FROM APPTREASON_vp AP, BLOCK_vp B, APPTDETAIL_vp AD
WHERE AD.ApptReasonCode = AP.ApptReasonCode AND
AD.BlockCode = B.BlockCode AND
(AD. ApptID, BlockMinutes) IN (SELECT ApptID, MAX(BlockMinutes) FROM APPTDETAIL_vp GROUP BY ApptID );

















--start "C:\Users\16828\Desktop\Project3_vp.sql"




--Turn off logging 
set echo off

--Close the file
spool off







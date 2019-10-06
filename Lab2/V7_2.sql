USE AdventureWorks2012;
GO

--1
CREATE TABLE dbo.PersonPhone(
	BusinessEntityID INT,
	PhoneNumber Phone,
	PhoneNumberTypeId INT,
	ModifiedDate DATETIME
);
GO

--2
ALTER TABLE 
	dbo.PersonPhone
ALTER COLUMN 
	BusinessEntityID INT NOT NULL;
ALTER TABLE
	dbo.PersonPhone
ALTER COLUMN
	PhoneNumber Phone NOT NULL;
GO
ALTER TABLE
	dbo.PersonPhone
ADD CONSTRAINT 
	PK_PersonPhone_BusinessEntityID_PhoneNumber PRIMARY KEY (BusinessEntityID,PhoneNumber);
GO

--3
ALTER TABLE
    dbo.PersonPhone
ADD
    PostalCode NVARCHAR(15) CONSTRAINT CK_PersonPhone_PostalCode CHECK (PostalCode NOT LIKE '%[^0-9]%');
GO

--4
ALTER TABLE
    dbo.PersonPhone
ADD CONSTRAINT 
	DF_PersonPhone_PostalCode DEFAULT '0' FOR PostalCode;
GO

--5
INSERT INTO dbo.PersonPhone (BusinessEntityID, PhoneNumber, PhoneNumberTypeID, ModifiedDate)
SELECT
    Person.PersonPhone.BusinessEntityID,
    Person.PersonPhone.PhoneNumber,
    Person.PersonPhone.PhoneNumberTypeID,
    Person.PersonPhone.ModifiedDate
FROM
    Person.PersonPhone
    INNER JOIN Person.PhoneNumberType
        ON (Person.PersonPhone.PhoneNumberTypeID = Person.PhoneNumberType.PhoneNumberTypeID)
WHERE
    PhoneNumberType.Name = 'Cell';
GO

--6
ALTER TABLE
    dbo.PersonPhone
ALTER COLUMN
    PhoneNumberTypeID BIGINT NULL;
GO
USE AdventureWorks2012;
GO

-- 1
ALTER TABLE
    dbo.PersonPhone
ADD
    City NVARCHAR(30);
GO

-- 2
DECLARE @PersonPhoneVar TABLE
(
    BusinessEntityID INT NOT NULL,
    PhoneNumber Phone NOT NULL,
    PhoneNumberTypeID BIGINT NULL,
    ModifiedDate DATETIME,
    PostalCode NVARCHAR(15) DEFAULT ('0'),
    City NVARCHAR(30)
);
INSERT INTO
    @PersonPhoneVar
    (
        BusinessEntityID,
        PhoneNumber,
        PhoneNumberTypeID,
        ModifiedDate,
        PostalCode,
        City
    )
SELECT
    dbo.PersonPhone.BusinessEntityID,
    dbo.PersonPhone.PhoneNumber,
    dbo.PersonPhone.PhoneNumberTypeID,
    dbo.PersonPhone.ModifiedDate,
    IIF (Person.Address.PostalCode NOT LIKE '%[^0-9]%', Person.Address.PostalCode, '0'),
    Person.Address.City
FROM
    dbo.PersonPhone
    LEFT JOIN Person.BusinessEntityAddress
        ON (dbo.PersonPhone.BusinessEntityID = Person.BusinessEntityAddress.BusinessEntityID)
    LEFT JOIN Person.Address
        ON (BusinessEntityAddress.AddressID = Address.AddressID);

-- 3
UPDATE
    dbo.PersonPhone
SET
    dbo.PersonPhone.PostalCode = PersonPhoneVar.PostalCode,
    dbo.PersonPhone.City = PersonPhoneVar.City,
    dbo.PersonPhone.PhoneNumber
        = IIF (CHARINDEX('1 (11)', PersonPhoneVar.PhoneNumber) = 0,
            '1 (11) ' + PersonPhoneVar.PhoneNumber,
            PersonPhoneVar.PhoneNumber)
FROM
    dbo.PersonPhone
    INNER JOIN @PersonPhoneVar AS PersonPhoneVar
        ON (dbo.PersonPhone.BusinessEntityID = PersonPhoneVar.BusinessEntityID);
GO

-- 4
DELETE
    PersonPhoneTable
FROM
    dbo.PersonPhone PersonPhoneTable
    INNER JOIN Person.Person
        ON (PersonPhoneTable.BusinessEntityID = Person.Person.BusinessEntityID)
WHERE
    PersonType = 'EM';
GO

-- 5
ALTER TABLE
    dbo.PersonPhone
DROP COLUMN
    City;
ALTER TABLE
    dbo.PersonPhone
DROP CONSTRAINT
    PK_PersonPhone_BusinessEntityID_PhoneNumber,
    CK_PersonPhone_PostalCode,
    DF_PersonPhone_PostalCode;
GO

-- 6
DROP TABLE
    dbo.PersonPhone;
GO
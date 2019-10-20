:r C:\Vitaly\Study\DB\Lab2\V7_2.sql

USE AdventureWorks2012;
GO

ALTER TABLE
    dbo.PersonPhone
ADD
    OrdersCount INT,
    CardType NVARCHAR(50),
    IsSuperior AS IIF (CardType = 'SuperiorCard', 1, 0);
GO

-- 2
CREATE TABLE #PersonPhone
(
    BusinessEntityID INT NOT NULL PRIMARY KEY,
    PhoneNumber nvarchar(25) NOT NULL,
    PhoneNumberTypeID BIGINT NULL,
    ModifiedDate DATETIME,
    PostalCode NVARCHAR(15) DEFAULT ('0'),
    OrdersCount INT,
    CardType NVARCHAR(50)
);
GO

-- 3
WITH OrdersCount_CTE (CreditCardID, OrdersCount)
AS
(
    SELECT
        CreditCardID,
        COUNT(*) AS OrdersCount
    FROM
        Sales.SalesOrderHeader
    GROUP BY
        CreditCardID
)
INSERT INTO
    #PersonPhone
    (
        BusinessEntityID,
        PhoneNumber,
        PhoneNumberTypeID,
        ModifiedDate,
        PostalCode,
        OrdersCount,
        CardType
    )
SELECT
    dbo.PersonPhone.BusinessEntityID,
    dbo.PersonPhone.PhoneNumber,
    dbo.PersonPhone.PhoneNumberTypeID,
    dbo.PersonPhone.ModifiedDate,
    dbo.PersonPhone.PostalCode,
    OrdersCount_CTE.OrdersCount,
    Sales.CreditCard.CardType
FROM
    dbo.PersonPhone
    INNER JOIN Sales.PersonCreditCard
        ON (PersonPhone.BusinessEntityID = PersonCreditCard.BusinessEntityID)
    INNER JOIN Sales.CreditCard
        ON (PersonCreditCard.CreditCardID = CreditCard.CreditCardID)
    INNER JOIN OrdersCount_CTE
        ON (CreditCard.CreditCardID = OrdersCount_CTE.CreditCardID);
GO

-- 4
DELETE
FROM
    #PersonPhone
WHERE
    BusinessEntityID = 297;

-- 5
MERGE
    dbo.PersonPhone AS target
    USING #PersonPhone AS source
ON (target.BusinessEntityID = source.BusinessEntityID)
WHEN MATCHED THEN
    UPDATE SET
        OrdersCount = source.OrdersCount,
        CardType = source.CardType
WHEN NOT MATCHED BY TARGET THEN
    INSERT
    (
        BusinessEntityID,
        PhoneNumber,
        PhoneNumberTypeID,
        ModifiedDate,
        OrdersCount,
        CardType
    )
    VALUES
    (
        BusinessEntityID,
        PhoneNumber,
        PhoneNumberTypeID,
        ModifiedDate,
        OrdersCount,
        CardType
    )
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
GO
USE AdventureWorks2012;
GO

-- 1
CREATE TABLE Sales.CurrencyHst
(
    ID INT IDENTITY(1, 1),
    Action NVARCHAR(6) NOT NULL CHECK (Action IN('insert', 'update', 'delete')),
    ModifiedDate DATETIME NOT NULL DEFAULT CAST(GETDATE() AS date),
    SourceID NCHAR(3) NOT NULL,
    UserName Name NOT NULL
);
GO

--2
--INSERT
CREATE TRIGGER
    Sales.OnCurrencyInsert
ON
    Sales.Currency
AFTER
    INSERT
AS
    INSERT INTO
        Sales.CurrencyHst
        (
            Action,
            SourceID,
            UserName,
            ModifiedDate
        )
    SELECT
        'insert',
        CurrencyCode,
        CURRENT_USER,
        INSERTED.ModifiedDate
    FROM
        INSERTED;
GO
--UPDATE
CREATE TRIGGER
    Sales.OnCurrencyUpdate
ON
    Sales.Currency
AFTER
    UPDATE
AS
    INSERT INTO
        Sales.CurrencyHst
        (
            Action,
            SourceID,
            UserName,
            ModifiedDate
        )
    SELECT
        'update',
        CurrencyCode,
        CURRENT_USER,
        INSERTED.ModifiedDate
    FROM
        INSERTED;
GO
--DELETE
CREATE TRIGGER
    Sales.OnCurrencyDelete
ON
    Sales.Currency
AFTER
    DELETE
AS
    INSERT INTO
        Sales.CurrencyHst
        (
            Action,
            SourceID,
            UserName,
            ModifiedDate
        )
    SELECT
        'delete',
        CurrencyCode,
        CURRENT_USER,
        DELETED.ModifiedDate
    FROM
        DELETED;
GO

--3
CREATE VIEW
    Sales.CurrencyView
WITH
    ENCRYPTION
AS
    SELECT
        CurrencyCode,
        Name,
        ModifiedDate
    FROM
        Sales.Currency;
GO

--4
--INSERT 
INSERT INTO
    Sales.CurrencyView
    (
        CurrencyCode, Name
    )
VALUES
(
    'LYD',
    'Lyvian Dollar'
);
GO
--UPDATE
UPDATE
    Sales.CurrencyView
SET
    CurrencyCode = 'BYN',
    Name = 'Belarusian Ruble'
WHERE
    CurrencyCode = 'LYD';
GO
--DELETE
DELETE
FROM
    Sales.CurrencyView
WHERE
    CurrencyCode = 'BYN';
GO
SELECT * FROM Sales.CurrencyHst;
GO
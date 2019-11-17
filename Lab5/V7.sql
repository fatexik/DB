USE AdventureWorks2012;
GO

-- 1
CREATE FUNCTION
    dbo.FN_GetLastUsdRate (@CurrencyCode NCHAR(3))
RETURNS
    MONEY
AS
BEGIN
    RETURN
    (
        SELECT TOP 1
            AverageRate
        FROM
            Sales.CurrencyRate
        WHERE
            ToCurrencyCode = @CurrencyCode
            AND FromCurrencyCode = 'USD'
        ORDER BY
            CurrencyRateDate DESC
    )
END;
GO

-- 2
CREATE FUNCTION
    dbo.FN_GetLargeOrders (@ProductId INT)
RETURNS
    TABLE
AS
RETURN
(
    SELECT
        *
    FROM
        Purchasing.PurchaseOrderDetail
    WHERE
        ProductID = @ProductId
        AND OrderQty > 1000
);
GO

-- 3
SELECT
    *
FROM
    Production.Product
    CROSS APPLY dbo.FN_GetLargeOrders (Product.ProductID);
GO
SELECT
    *
FROM
    Production.Product
    OUTER APPLY dbo.FN_GetLargeOrders (Product.ProductID);
GO

-- 4
DROP FUNCTION
    dbo.FN_GetLargeOrders;
GO
CREATE FUNCTION
    dbo.FN_GetLargeOrders (@ProductId INT)
RETURNS
    @LargeOrders TABLE
    (
        PurchaseOrderID INT,
        PurchaseOrderDetailID INT,
        DueDate DATETIME,
        OrderQty SMALLINT,
        ProductID INT,
        UnitPrice MONEY,
        LineTotal MONEY,
        ReceivedQty DECIMAL(8,2),
        RejectedQty DECIMAL(8,2),
        StockedQty DECIMAL(9,2),
        ModifiedDate DATETIME
    )
AS
BEGIN
    INSERT INTO
        @LargeOrders
        (
            PurchaseOrderID,
            PurchaseOrderDetailID,
            DueDate,
            OrderQty,
            ProductID,
            UnitPrice,
            LineTotal,
            ReceivedQty,
            RejectedQty,
            StockedQty,
            ModifiedDate
        )
    SELECT
        PurchaseOrderID,
        PurchaseOrderDetailID,
        DueDate,
        OrderQty,
        ProductID,
        UnitPrice,
        LineTotal,
        ReceivedQty,
        RejectedQty,
        StockedQty,
        ModifiedDate
    FROM
        Purchasing.PurchaseOrderDetail
    WHERE
        ProductID = @ProductId
        AND OrderQty > 1000;
    RETURN
END;
GO
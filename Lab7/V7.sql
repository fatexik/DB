USE AdventureWorks2012;
GO

DECLARE
    @xml XML;

SET @xml =
(
    SELECT
        Product.ProductID AS '@ID',
        Product.Name AS 'Name',
        ProductModel.ProductModelID AS 'Model/@ID',
        ProductModel.Name AS 'Model/Name'
    FROM
        Production.Product
        INNER JOIN Production.ProductModel
            ON Product.ProductModelID = ProductModel.ProductModelID
    FOR XML
        PATH ('Product'),
        ROOT ('Products')
);

SELECT
    @xml;

CREATE TABLE #Product
(
    ProductID INT,
    ProductName NVARCHAR(50),
    ProductModelID INT,
    ProductModelName NVARCHAR(50)
);

INSERT INTO
    #Product
    (
        ProductID,
        ProductName,
        ProductModelID,
        ProductModelName
    )
SELECT
    ProductID = node.value('@ID', 'INT'),
    ProductName = node.value('Name[1]', 'NVARCHAR(50)'),
    ProductModelID = node.value('Model[1]/@ID', 'INT'),
    ProductModelName = node.value('Model[1]/Name[1]', 'NVARCHAR(50)')
FROM
    @xml.nodes('/Products/Product') AS xml(node);
GO


SELECT * FROM #Product;
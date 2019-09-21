SELECT DISTINCT COUNT(NAME) AS DepartamentCount 
FROM AdventureWorks2012.HumanResources.Department
WHERE GroupName = 'Executive General and Administration'
GO

SELECT TOP 5 BusinessEntityID, JobTitle, Gender, BirthDate 
FROM AdventureWorks2012.HumanResources.Employee 
ORDER BY BirthDate DESC;
GO

SELECT BusinessEntityID,JobTitle,Gender,HireDate,REPLACE(LoginID,'adventure-works','adventure-works2012') 
FROM AdventureWorks2012.HumanResources.Employee 
WHERE Gender = 'F' AND FORMAT(HireDate,'dddd') = 'Tuesday'
GO
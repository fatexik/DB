USE AdventureWorks2012

GO
SELECT Employee.BusinessEntityID, JobTitle, MAX(RateChangeDate) as "LastRateDate"
FROM HumanResources.Employee 
	INNER JOIN HumanResources.EmployeePayHistory ON
		Employee.BusinessEntityID = EmployeePayHistory.BusinessEntityID
GROUP BY 
	Employee.BusinessEntityID, JobTitle
GO

SELECT EmployeeDepartmentHistory.BusinessEntityID, JobTitle, Department.Name as "DepName", StartDate, EndDate, DATEDIFF(YEAR, StartDate, ISNULL(EndDate,getDate())) as "Years"
FROM HumanResources.EmployeeDepartmentHistory 
	INNER JOIN HumanResources.Employee 
		ON (Employee.BusinessEntityID = EmployeeDepartmentHistory.BusinessEntityID)
	INNER JOIN HumanResources.Department 
		ON (EmployeeDepartmentHistory.DepartmentID = Department.DepartmentID)
GO

SELECT
    Employee.BusinessEntityID, JobTitle, Department.Name AS DepName, GroupName, SUBSTRING(LTRIM(GroupName), 1, (CHARINDEX(' ',LTRIM(GroupName) + ' ')-1)) as "DepGroup"
FROM
    HumanResources.Employee
    INNER JOIN HumanResources.EmployeeDepartmentHistory
        ON (Employee.BusinessEntityID = EmployeeDepartmentHistory.BusinessEntityID)
    INNER JOIN HumanResources.Department
        ON (EmployeeDepartmentHistory.DepartmentID = Department.DepartmentID)
WHERE
    EndDate IS NULL;
GO
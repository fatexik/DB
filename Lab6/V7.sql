USE AdventureWorks2012;
GO

-- 1
CREATE PROCEDURE
    dbo.EmpCountByShift
    @Shifts NVARCHAR(392)
AS
    DECLARE
        @sqlQuery
    AS
        NVARCHAR(MAX);

    SET @sqlQuery = '
SELECT
    DepName,
    ' + @Shifts + '
FROM
(
    SELECT
        Department.Name AS DepName,
        Shift.Name AS ShiftName
    FROM
        HumanResources.Department
        INNER JOIN HumanResources.EmployeeDepartmentHistory
            ON Department.DepartmentID = EmployeeDepartmentHistory.DepartmentID
        INNER JOIN HumanResources.Shift
            ON EmployeeDepartmentHistory.ShiftID = Shift.ShiftID
    WHERE
        EndDate IS NULL
) AS SourceTable
PIVOT
(
    COUNT(ShiftName)
    FOR
        ShiftName
    IN
    (
    ' + @Shifts + '
    )
) AS PivotTable;
    ';

    EXEC (@sqlQuery);
GO

-- 2
EXECUTE dbo.EmpCountByShift '[Day],[Evening],[Night]';
GO
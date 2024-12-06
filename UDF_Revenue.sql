-- USER DEFINED FUNCTION FOR REVENUE COUNT.

-- DROP STATEMENT.
IF OBJECT_ID('dbo.GetTotalRevenue', 'FN') IS NOT NULL
    DROP FUNCTION dbo.GetTotalRevenue;
GO

-- FUNCTION TAKES TWO PARAMENTERS. 
-- 1. FROM DATE
-- 2. TO DATE

CREATE FUNCTION GetTotalRevenue
(
    @StartDateTime DATETIME,
    @EndDateTime DATETIME
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(10, 2);

    SELECT @TotalRevenue = ISNULL(SUM(TotalAmount), 0)
    FROM Billing
    WHERE PaymentDate BETWEEN @StartDateTime AND @EndDateTime

    RETURN @TotalRevenue;
END;
GO

DECLARE @StartDate DATETIME = '2024-12-04 00:00:00';
DECLARE @EndDate DATETIME = '2024-12-07 23:59:59';

SELECT dbo.GetTotalRevenueBetweenDates(@StartDate, @EndDate) AS TotalRevenue;
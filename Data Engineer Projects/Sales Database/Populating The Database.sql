-- Insert Date data
DECLARE @StartDate DATE = '2025-01-01';
DECLARE @EndDate   DATE = '2035-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO [Date] (
        DateID,
        [Date],
        [Day],
        Day_name,
        Day_of_week,
        [Week],
        [Month],
        Month_name,
        [Year],
        [Quarter]
    )
    VALUES (
        CONVERT(INT, FORMAT(@StartDate, 'yyyyMMdd')),
        @StartDate,
        DAY(@StartDate),
        DATENAME(WEEKDAY, @StartDate),
        DATEPART(WEEKDAY, @StartDate),
        DATEPART(WEEK, @StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate),
        YEAR(@StartDate),
        DATEPART(QUARTER, @StartDate)
    );

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;
GO
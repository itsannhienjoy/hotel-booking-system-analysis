-- 5.1 Accommodation Type Popularity And Revenue Analysis

WITH Tot_Booking AS (
    SELECT a.AccommodationTypeID, 
    COUNT(*) AS TotalBookings
    FROM Booking b
    JOIN Accommodation a ON b.AccommodationID = a.AccommodationID
    WHERE b.IsCancelled = 0
    GROUP BY a.AccommodationTypeID
),
Revenue_Info AS (
    SELECT a.AccommodationTypeID, 
    CAST(AVG(DATEDIFF(DAY, b.CheckInTime, b.CheckOutTime) * 1.0) AS DECIMAL(10,2)) AS AverageStayLength,
    SUM(a.PricePerNight * DATEDIFF(DAY, b.CheckInTime, b.CheckOutTime) - ISNULL(c.DiscountAmount, 0)) AS TotalRevenue
    FROM Booking b 
    JOIN Accommodation a ON a.AccommodationID = b.AccommodationID
    LEFT JOIN Voucher_Coupon c ON b.VoucherCouponID = c.VoucherCouponID
    WHERE b.IsCancelled = 0
    GROUP BY a.AccommodationTypeID
),
Combined AS (
    SELECT 
        at.Type AS AccommodationType,
        tb.TotalBookings,
        CAST(tb.TotalBookings * 100.0 / SUM(tb.TotalBookings) OVER () AS DECIMAL(10,2)) AS BookingPercentage,
        ri.AverageStayLength,
        ri.TotalRevenue
    FROM Tot_Booking tb
    JOIN Revenue_Info ri ON tb.AccommodationTypeID = ri.AccommodationTypeID
    JOIN Accommodation_Type at ON tb.AccommodationTypeID = at.AccommodationTypeID
),
WithAverageFlag AS (
    SELECT *,
           ROUND(AVG(TotalRevenue) OVER (), 2) AS OverallAverageRevenue
    FROM Combined
)
SELECT 
    AccommodationType,
    TotalBookings,
    BookingPercentage,
    AverageStayLength,
    ROUND(TotalRevenue, 2) AS TotalRevenue,
    CASE 
        WHEN TotalRevenue >= OverallAverageRevenue THEN 'Above Average'
        ELSE 'Below Average'
    END AS RevenueLevel
FROM WithAverageFlag
ORDER BY TotalRevenue DESC;
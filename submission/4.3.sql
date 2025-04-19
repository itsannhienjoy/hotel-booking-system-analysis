-- 4.3 Test the price tracking system
TRUNCATE TABLE dbo.AccommodationPriceHistory;

SELECT AccommodationID, PricePerNight
FROM Accommodation
WHERE AccommodationID = 'ACM000000001';

/*  Increase price by 50000 */
EXEC price_change @AccommodationID = 'ACM000000001', @Delta = 50000;

/*  Decrease price by 50000 */
EXEC price_change @AccommodationID = 'ACM000000001', @Delta = -50000;

/*  View price change history */
SELECT *
FROM AccommodationPriceHistory
WHERE AccommodationID = 'ACM000000001'
ORDER BY HistoryID ASC;
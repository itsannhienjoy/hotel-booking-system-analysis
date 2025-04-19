-- 4.1 Price change procedure
-- - The procedure should take the accommodation ID and the amount to change the price by (how much to increase or decrease the price) as input
-- - The procedure should update the PricePerNight field in the Accommodation table
   
IF OBJECT_ID('price_change', 'P') IS NOT NULL
    DROP PROCEDURE price_change;
GO

-- Price change stored procedure
CREATE PROCEDURE price_change
    @AccommodationID VARCHAR(20),
    @Delta DECIMAL(15,2)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Accommodation 
    SET PricePerNight = PricePerNight + @Delta
    WHERE Accommodation.AccommodationID = @AccommodationID;

    SELECT AccommodationID,
           PricePerNight AS NewPrice
    FROM dbo.Accommodation
    WHERE AccommodationID = @AccommodationID;
END;
GO

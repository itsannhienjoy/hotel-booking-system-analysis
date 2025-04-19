-- 5.4 Stored procedure for an accommodation search system
DROP PROCEDURE IF EXISTS search_accommodations;
GO

CREATE PROCEDURE search_accommodations
    @RequiredCapacity INT,
    @RequiredAmenities NVARCHAR(MAX) = NULL,
    @RequiredFacilities NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Temporary tables to hold parsed amenities and facilities
    DECLARE @Amenities TABLE (AmenityID VARCHAR(20));
    DECLARE @Facilities TABLE (FacilityID VARCHAR(20));

    -- Parse amenities
    IF @RequiredAmenities IS NOT NULL AND LEN(@RequiredAmenities) > 0
    BEGIN
        INSERT INTO @Amenities
        SELECT value FROM STRING_SPLIT(@RequiredAmenities, ',');
    END

    -- Parse facilities
    IF @RequiredFacilities IS NOT NULL AND LEN(@RequiredFacilities) > 0
    BEGIN
        INSERT INTO @Facilities
        SELECT value FROM STRING_SPLIT(@RequiredFacilities, ',');
    END

    -- Main query with extra columns
    SELECT 
        a.AccommodationID,
        a.AccommodationName,
        at.Type AS AccommodationType,
        a.PricePerNight,
        a.Capacity,
        a.NumberOfRooms,

        -- List of all available amenities
        STUFF((
            SELECT ',' + am.AmenityName
            FROM Amenities_Included ai
            JOIN Amenities am ON ai.AmenityID = am.AmenityID
            WHERE ai.AccommodationID = a.AccommodationID
            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS Amenities,

        -- List of all available facilities
        STUFF((
            SELECT ',' + f.FacilityName
            FROM Facilities_Included fi
            JOIN Facilities f ON fi.FacilityID = f.FacilityID
            WHERE fi.AccommodationID = a.AccommodationID
            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS Facilities

    FROM Accommodation a
    JOIN Accommodation_Type at ON a.AccommodationTypeID = at.AccommodationTypeID
    WHERE 
        a.Capacity >= @RequiredCapacity
        AND NOT EXISTS (
            SELECT 1
            FROM @Amenities r
            WHERE NOT EXISTS (
                SELECT 1
                FROM Amenities_Included ai
                WHERE ai.AccommodationID = a.AccommodationID AND ai.AmenityID = r.AmenityID
            )
        )
        AND NOT EXISTS (
            SELECT 1
            FROM @Facilities f
            WHERE NOT EXISTS (
                SELECT 1
                FROM Facilities_Included fi
                WHERE fi.AccommodationID = a.AccommodationID AND fi.FacilityID = f.FacilityID
            )
        );
END;

GO

EXEC search_accommodations
    @RequiredCapacity = 18,
    @RequiredFacilities = 'F10,F02',
    @RequiredAmenities = 'A12';

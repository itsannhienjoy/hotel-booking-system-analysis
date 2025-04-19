-- 5.3 Province_Accommodation

WITH Tot_Accom AS (
    SELECT  c.ProvinceID, COUNT(DISTINCT a.AccommodationID) As TotalAccommodations
    FROM City_District c
    JOIN Accommodation a ON a.CityDistrictID = c.CityDistrictID
    GROUP BY c.ProvinceID
),
Province_Type_Count AS (
    SELECT c.ProvinceID, t.Type, COUNT(*) AS num_acc
    FROM Accommodation a 
    JOIN City_District c ON a.CityDistrictID = c.CityDistrictID
    JOIN Accommodation_Type t ON a.AccommodationTypeID = t.AccommodationTypeID
    GROUP BY c.ProvinceID, t.Type
) 

SELECT p.ProvinceName,
    SUM(CASE WHEN ptc.Type = 'Bungalow'     THEN ptc.num_acc ELSE 0 END) AS Bungalow,
    SUM(CASE WHEN ptc.Type = 'Condotel'     THEN ptc.num_acc ELSE 0 END) AS Condotel,
    SUM(CASE WHEN ptc.Type = 'Duplex'       THEN ptc.num_acc ELSE 0 END) AS Duplex,
    SUM(CASE WHEN ptc.Type = 'Farmstay'     THEN ptc.num_acc ELSE 0 END) AS FarmStay,
    SUM(CASE WHEN ptc.Type = 'Homestay'     THEN ptc.num_acc ELSE 0 END) AS HomeStay,
    SUM(CASE WHEN ptc.Type = 'Penthouse'    THEN ptc.num_acc ELSE 0 END) AS Penthouse,
    SUM(CASE WHEN ptc.Type = 'Resort'       THEN ptc.num_acc ELSE 0 END) AS Resort,
    SUM(CASE WHEN ptc.Type = 'Studio'       THEN ptc.num_acc ELSE 0 END) AS Studio,
    SUM(CASE WHEN ptc.Type = 'Treehouse'    THEN ptc.num_acc ELSE 0 END) AS Treehouse,
    SUM(CASE WHEN ptc.Type = 'Villa'        THEN ptc.num_acc ELSE 0 END) AS Villa,
    ta.TotalAccommodations
FROM Province p 
LEFT JOIN Tot_Accom ta 
    ON p.ProvinceID = ta.ProvinceID
LEFT JOIN Province_Type_Count ptc 
    ON p.ProvinceID = ptc.ProvinceID
GROUP BY 
    p.ProvinceName,
    ta.TotalAccommodations
ORDER BY
    ta.TotalAccommodations DESC;


-- 5.2 Accommodation Rating Analysis

WITH Accomodation_Info AS (
    SELECT f.AccommodationID,
        COUNT(*) AS ReviewCount,
        AVG(f.Rating) AS AvgRating
    FROM Feedback f 
    GROUP BY f.AccommodationID
    HAVING AVG(f.Rating) > 4.00
),

Type_Info AS (
    SELECT a.AccommodationTypeID,
        AVG(f.Rating) AS TypeAvgRating
    FROM Feedback f 
    JOIN Accommodation a ON f.AccommodationID = a.AccommodationID
    GROUP BY a.AccommodationTypeID
)

SELECT
  i.AccommodationID,
  a.AccommodationName,
  at.Type                                                     AS AccommodationType,
  CAST(i.AvgRating AS DECIMAL(3,2))                           AS AvgRating,
  i.ReviewCount,
  CAST(t.TypeAvgRating AS DECIMAL(3,2))                       AS TypeAvgRating,
  CAST(i.AvgRating - t.TypeAvgRating     AS DECIMAL(3,2))     AS DifferenceFromTypeAverage
FROM Accomodation_Info i
JOIN Accommodation a
  ON i.AccommodationID = a.AccommodationID
JOIN Type_Info t
  ON a.AccommodationTypeID = t.AccommodationTypeID
JOIN Accommodation_Type at
 ON a.AccommodationTypeID = at.AccommodationTypeID
ORDER BY
  i.AvgRating DESC,
  (i.AvgRating - t.TypeAvgRating) DESC,
  i.AccommodationID ASC;
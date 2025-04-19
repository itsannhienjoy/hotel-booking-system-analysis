-- 1. Province

BULK INSERT Province
FROM '/data/utf16/PROVINCE.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    DATAFILETYPE = 'widechar'
);

-- 2. Owner_Account
BULK INSERT Owner_Account
FROM '/data/utf16/OWNER_ACCOUNT.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    DATAFILETYPE = 'widechar'
);

-- 3. Guest_Acount
BULK INSERT Guest_Account
FROM '/data/utf16/GUEST_ACCOUNT.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    DATAFILETYPE = 'widechar'
);

-- 4. Amenities
BULK INSERT Amenities
FROM '/data/utf16/AMENITIES.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    DATAFILETYPE = 'widechar'
);

-- 5.Facilities
BULK INSERT Facilities
FROM '/data/utf16/FACILITIES.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    DATAFILETYPE = 'widechar'
);

--6. Voucher_Coupon
BULK INSERT Voucher_Coupon
FROM '/data/utf16/VOUCHER_COUPON.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    DATAFILETYPE = 'widechar'
);

--7. City_District
BULK INSERT City_District
FROM '/data/utf16/CITY_DISTRICT.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    DATAFILETYPE = 'widechar'
);

--8. Accommodation
BULK INSERT Accommodation
FROM '/data/utf16/ACCOMMODATION.csv'
WITH (
    FORMAT = 'CSV',          
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    DATAFILETYPE = 'widechar'
);

--9. Booking
CREATE TABLE Booking_Staging (
    BookingID               VARCHAR(20),
    GuestCardID             VARCHAR(20),  
    AccommodationID         VARCHAR(20),
    ReservedCheckInTime     DATETIME,    
    CheckInTime             DATETIME,
    CheckOutTime            DATETIME,
    VoucherCouponID         VARCHAR(20), 
    DateTimeCancel          VARCHAR(80) 
);

BULK INSERT Booking_Staging
FROM '/data/utf16/BOOKING.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    DATAFILETYPE = 'widechar'
);

INSERT INTO Booking
    (BookingID, GuestCardID, AccommodationID, ReservedCheckInTime, CheckInTime, CheckOutTime, VoucherCouponID, IsCancelled)
SELECT 
    BookingID,
    GuestCardID,
    AccommodationID,
    ReservedCheckInTime,
    CheckInTime,
    CheckOutTime,
    VoucherCouponID,
    CASE 
        WHEN TRY_CONVERT(DATETIME, DateTimeCancel) IS NOT NULL 
            THEN 1 
        ELSE 0 
    END AS IsCancelled
FROM Booking_Staging;

DROP TABLE Booking_Staging;

-- 10. Payment
BULK INSERT Payment
FROM '/data/utf16/PAYMENT.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    DATAFILETYPE = 'widechar'
);

-- 11. Feedback
CREATE TABLE Feedback_Staging (
  GuestCardID     VARCHAR(20),
  AccommodationID VARCHAR(20),
  RatingRaw       VARCHAR(10),  
  Comments        VARCHAR(500)
);
BULK INSERT Feedback_Staging
FROM '/data/utf16/FEEDBACK.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    DATAFILETYPE = 'widechar'
);
INSERT INTO Feedback
  (GuestCardID, AccommodationID, Rating, Comments)
SELECT
  GuestCardID,
  AccommodationID,
  CAST(
    LEN(RatingRaw) - LEN(REPLACE(RatingRaw, '*', ''))
  AS INT)           AS Rating,  -- '**' → 2
  Comments
FROM Feedback_Staging;

DROP TABLE Feedback_Staging;

-- 12. Amenities_Included
BULK INSERT Amenities_Included
FROM '/data/utf16/AMENITIES_INCLUDED.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    DATAFILETYPE = 'widechar'
);

-- 13. Facilities_Included
BULK INSERT Facilities_Included
FROM '/data/utf16/FACILITIES_INCLUDED.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    DATAFILETYPE = 'widechar'
);

-- 14. Accommodation_Type
BULK INSERT Accommodation_Type
FROM '/data/utf16/ACCOMMODATION_TYPE.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    DATAFILETYPE = 'widechar'
);

-- Update ProvinceName to remove trailing any redundant digits and carriage-return characters after bulk insert inspection
UPDATE Province
SET ProvinceName = LTRIM(RTRIM(
    REPLACE(
      LEFT(ProvinceName, LEN(ProvinceName) - 1),
      CHAR(13),
      ''
    )
))
WHERE LEN(ProvinceName) >= 1;

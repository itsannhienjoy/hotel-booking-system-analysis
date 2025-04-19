/* 1. Province Table */
CREATE TABLE Province (
    ProvinceID         VARCHAR(20) PRIMARY KEY,
    ProvinceName       NVARCHAR(100)
);

/* 2. City_District Table */
CREATE TABLE City_District (
    CityDistrictID     NVARCHAR(20) PRIMARY KEY,
    DistrictName       NVARCHAR(100),
    ProvinceID         VARCHAR(20),
    CONSTRAINT FK_City_District_Province 
        FOREIGN KEY (ProvinceID) REFERENCES Province(ProvinceID)
);

/* 3. Accommodation_Type Table */
CREATE TABLE Accommodation_Type (
    AccommodationTypeID VARCHAR(20) PRIMARY KEY,
    Type                VARCHAR(50)
);

/* 4. Owner_Account Table */
CREATE TABLE Owner_Account (
    OwnerIDCardNumber   VARCHAR(20) PRIMARY KEY,
    UserName            NVARCHAR(50),
    Password            NVARCHAR(50),
    FirstName           NVARCHAR(100),
    LastName            NVARCHAR(100),
    DOB                 DATE,
    Phone               VARCHAR(20),
    Email               VARCHAR(100),
    BankAccountNumb     VARCHAR(50)
);

/* 5. Accommodation Table */
CREATE TABLE Accommodation (
    AccommodationID     VARCHAR(20) PRIMARY KEY,
    AccommodationName   NVARCHAR(100),
    OwnerIDCardNumber   VARCHAR(20),
    CityDistrictID      NVARCHAR(20),
    StreetAddress       NVARCHAR(200),
    AccommodationTypeID VARCHAR(20),
    NumberOfRooms       INT,
    Capacity            INT,
    PricePerNight       DECIMAL(10,2),
    CONSTRAINT FK_Accommodation_Owner 
        FOREIGN KEY (OwnerIDCardNumber) REFERENCES Owner_Account(OwnerIDCardNumber),
    CONSTRAINT FK_Accommodation_City_District 
        FOREIGN KEY (CityDistrictID) REFERENCES City_District(CityDistrictID),
    CONSTRAINT FK_Accommodation_Type 
        FOREIGN KEY (AccommodationTypeID) REFERENCES Accommodation_Type(AccommodationTypeID)
);

/* 6. Amenities Table */
CREATE TABLE Amenities (
    AmenityID   VARCHAR(20) PRIMARY KEY,
    AmenityName NVARCHAR(100)
);

/* 7. Amenities_Included (Junction Table) */
CREATE TABLE Amenities_Included (
    AccommodationID VARCHAR(20),
    AmenityID       VARCHAR(20),
    CONSTRAINT PK_Amenities_Included PRIMARY KEY (AccommodationID, AmenityID),
    CONSTRAINT FK_Amenities_Included_Accommodation 
        FOREIGN KEY (AccommodationID) REFERENCES Accommodation(AccommodationID),
    CONSTRAINT FK_Amenities_Included_Amenity 
        FOREIGN KEY (AmenityID) REFERENCES Amenities(AmenityID)
);

/* 8. Facilities Table */
CREATE TABLE Facilities (
    FacilityID   VARCHAR(20) PRIMARY KEY,
    FacilityName NVARCHAR(100)
);

/* 9. Facilities_Included (Junction Table) */
CREATE TABLE Facilities_Included (
    AccommodationID VARCHAR(20),
    FacilityID      VARCHAR(20),
    CONSTRAINT PK_Facilities_Included PRIMARY KEY (AccommodationID, FacilityID),
    CONSTRAINT FK_Facilities_Included_Accommodation 
        FOREIGN KEY (AccommodationID) REFERENCES Accommodation(AccommodationID),
    CONSTRAINT FK_Facilities_Included_Facility 
        FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID)
);

/* 10. Guest_Account Table */
CREATE TABLE Guest_Account (
    GuestCardID VARCHAR(20) PRIMARY KEY,
    UserName    NVARCHAR(50),
    Password    NVARCHAR(50),
    FirstName   NVARCHAR(100),
    LastName    NVARCHAR(100),
    DOB         DATE,
    Phone       VARCHAR(20),
    Email       VARCHAR(100)
);

/* 11. Voucher_Coupon Table */
CREATE TABLE Voucher_Coupon (
    VoucherCouponID VARCHAR(20) PRIMARY KEY,
    DiscountAmount  DECIMAL(10,2),
    DiscountUnit    VARCHAR(20),
    ValidDate       DATE,
    ExpiryDate      DATE
);

/* 12. Booking Table */
CREATE TABLE Booking (
    BookingID            VARCHAR(20) PRIMARY KEY,
    GuestCardID          VARCHAR(20),
    AccommodationID      VARCHAR(20),
    ReservedCheckInTime  DATETIME,       
    CheckInTime          DATETIME,      
    CheckOutTime         DATETIME,       
    VoucherCouponID      VARCHAR(20),
    IsCancelled          BIT,
    CONSTRAINT FK_Booking_Guest_Account 
        FOREIGN KEY (GuestCardID) REFERENCES Guest_Account(GuestCardID),
    CONSTRAINT FK_Booking_Accommodation 
        FOREIGN KEY (AccommodationID) REFERENCES Accommodation(AccommodationID),
    CONSTRAINT FK_Booking_Voucher_Coupon 
        FOREIGN KEY (VoucherCouponID) REFERENCES Voucher_Coupon(VoucherCouponID)
);

/* 13. Payment Table */
CREATE TABLE Payment (
    TransactionID VARCHAR(20) PRIMARY KEY,
    BookingID     VARCHAR(20),
    PaymentMethod VARCHAR(50),
    BankAccount   VARCHAR(50),
    CONSTRAINT FK_Payment_Booking 
        FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
);

/* 14. Feedback Table */
CREATE TABLE Feedback (
    GuestCardID     VARCHAR(20) NOT NULL,
    AccommodationID VARCHAR(20) NOT NULL,
    Rating          DECIMAL(3,2),
    Comments        VARCHAR(500),
    CONSTRAINT PK_Feedback PRIMARY KEY (GuestCardID, AccommodationID),
    CONSTRAINT FK_Feedback_Guest_Account 
        FOREIGN KEY (GuestCardID) REFERENCES Guest_Account(GuestCardID),
    CONSTRAINT FK_Feedback_Accommodation 
        FOREIGN KEY (AccommodationID) REFERENCES Accommodation(AccommodationID)
);


-- 4.2 Implement price change tracking

IF OBJECT_ID('AccommodationPriceHistory', 'U') IS NOT NULL
    DROP TABLE AccommodationPriceHistory;
GO

CREATE TABLE AccommodationPriceHistory (
    HistoryID           INT IDENTITY(1,1) PRIMARY KEY,
    AccommodationID     VARCHAR(20)     NOT NULL,
    OldPrice            DECIMAL(15, 2)  NOT NULL,
    NewPrice            DECIMAL(15, 2)  NOT NULL,
    ChangeDate          DATETIME        NOT NULL DEFAULT(GETDATE()),
    ChangedBy           SYSNAME         NOT NULL DEFAULT(SYSTEM_USER),
    CONSTRAINT FK_PriceChange_Accomodation
        FOREIGN KEY (AccommodationID) REFERENCES Accommodation(AccommodationID)
);
GO

-- Trigger to capture price changes

CREATE OR ALTER TRIGGER dbo.trg_Accommodation_PriceChange
ON dbo.Accommodation
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Only proceed if PricePerNight changed
    IF UPDATE(PricePerNight)
    BEGIN
        INSERT INTO dbo.AccommodationPriceHistory
            (AccommodationID, OldPrice, NewPrice)
        SELECT
            d.AccommodationID,
            d.PricePerNight,     -- old value from deleted
            i.PricePerNight      -- new value from inserted
        FROM deleted d
        JOIN inserted i
          ON d.AccommodationID = i.AccommodationID
        WHERE d.PricePerNight <> i.PricePerNight;
    END
END;
GO

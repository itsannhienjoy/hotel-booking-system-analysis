# 🏨 Hotel Booking System - Database Design & Analysis

This project demonstrates the design, implementation, and analysis of a relational **Hotel Booking System** using SQL. The system captures end-to-end operations for hotel management including accommodations, guests, bookings, payments, and feedback, along with amenities, facilities, and discount handling.

## 📊 Entity Relationship Diagram (ERD)

The following ERD illustrates the relationships between key entities in the system:

![Hotel Booking System ERD](./submission/1%20-%20ERD.png)

## 🧱 Key Entities and Relationships

- **Province & City_District**: Hierarchical location data to localize accommodations.
- **Accommodation & Owner_Account**: Each property is managed by an owner and linked to a location and type.
- **Guest_Account**: Registered guests who can make bookings and leave feedback.
- **Booking**: Central fact table linking guests with accommodations. Tracks check-in/out, cancellations, and applied discount vouchers.
- **Payment**: Captures the transaction details for completed bookings.
- **Voucher_Coupon**: Promotional codes applied to bookings, supporting discounts in various units.
- **Facilities & Amenities**: Many-to-many relationship tables for enhanced property features.
- **Feedback**: Guests can leave ratings and comments after their stay.

## 📁 SQL File Contents

The project is modularized into several SQL scripts:

| File | Description |
|------|-------------|
| `1 - ERD.png` | Entity Relationship Diagram |
| `2.sql` | Data definition for lookup tables (Province, City_District, etc.) |
| `3.sql` | Core schema creation for bookings, users, and accommodations |
| `4.1.sql` to `4.3.sql` | DML scripts for inserting sample data |
| `5.1.sql` to `5.4.sql` | Complex SQL queries and analytics (e.g., occupancy rate, top-rated properties) |

## 🔍 Analytical Highlights

- **Top-performing accommodations** by revenue, bookings, and guest feedback
- **Occupancy rate trends** over time (daily, weekly, seasonal)
- **Guest behavior analysis**: repeat guests, peak booking periods
- **Impact of discounts** on booking volume and revenue
- **Facility usage insights** across property types

## 🛠 Technologies Used

- Microsoft SQL Server 
- dbdiagram.io for ERD design
- Azure Data Studio for querying

---

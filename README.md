# Hotel Booking System - Database Design & Analysis

This project demonstrates the design, implementation, and analysis of a relational **Hotel Booking System** using SQL. The system captures end-to-end operations for hotel management including accommodations, guests, bookings, payments, and feedback, along with amenities, facilities, and discount handling.

## Entity Relationship Diagram (ERD) 📊 

The following ERD visualizes the logical structure of the system and the relationships between its core entities

![Hotel Booking System ERD](./submission/1%20-%20ERD.png)

## Key Entities and Relationships

- **Province & City_District**: Hierarchical location data to localize accommodations.
- **Accommodation & Owner_Account**: Each property is managed by an owner and linked to a location and type.
- **Guest_Account**: Registered guests who can make bookings and leave feedback.
- **Booking**: Central fact table linking guests with accommodations. Tracks check-in/out, cancellations, and applied discount vouchers.
- **Payment**: Captures the transaction details for completed bookings.
- **Voucher_Coupon**: Promotional codes applied to bookings, supporting discounts in various units.
- **Facilities & Amenities**: Many-to-many relationship tables for enhanced property features.
- **Feedback**: Guests can leave ratings and comments after their stay.

## Project File Strucre
The repository contains modular SQL scripts for ease of use and clarity
| File | Description |
|------|-------------|
| `1 - ERD.png` | Entity Relationship Diagram |
| `2.sql` | Schema for reference tables |
| `3.sql` | Core schema creation for bookings, users, and accommodations |
| `4.1.sql` to `4.3.sql` | Sample data insertion scripts |
| `5.1.sql` to `5.4.sql` | Analytical and reporting queries |

## 🔍 Analytical Highlights

- Identify top-performing accommodations based on revenue, feedback, and bookings
- Analyze occupancy trends by time period (daily/weekly/seasonal)
- Track guest behavior such as return visits and peak demand windows
- Assess the impact of vouchers and discounts on overall revenue and engagement
- Explore amenity and facility usage patterns across property types

---

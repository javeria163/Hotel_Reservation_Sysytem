# 🏨 Hotel Reservation System — Database Project

A relational database project implementing a fully normalized Hotel Reservation System, developed as part of a Database course. The project covers requirements analysis, schema design, normalization, SQL scripting, stored procedures, triggers, views, and query testing.

---

## 📁 Repository Structure

| File | Description |
|------|-------------|
| `ERD.pdf` | Entity-Relationship Diagram (initial design) |
| `normalized_ERD.pdf` | Updated ERD after 3NF normalization |
| `Normalization_Report.docx` | Detailed 3NF normalization justification for all tables |
| `functional,non functional , business rules.docx` | Functional & non-functional requirements and business rules |
| `final_script.sql` | Complete DDL script — creates all tables with constraints |
| `DDL,DML,SEQUENCE,INDEX,VIEW.docx` | Documentation for DDL, DML, sequences, indexes, and views |
| `indexes_and_views.sql` | SQL script for creating indexes and views |
| `complex_queries.sql` | Collection of complex SQL queries |
| `complex_queris_testing.docx` | Testing results and output screenshots for complex queries |
| `hotel_procedures.sql` | Stored procedures for hotel reservation operations |
| `triggers.sql` | Triggers for enforcing business rules automatically |
| `procedure,triggers,testing.docx` | Testing results for procedures and triggers |
| `project_final report.docx` | Final comprehensive project report |

---

## 🗄️ Database Overview

The system manages hotel reservations through the following core tables:

- **HOTEL** — Hotel details (name, location)
- **ROOM** — Rooms linked to hotels and room types
- **ROOM_TYPE** — Room categories with rates and descriptions
- **GUEST** — Guest profiles (contact, email, address)
- **RESERVATION** — Booking records with check-in/check-out dates
- **RESERVATION_ROOM** — Junction table linking reservations to rooms
- **PAYMENT** — Payment records per reservation
- **SERVICE** — Available hotel services with charges
- **SERVICE_RECORD** — Services rendered per reservation/room/staff
- **STAFF** — Staff members linked to hotels and roles
- **ROLE** — Staff role definitions

---

## ✅ Normalization

All tables are normalized to **Third Normal Form (3NF)**:
- No partial dependencies
- No transitive dependencies
- All non-key attributes depend solely on the primary key

See `Normalization_Report.docx` for the full justification.

---

## 🚀 How to Run

1. Execute `final_script.sql` to create the database schema.
2. Run `indexes_and_views.sql` to set up indexes and views.
3. Run `hotel_procedures.sql` to create stored procedures.
4. Run `triggers.sql` to activate all triggers.
5. Use `complex_queries.sql` to test and explore the data.

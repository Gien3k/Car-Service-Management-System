# Car Service Management System (Oracle DB & APEX)

[![Oracle SQL & PL/SQL](https://img.shields.io/badge/Oracle-SQL%20%26%20PL%2FSQL-red)](https://www.oracle.com/database/)
[![Oracle APEX](https://img.shields.io/badge/Oracle-APEX-orange)](https://apex.oracle.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE) 

This repository contains the database schema (Oracle SQL, PL/SQL) and an Oracle APEX application export for a **Car Service Management System**. It provides a comprehensive backend structure and a corresponding web frontend designed to manage the core operations of a car repair workshop.

The project demonstrates skills in relational database design, SQL query writing, advanced PL/SQL programming (including packages, procedures, functions, and triggers for automation), code organization, version control with Git, and integration with Oracle's low-code platform, APEX. 
## Key Features

* **Database Backend:**
    * Robust schema for managing customers, vehicles, parts inventory, suppliers, services, promotions, repair orders, invoices, payments, employees, and user reviews.
    * PL/SQL packages encapsulating business logic for orders (`pkg_orders`) and inventory (`pkg_inventory`).
    * Stored procedures and functions for specific operations (e.g., adding clients with vehicles, calculating order costs, generating reports).
    * Database triggers for automation and data integrity (e.g., automatic ID generation using sequences, checking inventory levels, updating history).
    * Database views for simplified data access and reporting.
    * Clear separation of DDL (Data Definition Language) and DML/Logic (PL/SQL).
* **APEX Frontend (f259915.sql):**
    * Web-based user interface for interacting with the database.
    * Functionality likely includes viewing/editing customer and vehicle data, managing repair orders, viewing inventory, processing invoices, etc. (based on application structure).
    * User authentication mechanism.
    * Navigation menus and reporting pages.

## Technology Stack

* **Database:** Oracle Database 
* **Backend Logic:** SQL, PL/SQL
* **Frontend:** Oracle Application Express (APEX)
* **Version Control:** Git

## Database Schema Details

* **Tables (`schema/tables/`):** Define the core entities of the system. Table and column names are in English.
* **Sequences (`schema/sequences/`):** Used for generating primary key values automatically, typically via triggers.
* **Constraints (`schema/constraints/`):** Enforces data integrity using primary keys (often defined inline in tables) and foreign keys.
* **Indexes (`schema/indexes/`):** Improve query performance. Includes primary/unique key indexes and potentially custom ones.
* **Views (`schema/views/`):** Provide simplified or aggregated views of the data for reporting or application use. View and column names are in English.
* **PL/SQL (`plsql/`):** Contains the procedural logic:
    * **Functions:** Reusable units for calculations or data retrieval.
    * **Procedures:** Perform specific actions or business processes.
    * **Packages:** Group related procedures, functions, and variables (`pkg_inventory`, `pkg_orders`).
    * **Triggers:** Automate actions based on database events (e.g., before insert, after update).

## Setup Instructions

To set up the database and import the APEX application:

1.  **Database Environment:**
    * Ensure you have access to an Oracle Database instance.
    * Create a database user/schema 
    * Grant necessary privileges: `CONNECT`, `RESOURCE`, `CREATE VIEW`, `CREATE SEQUENCE`, `CREATE PROCEDURE`, `CREATE TRIGGER`, `CREATE TABLE`, etc.
2.  **Deploy Database Schema:**
    * Connect to the database as the schema owner (using SQL*Plus, SQLcl, SQL Developer, etc.).
    * Execute the SQL scripts from the `schema/` and `plsql/` directories in the following recommended order:
        1.  `schema/tables/*.sql`
        2.  `schema/sequences/sequences.sql`
        3.  `schema/indexes/indexes.sql`
        4.  `schema/constraints/constraints.sql`
        5.  `schema/views/*.sql`
        6.  `plsql/functions/*.sql`
        7.  `plsql/packages/*_spec.sql`
        8.  `plsql/procedures/*.sql`
        9.  `plsql/packages/*_body.sql`
        10. `plsql/triggers/*.sql`
        *(Ensure all dependencies are met during execution).*
3.  **APEX Environment:**
    * Ensure an Oracle APEX workspace is available and associated with the database schema from Step 1.
4.  **Import APEX Application:**
    * **Method 1 (Recommended):** Log in to your APEX workspace, navigate to Application Builder -> Import, and upload the `apex/f259915.sql` file. Follow the import wizard steps, ensuring you map it to the correct database schema.
    * **Method 2 (SQL*Plus/SQLcl):** Connect to the database as the schema owner (or a user with APEX admin privileges) and run the `apex/f259915.sql` script.
5.  **Run Application:**
    * Log in to your APEX workspace and run the imported application (ID 259915). Perform any necessary post-import configuration if needed (e.g., authentication scheme setup).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


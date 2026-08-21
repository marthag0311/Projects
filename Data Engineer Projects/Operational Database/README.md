## Operational Database Project

The project aims to develop a SQL Server–based relational database that serves as the central data repository for a manufacturing company. The database manages the complete business workflow, including:

- Customer and supplier information
- Employee records
- Raw materials and suppliers
- Products and bills of materials (which materials make up each product)
- Inventory movements for materials and finished products
- Product pricing with historical price tracking
- Customer orders and order details
- Order status tracking
- Daily inventory snapshots for reporting

### Project objectives

- Design a normalized relational database.
- Ensure data integrity using constraints and relationships.
- Record and manage business transactions efficiently.
- Track inventory movements and stock levels.
- Maintain historical product pricing.
- Support operational reporting and future business analytics.
- Provide a scalable database structure that can be integrated with applications such as Excel, Power BI, or a custom management system.

### Physical Data Model

The database is designed using relational database principles (Third Normal Form) to minimize data redundancy and maintain data integrity through primary and foreign key relationships. Although the primary purpose is to support transactional processing (OLTP), the inclusion of a date dimension and inventory snapshot tables also provides a foundation for business intelligence and reporting.

![Physical Data Model](https://github.com/marthag0311/Projects/blob/main/Data%20Engineer%20Projects/Operational%20Database/docs/operational_database_physical_model.png)

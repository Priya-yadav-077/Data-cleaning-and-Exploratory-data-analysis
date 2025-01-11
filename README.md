### Project Title: Data Cleaning and Exploratory Data Analysis on Layoffs Dataset

---

#### Overview
This project focuses on cleaning and performing exploratory data analysis (EDA) on a dataset containing information about company layoffs, sourced from Kaggle. The entire analysis was conducted using MySQL, leveraging its powerful capabilities for data manipulation and querying.

---

#### Project Objectives
- Clean and preprocess the dataset to ensure data consistency and accuracy.
- Perform exploratory data analysis (EDA) to uncover insights and trends related to layoffs.
- Utilize SQL functions and queries for summarizing and visualizing key data patterns.

---

#### Dataset
- Source:[Kaggle Layoffs Dataset](https://www.kaggle.com/)  
- Contents:The dataset contains information on layoffs by company, industry, date, and total employees laid off.

---

#### Key Steps and Processes
1. Data Cleaning
   - Handled missing values and ensured data integrity.
   - Standardized column formats (e.g., date transformations).
   - Removed duplicates and outliers.
   - Remove columns and rows
   
2. Exploratory Data Analysis (EDA)
   - Analyzed layoff trends over time and across industries.
   - Identified companies and sectors with the highest layoffs.
   - Generated insights using SQL functions such as `GROUP BY`, `Common temporary table`, and window functions (`OVER()`).

---

#### SQL Techniques and Queries Used
- `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`,`Dense_rank`
- Aggregate functions (`SUM`, `AVG`, `COUNT`)
- Date functions (`YEAR`, `MONTH`)
- Subqueries and Common Table Expressions (CTEs)
- Window functions for rolling totals and cumulative analysis

---



#### Key Findings
- Layoff trends varied significantly by industry and company size.
- A few companies accounted for a disproportionately large number of layoffs.
- Seasonal and yearly trends were identified in the layoff patterns.

---

#### Technologies Used
- Database: MySQL
- Tools: MySQL Workbench, SQL Queries
- Platform:Kaggle Dataset

---

#### Conclusion
This project demonstrates the effective use of SQL for data cleaning and exploratory analysis. It highlights the importance of structured data analysis for extracting valuable business insights.

---

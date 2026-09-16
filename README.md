# 🧹 Nashville Housing Data Cleaning & Transformation (SQL)

## 📋 Project Overview
This project showcases advanced **SQL data cleaning and preprocessing** techniques performed on a raw Nashville Housing dataset using **MySQL**. Raw datasets frequently contain formatting issues, missing values, unstandardized text fields, and duplicates. This script transforms the raw data into a clean, structured format ready for professional analysis and reporting.

---

## 🛠️ Tech Stack & SQL Concepts Used
* **Database Management System:** MySQL
* **Key Operations & Functions:**
  * **Date Standardization:** Converting text-based date fields using `STR_TO_DATE()`.
  * **Handling Nulls & Joins:** Utilizing self-joins (`JOIN`) and `COALESCE()` to populate missing property addresses based on matching parcel IDs.
  * **String Manipulation:** Splitting complex address strings into individual components using `SUBSTRING`, `LOCATE`, and `SUBSTRING_INDEX`.
  * **Data Standardization:** Normalizing inconsistent entries (e.g., converting 'Y' and 'N' to 'Yes' and 'No' using `CASE` statements).
  * **Duplicate Removal:** Leveraging Common Table Expressions (**CTEs**) and Window Functions (`ROW_NUMBER() OVER (PARTITION BY ...)`) to identify and filter duplicate records.
  * **Table Schema Optimization:** Altering tables, dropping redundant columns, and managing safe update modes (`SET SQL_SAFE_UPDATES = 0/1`).

---

## 🔍 Step-by-Step Cleaning Process

1. **Standardizing Date Formats:** Converted `SaleDate` from text strings into uniform date values.
2. **Populating Missing Property Addresses:** Used self-joins on `ParcelID` to fill in missing `PropertyAddress` fields where applicable.
3. **Breaking Out Addresses:** Parsed combined address lines into distinct columns for Address, City, and State.
4. **Standardizing Field Values:** Cleaned up the `SoldAsVacant` field to ensure consistent categorical representation ('Yes' / 'No').
5. **Removing Duplicates:** Applied a CTE with `ROW_NUMBER()` partitioned across unique identifiers to isolate and remove redundant rows.
6. **Deleting Unused Columns:** Streamlined the database schema by dropping deprecated raw columns (`OwnerAddress`, `TaxDistrict`, `PropertyAddress`, and old `SaleDate`).

---

## 📁 File Structure
* [`DataCleaninguseing SQL.sql`](./DataCleaninguseing%20SQL.sql) — Contains the full end-to-end MySQL data cleaning script.

---

## 🚀 How to Run the Script
1. Clone or download this repository.
2. Import the raw Nashville Housing dataset into your MySQL environment under a schema named `portfoliproject`.
3. Execute the script sections sequentially inside your MySQL workbench to observe the data transformation pipeline.

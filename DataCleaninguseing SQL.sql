-- Cleaning Data in SQL Queries

Select*
From portfoliproject.nashvillehousing;

-- Standardize Date Format

Select SaleDate, STR_TO_DATE(SaleDate, '%M %d, %Y')
From portfoliproject.nashvillehousing;

SET SQL_SAFE_UPDATES = 0;

Update nashvillehousing
Set SaleDate = STR_TO_DATE(SaleDate, '%M %d, %Y');

SET SQL_SAFE_UPDATES = 1;

Update nashvillehousing
Set SaleDate = STR_TO_DATE(SaleDate, '%M %d, %Y')
Where UniqueID IS NOT NULL;

Select SaleDate 
From nashvillehousing ;

-- Populate Property Address data

Select *
From portfoliproject.nashvillehousing a
JOIN portfoliproject.nashvillehousing b
on a.ParcelID = b.parcelID
AND a.`ï»¿UniqueID` <> b.`ï»¿UniqueID`;

ALTER TABLE nashvillehousing 
CHANGE COLUMN `ï»¿UniqueID` UniqueID INT;

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, COALESCE(a.PropertyAddress, b.PropertyAddress)
From portfoliproject.nashvillehousing a
JOIN portfoliproject.nashvillehousing b
on a.ParcelID = b.parcelID
AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;

-- Breaking out Address into Individual Cloumns (Address, City, State)

Select PropertyAddress
From nashvillehousing
order by parcelID;

SELECT 
    SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1) AS Address,
    SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1, LENGTH(PropertyAddress)) AS City
FROM nashvillehousing;

-- 1. Add the new columns for Owner Address, City, and State

ALTER TABLE nashvillehousing
ADD COLUMN OwnerSplitAddress VARCHAR(255),
ADD COLUMN OwnerSplitCity VARCHAR(255),
ADD COLUMN OwnerSplitState VARCHAR(255);

-- 2. Update the table to populate the columns using MySQL string functions
SET SQL_SAFE_UPDATES = 0;

UPDATE nashvillehousing
SET 
    OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1),
    OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1),
    OwnerSplitState = SUBSTRING_INDEX(OwnerAddress, ',', -1);

SET SQL_SAFE_UPDATES = 1;

-- 3. Verify the final result
SELECT OwnerAddress, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState 
FROM nashvillehousing;

-- Change Y and N to Yes and No in "solid as vacant" field

SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM nashvillehousing
Group by SoldAsVacant
Order by 2;

SET SQL_SAFE_UPDATES = 0;

UPDATE nashvillehousing
SET SoldAsVacant = CASE 
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END;

SET SQL_SAFE_UPDATES = 1;

SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM nashvillehousing
GROUP BY SoldAsVacant;

-- Remove Deplicates

WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID, 
                         PropertyAddress, 
                         SalePrice, 
                         SaleDate, 
                         LegalReference 
            ORDER BY UniqueID
        ) AS row_num
    FROM portfoliproject.nashvillehousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;

-- Delete Unused Columns

Select *
From portfoliproject.nashvillehousing;

ALTER TABLE nashvillehousing
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN PropertyAddress;

ALTER TABLE nashvillehousing
DROP COLUMN SaleDate;
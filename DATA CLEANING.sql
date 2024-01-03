--ALL DATA

SELECT * 
FROM DataSet


--STANDARDIZED DATE FORMAT

SELECT SaleDate
FROM DataSet 

ALTER TABLE DataSet
ALTER COLUMN SaleDate date


--Populate Proper Address Data

--First detect the null value on Property Address
SELECT *
FROM DataSet
WHERE PropertyAddress is null
ORDER BY ParcelID

--Using ISNULL function to replace thr null value 
SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM DataSet a
JOIN DataSet b
	ON a.ParcelID=b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Update data into table a
UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM DataSet a
JOIN DataSet b
	ON a.ParcelID=b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


--Breaking out address into individual columns(Address,City,State)

-----PROPERTY ADDRESS-----
SELECT PropertyAddress
FROM DataSet

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS Address
FROM DataSet

ALTER TABLE DataSet
ADD PropertySplitAddress NVARCHAR(255)

UPDATE DataSet
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE DataSet
ADD PropertySplitCity NVARCHAR(255)

UPDATE DataSet
SET PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

-----OWNER ADRESS-----
SELECT OwnerAddress
FROM Dataset

SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3),
       PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	   PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM DataSet

ALTER TABLE DataSet
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE DataSet
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE DataSet
ADD OwnerSplitCity NVARCHAR(255)

UPDATE DataSet
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE DataSet
ADD OwnerSplitState NVARCHAR(255)

UPDATE DataSet
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)


--Change Y aand N to Yes and No in 'Sold As Vacant' field

SELECT DISTINCT(SoldAsVacant) ,COUNT(SoldAsVacant)
FROM DataSet
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
	CASE 
		WHEN SoldAsVacant='Y' THEN 'Yes'
		WHEN SoldAsVacant='N' THEN 'No'
		ELSE SoldAsVacant
	END
FROM DataSet

UPDATE DataSet
SET SoldAsVacant = CASE WHEN SoldAsVacant='Y' THEN 'Yes'
		                WHEN SoldAsVacant='N' THEN 'No'
		                ELSE SoldAsVacant
	               END


--Remove Duplicate 

--TO CHECK DUPLICATE
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
	ORDER BY UniqueID) row_num
FROM DataSet
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

--TO DELETE DUPLICATE
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
	ORDER BY UniqueID) row_num
FROM DataSet
--ORDER BY ParcelID
)
DELETE
FROM RowNumCTE
WHERE row_num > 1


--Delete Unused Column
--Example: for visualization purpose 

SELECT *
FROM DataSet

ALTER TABLE DataSet
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress,SaleDate

ALTER TABLE DataSet
DROP COLUMN SaleDate

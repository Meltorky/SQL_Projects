/***************************************
**    Data Cleaning in SQL Queries    **
****************************************/



select *
from dbo.NashvilleHousing
--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


select SaleDate, cast(SaleDate as date)
from dbo.NashvilleHousing;

update dbo.NashvilleHousing
set SaleDates = cast(SaleDate as date);


ALTER TABLE dbo.NashvilleHousing
add SaleDates date;


Alter table NashvilleHousing
drop column SaleDate;


Select *
from dbo.NashvilleHousing

-- If it doesn't Update properly

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

select * 
from dbo.NashvilleHousing
-- where PropertyAddress is null;
order by ParcelID;


select na.ParcelID ,na.PropertyAddress, na2.ParcelID , na2.PropertyAddress
from dbo.NashvilleHousing na
join dbo.NashvilleHousing na2
    on na.ParcelID = na2.ParcelID
    and na.UniqueID <> na2.UniqueID
where na.PropertyAddress is null;

update na
set PropertyAddress = isnull(na.PropertyAddress,na2.PropertyAddress)
from dbo.NashvilleHousing na
join dbo.NashvilleHousing na2
    on na.ParcelID = na2.ParcelID
    and na.UniqueID <> na2.UniqueID
where na.PropertyAddress is null;




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from dbo.NashvilleHousing


select
SUBSTRING(PropertyAddress,1,(CHARINDEX(',',PropertyAddress))-1) as Address
,SUBSTRING(PropertyAddress,(CHARINDEX(',',PropertyAddress))+1,len(PropertyAddress)) as State
from dbo.NashvilleHousing

alter table NashvilleHousing
add Address nvarchar(50) , State nvarchar;

select *
from dbo.NashvilleHousing;

update NashvilleHousing
set Address = SUBSTRING(PropertyAddress,1,(CHARINDEX(',',PropertyAddress))-1);
    

update NashvilleHousing
set State = SUBSTRING(PropertyAddress,(CHARINDEX(',',PropertyAddress))+1,len(PropertyAddress));

alter table NashvilleHousing
drop column PropertyAddress;



Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From dbo.NashvilleHousing

alter table NashvilleHousing
add OwnerLiveAddress nvarchar(50), OwnerState nvarchar(50),OwnerIP nvarchar(50);

update dbo.NashvilleHousing
set OwnerLiveAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);

update dbo.NashvilleHousing
set OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);


update dbo.NashvilleHousing
set OwnerIP = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);

select * 
from dbo.NashvilleHousing;

Alter table NashvilleHousing
drop column OwnerAddress;


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


select distinct(SoldAsVacant)
from dbo.NashvilleHousing;

update NashvilleHousing
set SoldAsVacant = case
          when SoldAsVacant = 'Y' then 'Yes'
		  when SoldAsVacant = 'N' then 'No'
		  else SoldAsVacant
		  end


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates




--Where PropertyAddress is null
--order by ParcelID

SELECT DISTINCT *
from dbo.NashvilleHousing;

SELECT *
from dbo.NashvilleHousing;


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 Address,
				 SalePrice,
				 SaleDates,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From dbo.NashvilleHousing
--order by ParcelID
)
Delete             -- I Put 'Delete' instead of 'Select *' and comment the last row
From RowNumCTE
Where row_num > 1
-- Order by ParcelID

select *
from dbo.NashvilleHousing;

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN TaxDistrict;


select *
from dbo.NashvilleHousing;

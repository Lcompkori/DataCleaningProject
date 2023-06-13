-- Cleaning data in SQL queries

Select 
	* 
From 
	PortfolioProject..NashvilleHousing;

-- Standarize Date Format Using Alter and Update Statements

Select 
	SaleDate2
From 
	PortfolioProject..NashvilleHousing;

Alter table PortfolioProject..NashvilleHousing
Add SaleDate2 Date;

Update PortfolioProject..NashvilleHousing
SET SaleDate2 = CONVERT(date, saledate);

-- Populate Property Address Data

Select 
	PropertyAddress
From 
	PortfolioProject..NashvilleHousing
Where 
	PropertyAddress is null;

-- Updating PropertyAddress with NULL values Using Self-Join and Update Statement:

Select 
	a.ParcelID, 
	a.PropertyAddress, 
	b.ParcelID, 
	b.PropertyAddress, 
	ISNULL(a.PropertyAddress,b.PropertyAddress)
From 
	PortfolioProject..NashvilleHousing a
			JOIN 
		PortfolioProject..NashvilleHousing b 
		ON a.ParcelID = b.ParcelID
		AND a.[UniqueID ] <> b.[UniqueID ]
Where 
	a.PropertyAddress is null

Update a
	Set PropertyAddress = ISNULL(a.propertyaddress,b.propertyaddress) 
	From 
		PortfolioProject..NashvilleHousing a
			JOIN 
			PortfolioProject..NashvilleHousing b
			ON a.ParcelID = b.ParcelID
			AND a.[UniqueID ] <> b.[UniqueID ]
	Where 
		a.PropertyAddress is null;

-- Seperating PropertyAddress into individual columns (Address, City) using Substring function

Select 
	PropertyAddress
From 
	PortfolioProject..NashvilleHousing;

Select
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
From 
	PortfolioProject..NashvilleHousing;

Alter table PortfolioProject..NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Alter table PortfolioProject..NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject..NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);

Update PortfolioProject..NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress));

Select 
	PropertySplitAddress, PropertySplitCity
From 
	PortfolioProject..NashvilleHousing;

Select 
	*
From 
	PortfolioProject..NashvilleHousing;

-- Seperating OwnerAddress into individual columns(Address, City, State) using Parsename function

Select 
	OwnerAddress
From 
	PortfolioProject..NashvilleHousing ;

Select
	PARSENAME(Replace(OwnerAddress, ',', '.'), 3),
	PARSENAME(Replace(OwnerAddress, ',', '.'), 2),
	PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
From 
	PortfolioProject..NashvilleHousing;

Alter Table PortfolioProject..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Alter Table PortfolioProject..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Alter table PortfolioProject..NashvilleHousing
Add OwnerSplitState Nvarchar(50);

Update PortfolioProject..NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3);

Update PortfolioProject..NashvilleHousing
Set OwnerSplitCity = Parsename(Replace(OwnerAddress, ',', '.'), 2);

Update PortfolioProject..NashvilleHousing
Set OwnerSplitState = Parsename(Replace(Owneraddress, ',','.'), 1);

Select
	OwnerSplitAddress, 
	OwnerSplitCity, 
	OwnerSplitState
From 
	PortfolioProject..NashvilleHousing;

Select 
	*
From 
	PortfolioProject..NashvilleHousing;

-- Changing Y and N to Yes and No in "Sold as Vacant" field using CASE statements

Select Distinct 
	(SoldAsVacant), 
	Count(soldasvacant) as NumberOfHouses
From 
	PortfolioProject..NashvilleHousing
Group by 
	SoldAsVacant
order by 
	2;

Select 
	SoldAsVacant,
		CASE 
			When SoldAsVacant = 'Y' Then 'Yes'
			When SoldAsVacant = 'N' Then 'No'
			Else SoldAsVacant
		End 
From
	PortfolioProject..NashvilleHousing;

Update PortfolioProject..NashvilleHousing
Set SoldAsVacant = CASE 
			When SoldAsVacant = 'Y' Then 'Yes'
			When SoldAsVacant = 'N' Then 'No'
			Else SoldAsVacant
		End;

Select 
	* 
From 
	PortfolioProject..NashvilleHousing;

-- Removing Duplicates

WITH RowNumCTE As (
Select *,
	ROW_NUMBER() OVER (
	Partition By ParcelID, 
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order By 
					UniqueID
					) row_num
From PortfolioProject..NashvilleHousing
)
DELETE
From
	RowNumCTE
Where 
	row_num > 1;

WITH RowNumCTE As (
Select *,
	ROW_NUMBER() OVER (
	Partition By ParcelID, 
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order By 
					UniqueID
					) row_num
From PortfolioProject..NashvilleHousing
)
Select 
	*
From
	RowNumCTE
Where 
	row_num > 1;

-- Deleting Unused Columns

Alter table PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, SaleDate

Select 
	*
From 
	PortfolioProject..NashvilleHousing;
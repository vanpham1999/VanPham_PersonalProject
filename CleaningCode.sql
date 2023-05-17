--DATA CLEANING PROJECT

--Standardize Date Format
Select SaleDate, 
CONVERT(Date, SaleDate)	as New_Date
From PortfolioProject.dbo.NashvilleHousing

--Populate Property Address data (Property Address column has null values, wen want to replace those null values by the property address which has the same ParcelID)
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


--Breaking out the Address into Individual Columns (Address, City, State)
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City
From PortfolioProject.dbo.NashvilleHousing 







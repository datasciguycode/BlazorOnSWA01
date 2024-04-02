#  MVC Application
# DotNetMastery - Introduction to ASP.NET Core MVC (.NET 8)
# https://www.youtube.com/watch?v=AopeJjkcRvU
# https://github.com/bhrugen/Bulky_MVC/blob/master/Bulky


# Init *
. .\z_BuildMe\BuildMe2.ps1

# Git *
Initialize-Git

# Add New Projects *
dotnet new classlib -n "Bulky.Infrastructure"
dotnet new classlib -n "Bulky.App"
dotnet new classlib -n "Bulky.Domain"
dotnet new sln -n BulkyWeb

# Add projects to solution *
dotnet sln .\BulkyWeb.sln add .\BulkyWeb\BulkyWeb.csproj
dotnet sln .\BulkyWeb.sln add .\Bulky.Infrastructure\Bulky.Infrastructure.csproj
dotnet sln .\BulkyWeb.sln add .\Bulky.App\Bulky.App.csproj
dotnet sln .\BulkyWeb.sln add .\Bulky.Domain\Bulky.Domain.csproj

# Web -> App
dotnet add .\BulkyWeb\BulkyWeb.csproj reference .\Bulky.App\Bulky.App.csproj

# Infrastructure -> App
dotnet add .\Bulky.Infrastructure\Bulky.Infrastructure.csproj reference .\Bulky.App\Bulky.App.csproj

# App -> Domain
dotnet add .\Bulky.App\Bulky.App.csproj reference .\Bulky.Domain\Bulky.Domain.csproj

# Add new css:  https://bootswatch.com/

# Move models Bulky.Domain

# Add static cs file to Bulky.Utility

# Add packages to Bulky.Data
Install-Package -p_strProjectFilePath ".\Bulky.Infrastructure\Bulky.Infrastructure.csproj" -p_strPackageName "Microsoft.EntityFrameworkCore"
Install-Package -p_strProjectFilePath ".\Bulky.Infrastructure\Bulky.Infrastructure.csproj" -p_strPackageName "Microsoft.EntityFrameworkCore.Tools"
Install-Package -p_strProjectFilePath ".\Bulky.Infrastructure\Bulky.Infrastructure.csproj" -p_strPackageName "Microsoft.EntityFrameworkCore.SqlServer"
Install-Package -p_strProjectFilePath ".\Bulky.Infrastructure\Bulky.Infrastructure.csproj" -p_strPackageName "Microsoft.VisualStudio.Web.CodeGeneration.Design"

# Web -> App
dotnet add ".\BulkyWeb\BulkyWeb.csproj" reference ".\Bulky.App\Bulky.App.csproj"

# Web -> Infrastructure
dotnet add ".\BulkyWeb\BulkyWeb.csproj" reference ".\Bulky.Infrastructure\Bulky.Infrastructure.csproj"

# Infrastructure -> App
dotnet add ".\Bulky.Infrastructure\Bulky.Infrastructure.csproj" reference ".\Bulky.App\Bulky.App.csproj"

# App -> Domain
dotnet add ".\Bulky.App\Bulky.App.csproj" reference ".\Bulky.Domain\Bulky.Domain.csproj"

Add-GitCommit -p_strCommitMessage "Model to Bulky.Domain"
Add-GitCommit -p_strCommitMessage "Projects linked"
Add-GitCommit -p_strCommitMessage "DbContext to Infrastructure"
Add-GitCommit -p_strCommitMessage "Migrations to Infrastructure"

4:58

# Add files and folders
New-Item -ItemType Directory -Path ".\Bulky.Infrastructure\Repository"
New-Item -ItemType Directory -Path ".\Bulky.Infrastructure\Repository\IRepository"
New-Item -ItemType File -Path ".\Bulky.Infrastructure\Repository\IRepository\IRepository.cs"
New-Item -ItemType File -Path ".\Bulky.Infrastructure\Repository\Repository.cs"

Add-GitCommit -p_strCommitMessage "IRepository and Repository added"

New-Item -ItemType File -Path ".\Bulky.Infrastructure\Repository\IRepository\ICategoryRepository.cs"
New-Item -ItemType File -Path ".\Bulky.Infrastructure\Repository\CategoryRepository.cs"

Add-GitCommit -p_strCommitMessage "ICategoryRepository and CategoryRepository added"
Add-GitCommit -p_strCommitMessage "Updated CategoryController to use CategoryRepository"
Add-GitCommit -p_strCommitMessage "Fixed Async Issue2" 5:30:16

New-Item -ItemType File -Path ".\Bulky.Infrastructure\Repository\IRepository\IUnitOfWork.cs"
New-Item -ItemType File -Path ".\Bulky.Infrastructure\Repository\UnitOfWork.cs"
Add-LineToFile -p_strFilePath .\BulkyWeb\Program.cs -p_strLineToFind "// Add services to the container." -p_strLineToAdd "`r`nbuilder.Services.AddScoped<IUnitOfWork, UnitOfWork>();"
Add-GitCommit -p_strCommitMessage "UnitOfWork Working" 5:30:16

# Add areas
cd $strProjectName
dotnet aspnet-codegenerator area "Admin"
dotnet aspnet-codegenerator area "Customer"
cd..

# Move HomeController to Customer Area
# Move Home Views to Customer Area
# Copy Shared Views to Customer Area

Add-GitCommit -p_strCommitMessage "Customer Area Working3" 5:44:25

# Update _Layout.cshtml to included Area parameters

Add-GitCommit -p_strCommitMessage "Customer & Admin Areas Working5" 5:45:30

# Add a dropdown menu from https://getbootstrap.com

Add-GitCommit -p_strCommitMessage "Home Page Menu Updated" 5:49:00

# Product CRUD
New-Item -ItemType File -Path ".\Bulky.Domain\Models\Product.cs"

# ----------------------------

# EF Migrations for Visual Studio
Update-Database -Migration: 0  # Reset

Add-Migration InitialCreate    # Start
Update-Database                # Apply

Add-Migration AddCategoryToDb  # Add Category
Update-Database                # Apply

# ----------------------------

# EF Migrations for Visual Studio Code

# Reset
dotnet ef migrations remove --project $dbContextProjectPath --startup-project $strProjectFilePath
dotnet ef database drop --project $dbContextProjectPath --startup-project $strProjectFilePath

# Start
dotnet ef migrations add InitialCreate --project $dbContextProjectPath --startup-project $strProjectFilePath
dotnet ef database update --project $dbContextProjectPath --startup-project $strProjectFilePath

# Add Migration
dotnet ef migrations add "AddProductToDb" --project $dbContextProjectPath --startup-project $strProjectFilePath
dotnet ef database update --project $dbContextProjectPath --startup-project $strProjectFilePath

Add-GitCommit -p_strCommitMessage "Product Table Created with EF" 5:54:42

## Implement Product Repository
## Configure Product Repository in UnitOfWork
Add-GitCommit -p_strCommitMessage "Product Repo & UnitOfWork Done" 5:59:07

## Create Product Controller & Action Methods *
## Create Views for CRUD Operations *
## Add Client Side & Server Side Validation *
## Add menu item for Product in _Layout.cshtml
Add-GitCommit -p_strCommitMessage "Product CRUD Working" 6:08:45

## Create forign key from product to category
dotnet ef migrations add "AddFKFromProductToCategory" --project $dbContextProjectPath --startup-project $strProjectFilePath
dotnet ef database update --project $dbContextProjectPath --startup-project $strProjectFilePath
Add-GitCommit -p_strCommitMessage "Product/Category Relationship" 6:14:36

## Add ImageUrl field to Product table and DBContext
dotnet ef migrations add "addImageUrlToProduct" --project $dbContextProjectPath --startup-project $strProjectFilePath
# dotnet ef migrations remove --project $dbContextProjectPath --startup-project $strProjectFilePath
dotnet ef database update --project $dbContextProjectPath --startup-project $strProjectFilePath
Add-GitCommit -p_strCommitMessage "addImageUrlToProduct" 6:18:00

## Add SelectListItem to ProductController (Admin Area)
## Add Category Select list to Product Create form
Add-GitCommit -p_strCommitMessage "addCategoryToProductCreateForm" 6:25:00

# ProductVM:
Install-Package -p_strProjectFilePath ".\Bulky.Domain\Bulky.Domain.csproj" -p_strPackageName "Microsoft.AspNetCore.Mvc"
## Create a ProductVM Model to hold the CategoryList and the Product model together.
## Use the ProductVM model on the Product Create form
## Create new ProductVM instance on the Create IActionResult method
Add-GitCommit -p_strCommitMessage "Use ProductVM on Product Create form" 6:35:00

# ProductVM:
## Added "@using Bulky.Domain.Models.ViewModels" to _ViewImports.cshtml
## Added "[ValidateNever]" attribute to Product.cs Model for CategoryId and ImageUrl
## Added "using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;" to Product.cs Model
## Updated ProductController Post to work with the ViewModel (added error handling)
Add-GitCommit -p_strCommitMessage "Use ProductVM on Product Create form" 6:42:00

# ----------------------------

# Init
. .\z_BuildMe\BuildMe2.ps1

# Build
dotnet build .\$strProjectName

dotnet build ".\$strProjectName.sln"

# Rebuild
dotnet build --no-incremental .\$strProjectName

# Run
dotnet run --project $strProjectFilePath

# Watch Run 
dotnet watch run --project $strProjectFilePath --launch-profile https
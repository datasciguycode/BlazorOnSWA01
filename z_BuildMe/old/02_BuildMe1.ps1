#  MVC Application
# DotNetMastery - Introduction to ASP.NET Core MVC (.NET 8)
# https://www.youtube.com/watch?v=AopeJjkcRvU


# Init *
. .\z_BuildMe\BuildMe2.ps1

# Create *
dotnet new mvc -n $strProjectName

# Add Category Model (Human: add properties) *
New-Item -Path "$strProjectFolder\Models" -ItemType "file" -Name "Category2.cs"

# Add EF Core *
Install-Package -p_strProjectFilePath $strProjectFilePath -p_strPackageName "Microsoft.EntityFrameworkCore"
Install-Package -p_strProjectFilePath $strProjectFilePath -p_strPackageName "Microsoft.EntityFrameworkCore.SqlServer"
Install-Package -p_strProjectFilePath $strProjectFilePath -p_strPackageName "Microsoft.EntityFrameworkCore.Tools"

# Add Dev Connection *
Add-Connection -p_strConnection $strConnection -p_strFilePath "$strProjectFolder\appsettings.Development.json"

# Add Folder (Human: add ApplicationDbContext code) *
New-Item -Path "$strProjectFolder\Data" -ItemType "directory"
New-Item -Path "$strProjectFolder\Data" -ItemType "file" -Name "ApplicationDbContext.cs"

# Add DbContext Ref to Program.cs
$strLineToFind = "// Add services to the container."
$strLineToAdd = @"
builder.Services.AddDbContext<${strDbName}DbContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
"@
Add-LineToFile -p_strFilePath "$strProjectFolder\Program.cs" -p_strLineToFind $strLineToFind -p_strLineToAdd $strLineToAdd -p_bBlankLineBelow $true -p_bBlankLineAbove $true

#  Add EF Usings to Program.cs
$strTextToAdd = @"
using Bulky.Web.Data;
using Microsoft.EntityFrameworkCore;`r`n
"@
Add-TextToTopOfFile -p_strFilePath "$strProjectFolder\Program.cs" -p_strTextToAdd $strTextToAdd

# Create Datbase with Package Manager Console
dotnet ef database update --project $strProjectFilePath

#  Add Category table to DbContext
$strFilePath = "$strProjectFolder\Data\ApplicationDBContext.cs"
$strLineToAdd = "`r`n`tpublic DbSet<Category> Categories { get; set; }"
Add-LineToFile -p_strFilePath $strFilePath -p_strLineToFind "// Models" -p_strLineToAdd $strLineToAdd

# Add using Bulky.Web.Models to ApplicationDbContext.cs
Add-TextToTopOfFile -p_strFilePath $strFilePath -p_strTextToAdd "using Bulky.Web.Models;"

# Add Category table to db
dotnet ef migrations add "AddCategoryTableToDatabase" --project $strProjectFilePath
dotnet ef database update --project $strProjectFilePath

## Human:  Add Category controller
## Human:  Add Index view
## Human:  Add SeedCategoryTable in ContextDb

# Update db with seed data
dotnet ef migrations add "SeedCategoryTable" --project $strProjectFilePath
dotnet ef database update --project $strProjectFilePath

## Human:  Add "Category List" to Index view
## Human:  Add styling from http://bootswatch.com and http://icons.getbootstrap.com to layout page
## Human:  Add "Create Category" view and controller

## Human:  Add _ValidationScriptsPartial to Create Category view
## Human:  Add CRUD
## Human:  Add Toastr

Add-GitCommit -p_strCommitMessage "'Success' msgs working."
# Toastr:  https://codeseven.github.io/toastr/
Add-GitCommit -p_strCommitMessage "Toaster working."

# ----------------------------

# MVC and Blazor Project can app can contain razor pages.
# Can build a pure razor page app.
# Razor pages handle the model and controller in the same file.
# A Blazor project implements razor pages that combine C# with html & css.
# Blazor WASM users client side razor pages that combine C# with html & css.

# Add New Razor Pages Project
dotnet new webapp -n $strProjectName
Add-GitCommit -p_strCommitMessage "New Razor Pages Project"

# Add Models Folder
New-Item -Path "$strProjectFolder\Models" -ItemType "directory"

# Add Category Model
New-Item -Path "$strProjectFolder\Models" -ItemType "file" -Name "Category.cs"

# Add Category folder
New-Item -Path "$strProjectFolder\Pages\Categories" -ItemType "directory"

# Add Category Razor Page
New-Item -Path "$strProjectFolder\Pages\Categories" -ItemType "file" -Name "Category.cshtml"
New-Item -Path "$strProjectFolder\Pages\Categories" -ItemType "file" -Name "Category.cshtml.cs"

# Add Data folder
New-Item -Path "$strProjectFolder\Data" -ItemType "directory"

# Add EF
Install-Package -p_strProjectFilePath $strProjectFilePath -p_strPackageName "Microsoft.EntityFrameworkCore.SqlServer"

# Add db ref and EF usings to Program.cs

03:52:17
04:02:57
# ----------------------------

# Init
. .\z_BuildMe\BuildMe2.ps1

# Build
dotnet build .\$strProjectName

# Rebuild
dotnet build --no-incremental .\$strProjectName

# Run
dotnet run --project $strProjectFilePath

# Watch Run 
dotnet watch run --project $strProjectFilePath --launch-profile https

# Git
Initialize-Git
# Serverless ASP.NET Core Web API with AWS Lambda | Mukesh Murugan | https://www.youtube.com/watch?v=VKGzlXLmFmg

# Install Amazon.Lambda.Tools (if needed) *
# dotnet tool install --global Amazon.Lambda.Tools

# Init *
. .\z_BuildMe\BuildMe2.ps1

# Create Web API *
dotnet new webapi -n $strProjectName
dotnet new sln -n $strProjectName -o .\$strProjectName
dotnet sln .\$strProjectName\$strProjectName.sln add .\$strProjectName\$strProjectName.csproj

## Human:  Move z_BuildMe to project folder and open project in VS Code

# Add Connection strings to appsettings files
Add-Connections -p_strConnection $strConnection -p_strProjectFolder $strProjectFolder

#  Install EF
Install-EntityFramework -p_AddModels $true -p_strProjectFilePath $strProjectFilePath -p_strOutputFolder "Models"

# Add Usings to Program.cs
$strLineToFind = "var builder = WebApplication.CreateBuilder(args);"
$strLineToAdd = @"
using $strProjectName.Models;
using Microsoft.EntityFrameworkCore;
"@
Add-LineToFile -p_strFilePath "$strProjectFolder\Program.cs" -p_strLineToFind $strLineToFind -p_strLineToAdd $strLineToAdd -p_bBlankLineBelow $true -p_bPutLineOnTop $true

# Add DbContext Ref to Program.cs
$strLineToFind = "// Add services to the container."
$strLineToAdd = @"
builder.Services.AddDbContext<${strDbName}Context>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
"@
Add-LineToFile -p_strFilePath "$strProjectFolder\Program.cs" -p_strLineToFind $strLineToFind -p_strLineToAdd $strLineToAdd -p_bBlankLineBelow $false -p_bBlankLineAbove $true

# Add Controllers
Add-ControllersByModel

# Git
Initialize-Git


dotnet add package Microsoft.EntityFrameworkCore.InMemory

# ----------------------------------------------------------------------------------------------------------------------------

# Add package *
Install-Package -p_strProjectFilePath "./$strProjectName.csproj" -p_strPackageName "Amazon.Lambda.AspNetCoreServer.Hosting"

# Add Service Ref
$strLineToFind = "// Add services to the container."
$strLineToAdd = "builder.Services.AddAWSLambdaHosting(LambdaEventSource.HttpApi);"
Add-LineToFile -p_strFilePath ".\Program.cs" -p_strLineToFind $strLineToFind -p_strLineToAdd $strLineToAdd -p_bBlankLineAbove $true -p_bBlankLineBelow $true

# Add Minimal API
$strLineToFind = "app.Run();"
$strLineToAdd = @"
app.MapGet("/", () => "Hello from AWS Lambda!");
"@
Add-LineToFile -p_strFilePath ".\Program.cs" -p_strLineToFind $strLineToFind -p_strLineToAdd $strLineToAdd -p_bPutLineOnTop $true -p_bBlankLineBelow $true


# Grant Permissions
<#
    AWSLambda_FullAccess	
    iamAttachRolePolicy	
    iamCreateRole	
    iamListPolicies	
    lambdaCreateFunction	
    lambdaGetFunctionConfiguration
#>

# Add AWS Defaults File
Add-AwsLamdaToolsDefaultsFile  # make edits as needed

# Human:  Manually Add Models and Controllers


## Human Add Amazon Secrets Manager script to Program.cs

# Add Amazon Secrets Manager Package
Install-Package -p_strProjectFilePath ".\$strProjectName.csproj" -p_strPackageName "AWSSDK.SecretsManager"

# Add Newtonsoft.Json Package
Install-Package -p_strProjectFilePath ".\$strProjectName.csproj" -p_strPackageName "Newtonsoft.Json"

# Add Refs
$strLineToFind = "var builder = WebApplication.CreateBuilder(args);"
$strLineToAdd = @"
using Amazon.SecretsManager; // new
using Amazon.SecretsManager.Model;  //new
using Newtonsoft.Json;  //new
using SimpleApi2.Models;   // new
using Microsoft.EntityFrameworkCore;    // new
"@
Add-LineToFile -p_strFilePath ".\Program.cs" -p_strLineToFind $strLineToFind -p_strLineToAdd $strLineToAdd -p_bBlankLineAbove $false -p_bBlankLineBelow $true -p_bPutLineOnTop $true

# Add Rep/Svc Refs
Add-GenericRepoAndServiceRef -p_strProjectFolder $strProjectFolder

# Deploy to AWS
dotnet lambda deploy-function

# References
<#
    https://jdowbjllz5kc7ltgny2jin2ppm0msoeo.lambda-url.us-west-2.on.aws/
    arn:aws:lambda:us-west-2:654654327749:function:simpleapi
#>

# ---------------------------------------------------------------------------

# Build Solution
dotnet build

# Run
dotnet run --project $strProjectFilePath --launch-profile https

# Watch Run 
dotnet watch run --project $strProjectFilePath --launch-profile https

# Debug
dotnet run --configuration Debug --project $strProjectFilePath --launch-profile https


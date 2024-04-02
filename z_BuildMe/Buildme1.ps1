<#
    Build and deploy .NET 8 Blazor WASM apps with serverless APIs using Azure Static Web Apps
    https://techcommunity.microsoft.com/t5/apps-on-azure-blog/build-and-deploy-net-8-blazor-wasm-apps-with-serverless-apis/ba-p/3988412

    Goal:  Automate the creation and deployment of a serverless .NET 8 Blazor WASM app to Azure Static Web Apps and Azure Functions Web API.

    Steps:   
    1.  Create and deploy a new Blazor WebAssembly project.
    2.  Create and deploy a new Azure Functions project with a Web API.
    3.  Connect the Blazor WebAssembly project to the Azure Functions Web API.
#>

# Create project *
    dotnet new sln -n BlazorOnSWA
    dotnet new blazorwasm -n Client
    dotnet sln add Client/Client.csproj

# Init *
. .\z_BuildMe\BuildMe2.ps1    

# Git *
Initialize-Git

# Create GitHub repository
    Create a new repository on GitHub
    git init
    git add .
    git commit -m "Initial commit"
    git branch -M main
    git remote add origin


# ------------------------------------------

dotnet run --project .\Client\Client.csproj


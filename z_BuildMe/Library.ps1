# Library.ps1

# ---------------------------------------------------------------------------

function Add-TextToTopOfFile {
    param
    (
        [string]$p_strFilePath,
        [string]$p_strText
    )

    $content = Get-Content $p_strFilePath
    $newContent = $p_strText + "`r`n" + ($content -join "`r`n")
    $newContent | Set-Content $p_strFilePath
}

# ---------------------------------------------------------------------------

function Clear-AllExceptScripts {
    Get-ChildItem -Path "." -Recurse | Where-Object { $_.FullName -notlike "*\BuildApi.ps1*" -and $_.FullName -notlike "*\Library.ps1*" } | Remove-Item -Recurse -Force
}

# ---------------------------------------------------------------------------

function Update-TextInFile {
    param
    (
        $p_strFilePath
        , $p_strOldText
        , $p_strNewText
    )

    $content = Get-Content $p_strFilePath
    $content.Replace($p_strOldText, $p_strNewText) | Set-Content $p_strFilePath
}

# ---------------------------------------------------------------------------

function Install-PackageIfNotExists {
    param 
    (
        $p_strProjectFilePath
        , $p_strPackageName
    )

    Write-Host "Installing package $p_strPackageName"
    Write-Host "Project file path: $p_strProjectFilePath"

    $installedPackages = dotnet list $p_strProjectFilePath package | Out-String
    if (($installedPackages -match $p_strPackageName)) {
        Write-Host "Package $p_strPackageName already installed."
    }
    else {
        Write-Host "Installing $p_strPackageName."
        dotnet add $p_strProjectFilePath package $p_strPackageName
    }
}

# ---------------------------------------------------------------------------

function Get-DefaultConnection {
    param (
        [string]$p_strJsonFilePath
    )

    # Read the JSON file and convert it to a PowerShell object
    $json = Get-Content -Path $p_strJsonFilePath | ConvertFrom-Json

    # Return the DefaultConnection string
    return $json.ConnectionStrings.DefaultConnection
}

# ---------------------------------------------------------------------------

function Get-DbTableNames {
    param (
        [string]$p_strConnectionString
    )

    # Import the namespace
    Add-Type -AssemblyName System.Data

    # Create the SQL connection
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $p_strConnectionString

    # Open the connection
    $connection.Open()

    # Define the query to get table names
    $query = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' AND NOT TABLE_NAME LIKE 'sys%'"

    # Create the SQL command
    $command = $connection.CreateCommand()
    $command.CommandText = $query

    # Execute the command
    $reader = $command.ExecuteReader()

    # Initialize an array to hold table names
    $tableNames = @()

    # Loop through the result and add the table names to the array
    while ($reader.Read()) {
        $tableNames += $reader["TABLE_NAME"]
    }

    # Close the connection
    $connection.Close()

    # Return the array of table names
    return $tableNames
}

# ---------------------------------------------------------------------------

function Get-DbFieldTable {
    param (
        [string]$p_strConnectionString,
        [string]$p_strTableName
    )

    # Import the namespace
    Add-Type -AssemblyName System.Data

    # Get Connection
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $p_strConnectionString
    $connection.Open()

    # Get table field names and data types
    $query = @"
SELECT COLUMN_NAME
,CASE
    WHEN DATA_TYPE = 'datetime' or DATA_TYPE = 'date' THEN 'Date'
    WHEN DATA_TYPE = 'int' or DATA_TYPE = 'decimal' THEN 'Number'
    ELSE 'Text'
END AS DATATYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '$p_strTableName'
"@

    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $reader = $command.ExecuteReader()
    $fieldTable = @()

    while ($reader.Read()) {
        $obj = New-Object PSObject -Property @{
            Name = $reader["COLUMN_NAME"]
            DataType = $reader["DATATYPE"]
        }
        $fieldTable += $obj
    }

    # Close the connection
    $connection.Close()

    return $fieldTable
}
# ---------------------------------------------------------------------------

function Add-LineToFile {
    param (
        [string]$p_strFilePath,
        [string]$p_strLineToFind,
        [string]$p_strLineToAdd,
        [bool]$p_bPutLineOnTop = $false
    )

    if (Test-Path $p_strFilePath) {
        $arrFileContent = Get-Content $p_strFilePath
        $arrNewFileContent = @()
        $bFoundLine = $false

        foreach ($strLine in $arrFileContent) {
            if ($strLine.Trim() -eq $p_strLineToFind.Trim()) {
                $bFoundLine = $true
                if ($p_bPutLineOnTop) {
                    $arrNewFileContent += $p_strLineToAdd
                }
                $arrNewFileContent += $strLine
                if (-not $p_bPutLineOnTop) {
                    $arrNewFileContent += $p_strLineToAdd
                }
            } else {
                $arrNewFileContent += $strLine
            }
        }

        $arrNewFileContent | Out-File $p_strFilePath
        Write-Output "Found line: $bFoundLine"

    } else {
        Write-Output "File not found."
    }
}

# ---------------------------------------------------------------------------

function Compress-DotNetProject {

    param(
        [string]$sourcePath,        
        [string]$destinationPath
    )

    # Get all the files in the source path, excluding bin and obj directories
    $files = Get-ChildItem -Path $sourcePath -Recurse | Where-Object { $_.FullName -notmatch "\\bin\\" -and $_.FullName -notmatch "\\obj\\" }

    # Create a zip archive from the files
    Compress-Archive -Path $files.FullName -DestinationPath $destinationPath
}

# ---------------------------------------------------------------------------
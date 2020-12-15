# Check conda is installed and available in PATH
if (-not (Get-Command conda)) {
    Write-Host -ForegroundColor Red "conda installation not detected, aborting."
    Exit 1
}
else {
    Write-Host -ForegroundColor Green "conda installation detected."
}

# Set the working directory
$workingDir = Split-Path $PSScriptRoot -Parent

# Check we are in the right directory
if ((Split-Path $workingDir -Leaf) -ne "retracted_papers_in_swissprot") {
    Write-Host -ForegroundColor Red "Expected a directory named 'retracted_papers_in_swissprot', aborting installation."
    Exit 1
}

# Create logs directory
if (Test-Path "$workingDir/logs") {
    Write-Host "Directory 'logs' already exists, skipping creation."
}
else {
    Write-Host "Creating a logs folder in $workingDir..."
    New-Item -ItemType "directory" -Path "$workingDir/logs"
}

# Create conda environment, unless it already exists
if (conda info --envs | Select-String "^retracted_papers_in_swissprot ") {
    Write-Host "Conda environment 'retracted_papers_in_swissprot' already exists, skipping environment creation."
}
else {
    Write-Host "Creating conda environment..."
    conda env create --file "$workingDir/environment.yml"
}

Write-Host -ForegroundColor Green "Installation complete."
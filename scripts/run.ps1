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
Set-Location $workingDir

# Check we are in the right directory
if ((Split-Path $workingDir -Leaf) -ne "retracted_papers_in_swissprot") {
    Write-Host -ForegroundColor Red "Expected a directory named 'retracted_papers_in_swissprot', aborting installation."
    Exit 1
}

# Activate conda environment, if it exists
if (conda info --envs | Select-String "^retracted_papers_in_swissprot ") {
    Write-Host "Activating conda environment 'retracted_papers_in_swissprot'..."
    conda activate retracted_papers_in_swissprot
}
else {
    Write-Host -ForegroundColor Red " conda environment 'retracted_papers_in_swissprot' not found, aborting."
    Exit 1
}

# Run the notebook
$timestamp = Get-Date -UFormat "%Y%m%d"
$reportFile = "uncurated_retractions_$timestamp.tsv"
$logFile = "./logs/log_$timestamp.ipynb"

Write-Host "Executing notebook, please wait..."
papermill retracted_papers_in_swissprot.ipynb $logFile -p report_file $reportFile

# Check the notebook executed successfully
if ($?) {
    Write-Host -ForegroundColor Green "Analysis complete."
    Write-Host "Results are available in the report file: $reportFile"
}
else {
    Write-Host -ForegroundColor Red "Notebook failed to execute successfully, please see $logFile for error report."
}

# Generate html log
jupyter nbconvert --to html $logFile

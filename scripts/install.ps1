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
if (conda info --envs | Select-String "^retracted_papers_in_swissprot") {
    Write-Host "Conda environment 'retracted_papers_in_swissprot' already exists, skipping environment creation."
}
else {
    Write-Host "Creating conda environment..."
    conda env create --file "$workingDir/environment.yml"
}

# The hack below removes black cache errors when executing the notebook, by
# running black once from the command line
conda activate retracted_papers_in_swissprot
$tempFile = "./temp.py"
New-Item -Path $tempFile -ItemType File -Value "x=1" | Out-Null
black $tempFile -q
Remove-Item $tempFile

# Create shortcuts for Windows
if ($Env:OS -eq "Windows_NT") {
    Write-Host "Creating shortcuts..."

    $WShell = New-Object -comObject WScript.Shell
    $pwsh = (Get-Command powershell).Source

    # Create shortcut for installer script
    $installShortcut = $WShell.CreateShortcut("$workingDir\install.ps1 - Shortcut.lnk")
    $installShortcut.TargetPath = $pwsh
    $installShortcut.Arguments = "-ExecutionPolicy Bypass -NoExit .\scripts\install.ps1"
    $installShortcut.Save()

    # Create shortcut for run script
    $runShortcut = $WShell.CreateShortcut("$workingDir\run.ps1 - Shortcut.lnk")
    $runShortcut.TargetPath = $pwsh
    $runShortcut.Arguments = "-ExecutionPolicy Bypass -NoExit .\scripts\run.ps1"
    $runShortcut.Save()

    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($WShell) | Out-Null
}

Write-Host -ForegroundColor Green "Installation complete."
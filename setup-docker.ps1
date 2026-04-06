# PowerShell Script to Start Docker Engine in WSL2 Ubuntu
# Use this when you start development to ensure the Docker daemon is running.

Write-Host "Ensuring Docker is running in WSL2 (Ubuntu)..." -ForegroundColor Cyan

# Start the WSL distribution if it's not running
wsl -d Ubuntu sh -c "echo 'Checking WSL responsiveness...'"

# Check if Docker service is running
$dockerStatus = wsl -u root -d Ubuntu sh -c "service docker status"
if ($dockerStatus -like "*is not running*") {
    Write-Host "Docker is not running. Starting Docker service..." -ForegroundColor Yellow
    wsl -u root -d Ubuntu sh -c "service docker start"
    Start-Sleep -Seconds 5
} else {
    Write-Host "Docker is already running." -ForegroundColor Green
}

# Verify with docker version
$version = wsl -u root -d Ubuntu sh -c "docker version --format '{{.Server.Version}}'"
if ($version) {
    Write-Host "Docker Engine v$version is ready." -ForegroundColor Green
} else {
    Write-Error "Failed to start Docker Engine."
}

Write-Host "Setup complete. You can now use 'wsl docker' to run commands." -ForegroundColor Cyan

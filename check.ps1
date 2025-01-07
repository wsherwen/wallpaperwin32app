$paths = @(
    "$env:systemdrive\Background\Desktop.jpg",
    "$env:systemdrive\Background\Lockscreen.jpg"
)

if ($paths | Where-Object { Test-Path $_ }) {
    Write-Host "Background Images Found"
    exit 0
}

else {
    Write-Host "Background Images Not Found"
    exit 1
}
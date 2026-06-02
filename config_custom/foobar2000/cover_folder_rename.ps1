# Recursively find files named "cover" (with any extension)
# and rename them to "folder" while keeping the extension.

Get-ChildItem -Path . -Recurse -File | Where-Object {
    $_.BaseName -eq 'cover'
} | ForEach-Object {
    $newName = "folder$($_.Extension)"

    # Avoid errors if a file with the target name already exists
    if (-not (Test-Path (Join-Path $_.DirectoryName $newName))) {
        Rename-Item -LiteralPath $_.FullName -NewName $newName
        Write-Host "Renamed: $($_.Name) -> $newName"
    }
    else {
        Write-Warning "Skipped '$($_.FullName)' because '$newName' already exists."
    }
}

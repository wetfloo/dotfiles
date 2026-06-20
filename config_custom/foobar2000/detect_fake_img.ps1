param(
    [string]$Path = "."
)

Get-ChildItem -Path $Path -Recurse -File -Include *.png,*.jpg,*.jpeg |
ForEach-Object {

    try {
        $fs = [System.IO.File]::OpenRead($_.FullName)

        try {
            $header = New-Object byte[] 8
            $read = $fs.Read($header, 0, 8)

            if ($read -lt 3) {
                return
            }

            $actualType = $null

            if (
                $read -ge 8 -and
                $header[0] -eq 0x89 -and
                $header[1] -eq 0x50 -and
                $header[2] -eq 0x4E -and
                $header[3] -eq 0x47 -and
                $header[4] -eq 0x0D -and
                $header[5] -eq 0x0A -and
                $header[6] -eq 0x1A -and
                $header[7] -eq 0x0A
            ) {
                $actualType = "png"
            }
            elseif (
                $header[0] -eq 0xFF -and
                $header[1] -eq 0xD8 -and
                $header[2] -eq 0xFF
            ) {
                $actualType = "jpg"
            }

            if ($actualType) {
                $extension = $_.Extension.TrimStart('.').ToLower()

                if (
                    (($extension -eq "png") -and ($actualType -eq "jpg")) -or
                    (($extension -in @("jpg", "jpeg")) -and ($actualType -eq "png"))
                ) {
                    $_.FullName
                }
            }
        }
        finally {
            $fs.Dispose()
        }
    }
    catch {
        Write-Warning "Failed to read: $($_.FullName)"
    }
}

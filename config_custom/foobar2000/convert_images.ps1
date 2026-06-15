# Ensure the standard .NET Drawing assembly is loaded
Add-Type -AssemblyName System.Drawing

# Define the root directory you want to scan (Change this to your target path)
$TargetDirectory = "."

# Locate the specific codec for JPEG images
$ImageCodecs = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()
$JpegCodec = $ImageCodecs | Where-Object { $_.MimeType -eq "image/jpeg" }

# Set up encoder parameters to force good enough quality (90)
$EncoderParameters = New-Object System.Drawing.Imaging.EncoderParameters(1)
$EncoderParameters.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 90)

# Recursively fetch all PNG files
$PngFiles = Get-ChildItem -Path $TargetDirectory -Filter *.png -Recurse

Write-Host "Found $($PngFiles.Count) PNG files to convert and clean up." -ForegroundColor Cyan

foreach ($File in $PngFiles) {
    $PngPath = $File.FullName
    $JpgPath = [System.IO.Path]::ChangeExtension($PngPath, ".jpg")

    try {
        # Load and convert the image
        $Bitmap = New-Object System.Drawing.Bitmap($PngPath)
        $Bitmap.Save($JpgPath, $JpegCodec, $EncoderParameters)

        # CRITICAL: Dispose the bitmap object immediately to release the file lock
        $Bitmap.Dispose()

        Write-Host "Successfully converted: $($File.Name) -> $([System.IO.Path]::GetFileName($JpgPath))" -ForegroundColor Green

        # Clean up: Delete the original PNG file now that the JPG is safe
        Remove-Item -Path $PngPath -Force
        Write-Host "Deleted original: $($File.Name)" -ForegroundColor Gray
    }
    catch {
        Write-Error "Failed to process file: $PngPath. Original file was NOT deleted. Reason: $_"
        # Ensure the file handle is closed if something goes wrong midway so it doesn't stay locked
        if ($Bitmap) { $Bitmap.Dispose() }
    }
}

Write-Host "Conversion and cleanup process complete!" -ForegroundColor Cyan

# Specify the port you want to use
$port = 8080

# Start HTTP listener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()

Write-Host "Static file server running at http://localhost:$port/"
Write-Host "Press Ctrl+C to stop the server."

# Function to get MIME type based on file extension (you can extend this)
function Get-ContentType {
    param([string]$extension)

    switch ($extension.ToLower()) {
        ".html"  { "text/html" }
        ".htm"   { "text/html" }
        ".css"   { "text/css" }
        ".txt"   { "text/txt" }
        ".js"    { "application/javascript" }
        ".json"  { "application/json" }
        ".jpg"   { "image/jpeg" }
        ".jpeg"  { "image/jpeg" }
        ".png"   { "image/png" }
        ".gif"   { "image/gif" }
        ".ico"   { "image/x-icon" }
        default  { "application/octet-stream" }
    }
}

try {
    while ($true) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        # Construct the full file path based on the request URL
        $filePath = Join-Path (Get-Location) $request.Url.LocalPath.TrimStart('/')
        
        if (Test-Path $filePath -PathType Leaf) {
            # Read the file content
            $fileBytes = [System.IO.File]::ReadAllBytes($filePath)

            # Set content type based on file extension (basic MIME type detection)
            $extension = [System.IO.Path]::GetExtension($filePath)
            $contentType = Get-ContentType $extension

            $response.ContentType = $contentType
            $response.ContentLength64 = $fileBytes.Length

            # Write file content to response stream
            $response.OutputStream.Write($fileBytes, 0, $fileBytes.Length)
        } else {
            # File not found
            $response.StatusCode = 404
        }

        # Close the response stream
        $response.Close()
    }
} finally {
    # Stop the listener when script is terminated
    $listener.Stop()
}
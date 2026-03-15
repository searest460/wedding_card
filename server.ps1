# Simple robust server
$port = 8089
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Listening on http://localhost:$port"

while ($true) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $path = $request.Url.LocalPath.TrimStart('/')
        if ($path -eq '') { $path = 'index.html' }
        $fullPath = Join-Path $PWD $path
        
        if (Test-Path $fullPath -PathType Leaf) {
            $extension = [System.IO.Path]::GetExtension($fullPath)
            $contentType = switch ($extension) {
                '.html' { 'text/html' }
                '.js'   { 'application/javascript' }
                '.css'  { 'text/css' }
                '.png'  { 'image/png' }
                '.jpg'  { 'image/jpeg' }
                '.svg'  { 'image/svg+xml' }
                '.mp4'  { 'video/mp4' }
                default { 'application/octet-stream' }
            }
            $response.ContentType = $contentType
            $buffer = [System.IO.File]::ReadAllBytes($fullPath)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        } else {
            $response.StatusCode = 404
        }
        $response.Close()
    } catch {
        Write-Host "Request error: $_"
    }
}
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add('http://localhost:8081/')
$listener.Start()
Write-Host "Listening on http://localhost:8081"
try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        $path = $request.Url.LocalPath.TrimStart('/')
        if ($path -eq '') { $path = 'index.html' }
        $fullPath = Join-Path $PWD $path
        
        Write-Host "Requested: $path"

        if (Test-Path $fullPath -PathType Leaf) {
            $content = [System.IO.File]::ReadAllBytes($fullPath)
            $response.ContentLength64 = $content.Length
            
            if ($path.EndsWith('.js')) { $response.ContentType = 'application/javascript' }
            elseif ($path.EndsWith('.css')) { $response.ContentType = 'text/css' }
            elseif ($path.EndsWith('.html')) { $response.ContentType = 'text/html' }
            elseif ($path.EndsWith('.png')) { $response.ContentType = 'image/png' }
            elseif ($path.EndsWith('.jpg') -or $path.EndsWith('.jpeg')) { $response.ContentType = 'image/jpeg' }
            
            $response.OutputStream.Write($content, 0, $content.Length)
            Write-Host "Served: $fullPath"
        } else {
            $response.StatusCode = 404
            Write-Host "Not Found: $fullPath"
        }
        $response.Close()
    }
}
catch {
    Write-Host "Error: $_"
}
finally {
    $listener.Stop()
}

# Ultra-robust setup script (No BOM, Escaped Newlines)
$root = "c:\Users\Rahuldev\Downloads\theatre_demo.thedigitalyes.com"
$jsPath = "$root\assets\index-BBIwAgSn.js"
$cssPath = "$root\assets\index-bYuRLTYZ.css"
$htmlPath = "$root\index.html"

Write-Host "Loading original files..."
$c = [System.IO.File]::ReadAllText("$root\original_clean.js", [System.Text.Encoding]::UTF8)
$translations = [System.IO.File]::ReadAllText("$root\translations.json", [System.Text.Encoding]::UTF8)
$transObj = $translations | ConvertFrom-Json
$en = $transObj.en

Write-Host "Applying replacements..."

# Helper to escape strings for JS double quotes
function Escape-JSString($s) {
    if ($null -eq $s) { return "" }
    return $s.ToString().Replace('\', '\\').Replace('"', '\"').Replace("`n", '\n').Replace("`r", '')
}

# Names
$c = $c.Replace('Matthias', 'Rahul')
$c = $c.Replace('Flora', 'Dhanya')
$c = $c.Replace('Sofia', 'Dhanya')
$c = $c.Replace('Sofía', 'Dhanya')
$c = $c.Replace('Sam', 'Rahul')

# Dates & Venue
$c = $c.Replace('September 10, 2027', 'September 13, 2026')
$c = $c.Replace('Villa Medicea di Artimino', (Escape-JSString $en.'transport.description'))
$c = $c.Replace('Via di Papa Leone X, 28', '')
$c = $c.Replace('Artimino, Florencia', '')
$c = $c.Replace('2026-09-06', '2026-09-13')

# Translations
$c = $c.Replace('s("demo.title")', '"' + (Escape-JSString $en.'intro.invitation') + '"')
$c = $c.Replace('s("demo.buyNow")', '"' + (Escape-JSString $en.'intro.personalMessage') + '"')
$c = $c.Replace('e("dressCode.title")', '"' + (Escape-JSString $en.'dressCode.title') + '"')
$c = $c.Replace('e("dressCode.description")', '"' + (Escape-JSString $en.'dressCode.description') + '"')
$c = $c.Replace('e("dressCode.formal")', '"' + (Escape-JSString $en.'dressCode.formal') + '"')
$c = $c.Replace('e("gifts.title")', '"' + (Escape-JSString $en.'gifts.title') + '"')
$c = $c.Replace('e("gifts.message")', '"' + (Escape-JSString $en.'gifts.message') + '"')
$c = $c.Replace('e("gifts.bankDetails")', '"' + (Escape-JSString $en.'gifts.bankDetails') + '"')
$c = $c.Replace('e("gifts.concept")', '"' + (Escape-JSString $en.'gifts.concept') + '"')
$c = $c.Replace('e("transport.title")', '"' + (Escape-JSString $en.'transport.title') + '"')
$c = $c.Replace('e("transport.description")', '"' + (Escape-JSString $en.'transport.description') + '"')
$c = $c.Replace('e("transport.howToGet")', '"' + (Escape-JSString $en.'transport.howToGet') + '"')
$c = $c.Replace('e("transport.departure")', '"' + (Escape-JSString $en.'transport.departure') + '"')
$c = $c.Replace('e("transport.rsvpNote")', '"' + (Escape-JSString $en.'transport.rsvpNote') + '"')

# Save files using original names, UTF-8 WITHOUT BOM
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllText($jsPath, $c, $Utf8NoBomEncoding)

$html = @"
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Dhanya & Rahul Wedding</title>
  <script type="module" crossorigin src="./assets/index-BBIwAgSn.js"></script>
  <link rel="stylesheet" crossorigin href="./assets/index-bYuRLTYZ.css">
</head>
<body>
  <div id="root"></div>
</body>
</html>
"@
[System.IO.File]::WriteAllText($htmlPath, $html, $Utf8NoBomEncoding)

Write-Host "DONE!"
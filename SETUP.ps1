# Perfection setup script - Final Version
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

# 1. Names - All variations
$c = $c.Replace('Matthias', 'Rahul')
$c = $c.Replace('Flora', 'Dhanya')
$c = $c.Replace('Sofia', 'Dhanya')
$c = $c.Replace('Sofía', 'Dhanya')
$c = $c.Replace('Sam', 'Rahul')
$c = $c.Replace('SAM', 'RAHUL')
$c = $c.Replace('SOFIA', 'DHANYA')

# 2. Dates - Including the scratch card array
$c = $c.Replace('["10","Sept","2027"]', '["13","Sept","2026"]')
$c = $c.Replace('September 10, 2027', 'September 13, 2026')
$c = $c.Replace('2026-09-06', '2026-09-13')
$c = $c.Replace('20260904/20260907', '20260913/20260914')

# 3. Venue - All parts
$c = $c.Replace('Villa Medicea di Artimino', 'Akhil Convention Centre')
$c = $c.Replace('Via di Papa Leone X, 28', 'Shankaramangalam Koyivila Rd')
$c = $c.Replace('Artimino, Florencia', 'Thevalakkara, Kerala')
$c = $c.Replace('Moutiers-Sainte-Marie, France', 'Kollam, Kerala')

# 4. Inject main translations (aggressive replacement of keys)
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

# 5. REMOVALS (Per user request)
# Remove Header Left (FV) and Language Switcher (VV) from main layout
$c = $c.Replace('f.jsxs("main",{className:"bg-white",children:[f.jsx(FV,{}),f.jsx(VV,{}),', 'f.jsxs("main",{className:"bg-white",children:[null,null,')

# Remove Gifts section (V$) from main layout
$c = $c.Replace('f.jsx($$,{}),f.jsx(V$,{}),', 'f.jsx($$,{}),null,')

# 6. RSVP Sections (jV and IV objects)
$c = $c.Replace('thankYou:"Confirm your attendance"', 'thankYou:"' + (Escape-JSString $en.'rsvp.title') + '"')
$c = $c.Replace('thankYouConfirming:"Thank you for confirming"', 'thankYouConfirming:"' + (Escape-JSString $en.'rsvp.title') + '"')
$c = $c.Replace('fullName:"Full name *"', 'fullName:"' + (Escape-JSString $en.'rsvp.fullName') + '"')
$c = $c.Replace('willAttend:"Will you attend?"', 'willAttend:"' + (Escape-JSString $en.'rsvp.willAttend') + '"')
$c = $c.Replace('yes:"I''ll be there!"', 'yes:"' + (Escape-JSString $en.'rsvp.yesButton') + '"')
$c = $c.Replace('no:"Can''t make it"', 'no:"' + (Escape-JSString $en.'rsvp.noButton') + '"')
$c = $c.Replace('guestCount:"Number of guests"', 'guestCount:"' + (Escape-JSString $en.'rsvp.guestCount') + '"')
$c = $c.Replace('dietaryTitle:"Dietary requirements"', 'dietaryTitle:"' + (Escape-JSString $en.'rsvp.dietary') + '"')
$c = $c.Replace('sending:"Sending..."', 'sending:"' + (Escape-JSString $en.'rsvp.sending') + '"')
$c = $c.Replace('send:"Confirm"', 'send:"' + (Escape-JSString $en.'rsvp.send') + '"')

# Save files using UTF-8 WITHOUT BOM
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
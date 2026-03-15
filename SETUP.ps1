# Absolute final perfect setup script
$root = "c:\Users\Rahuldev\Downloads\theatre_demo.thedigitalyes.com"
$jsPath = "$root\assets\index-v2.js"
$cssPath = "$root\assets\index-v2.css"
$htmlPath = "$root\index.html"

Write-Host "[1/4] Loading files..."
$c = [System.IO.File]::ReadAllText("$root\original_clean.js", [System.Text.Encoding]::UTF8)
$css = [System.IO.File]::ReadAllText("$root\assets\index-bYuRLTYZ.css", [System.Text.Encoding]::UTF8)
$translations = [System.IO.File]::ReadAllText("$root\translations.json", [System.Text.Encoding]::UTF8)
$transObj = $translations | ConvertFrom-Json
$en = $transObj.en

Write-Host "[2/4] Mapping translations to JS keys..."

# 1. Couple Names (All variations)
$c = $c -replace 'couple_name_1\)\|\|"[^"]*"', ('couple_name_1)||"Rahul"')
$c = $c -replace 'couple_name_2\)\|\|"[^"]*"', ('couple_name_2)||"Dhanya"')
$c = $c -replace 'children:"Matthias"', 'children:"Rahul"'
$c = $c -replace 'children:"Flora"', 'children:"Dhanya"'
$c = $c -replace 'children:"Sofia"', 'children:"Dhanya"'
$c = $c -replace 'children:"Sofía"', 'children:"Dhanya"'
$c = $c -replace 'children:"Sam"', 'children:"Rahul"'
$c = $c -replace 'children:"SAM"', 'children:"RAHUL"'
$c = $c -replace 'children:"SOFIA"', 'children:"DHANYA"'
$c = $c -replace 'children:"SOF\xCDA"', 'children:"DHANYA"' # Handle encoded characters

# 2. Venue and Dates
$c = $c -replace 'children:"Villa Medicea di Artimino"', ('children:"' + $en.'transport.description' + '"')
$c = $c -replace 'children:"Via di Papa Leone X, 28"', 'children:""'
$c = $c -replace 'children:"Artimino, Florencia"', 'children:""'
$c = $c -replace 'children:"September 10, 2027"', 'children:"September 13, 2026"'
$c = $c.Replace('2026-09-06', '2026-09-13')
$c = $c.Replace('20260904/20260907', '20260913/20260914')

# 3. RSVP Section (jV and IV objects)
$c = $c -replace 'thankYou:"[^"]*"', ('thankYou:"' + $en.'rsvp.title' + '"')
$c = $c -replace 'seeYou:"[^"]*"', ('seeYou:"We''ll see you on September 13 at ' + $en.'transport.description' + '"')
$c = $c -replace 'subtitle:"Confirm your attendance"', ('subtitle:"' + $en.'rsvp.subtitle' + '"')
$c = $c -replace 'fullName:"Full Name"', ('fullName:"' + $en.'rsvp.fullName' + '"')
$c = $c -replace 'email:"Email \(optional\)"', ('email:"' + $en.'rsvp.email' + '"')
$c = $c -replace 'willAttend:"Will you attend\?"', ('willAttend:"' + $en.'rsvp.willAttend' + '"')
$c = $c -replace 'yes:"Yes, I''ll be there!"', ('yes:"' + $en.'rsvp.yesButton' + '"')
$c = $c -replace 'no:"No, I can''t make it"', ('no:"' + $en.'rsvp.noButton' + '"')
$c = $c -replace 'guestCount:"How many guests in total\?"', ('guestCount:"' + $en.'rsvp.guestCount' + '"')
$c = $c -replace 'dietaryTitle:"Your dietary requirements"', ('dietaryTitle:"' + $en.'rsvp.dietary' + '"')
$c = $c -replace 'sending:"Sending\.\.\."', ('sending:"' + $en.'rsvp.sending' + '"')
$c = $c -replace 'send:"Confirm"', ('send:"' + $en.'rsvp.send' + '"')

# 4. Global Name Replacement (Aggressive regex)
$c = $c -replace '\bSofia\b', 'Dhanya'
$c = $c -replace '\bSofía\b', 'Dhanya'
$c = $c -replace '\bSOFIA\b', 'DHANYA'
$c = $c -replace '\bSOFÍA\b', 'DHANYA'
$c = $c -replace '\bSam\b', 'Rahul'
$c = $c -replace '\bSAM\b', 'RAHUL'

Write-Host "[3/4] Injecting main translations (s and e calls)..."
$c = $c.Replace('s("demo.title")', '"' + $en.'intro.invitation' + '"')
$c = $c.Replace('s("demo.buyNow")', '"' + $en.'intro.personalMessage' + '"')
$c = $c.Replace('e("dressCode.title")', '"' + $en.'dressCode.title' + '"')
$c = $c.Replace('e("dressCode.description")', '"' + $en.'dressCode.description' + '"')
$c = $c.Replace('e("dressCode.formal")', '"' + $en.'dressCode.formal' + '"')
$c = $c.Replace('e("gifts.title")', '"' + $en.'gifts.title' + '"')
$c = $c.Replace('e("gifts.message")', '"' + $en.'gifts.message' + '"')
$c = $c.Replace('e("gifts.bankDetails")', '"' + $en.'gifts.bankDetails' + '"')
$c = $c.Replace('e("gifts.concept")', '"' + $en.'gifts.concept' + '"')
$c = $c.Replace('e("transport.title")', '"' + $en.'transport.title' + '"')
$c = $c.Replace('e("transport.description")', '"' + $en.'transport.description' + '"')
$c = $c.Replace('e("transport.howToGet")', '"' + $en.'transport.howToGet' + '"')
$c = $c.Replace('e("transport.departure")', '"' + $en.'transport.departure' + '"')
$c = $c.Replace('e("transport.rsvpNote")', '"' + $en.'transport.rsvpNote' + '"')

Write-Host "[4/4] Saving files..."
[System.IO.File]::WriteAllText($jsPath, $c, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText($cssPath, $css, [System.Text.Encoding]::UTF8)

$html = @"
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Dhanya & Rahul Wedding</title>
  <meta name="description" content="Wedding Invitation | Dhanya & Rahul | September 13, 2026">
  <meta property="og:title" content="Dhanya & Rahul Wedding">
  <script type="module" crossorigin src="/assets/index-v2.js"></script>
  <link rel="stylesheet" crossorigin href="/assets/index-v2.css">
</head>
<body>
  <div id="root"></div>
</body>
</html>
"@
[System.IO.File]::WriteAllText($htmlPath, $html, [System.Text.Encoding]::UTF8)

Write-Host "DONE!"
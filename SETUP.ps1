# Absolute perfection setup script - v4
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

# 1. Names - Extremely Aggressive & Global
# Replace the specific "Sam & Sofía" variations found in the file
$c = $c -replace 'Sam & Sofía', 'Rahul & Dhanya'
$c = $c -replace 'Sam & Sofia', 'Rahul & Dhanya'
$c = $c -replace 'SAM & SOFIA', 'RAHUL & DHANYA'
$c = $c -replace 'Sam & Sof├¡a', 'Rahul & Dhanya'

# Standalone name replacements
$c = $c.Replace('Matthias', 'Rahul')
$c = $c.Replace('Flora', 'Dhanya')
$c = $c.Replace('Sofia', 'Dhanya')
$c = $c.Replace('Sofía', 'Dhanya')
$c = $c.Replace('Sam', 'Rahul')
$c = $c.Replace('SAM', 'RAHUL')
$c = $c.Replace('SOFIA', 'DHANYA')

# Aggressive regex for any variation of Sofia/Sofía
$c = $c -replace '\bSof[iaí]+a\b', 'Dhanya'
$c = $c -replace '\bSOF[IAÍ]+A\b', 'DHANYA'

# 2. Dates & Countdown
$c = $c.Replace('["10","Sept","2027"]', '["13","Sept","2026"]')
$c = $c.Replace('September 10, 2027', 'September 13, 2026')
$c = $c.Replace('2026-09-06', '2026-09-13')
$c = $c.Replace('20260904/20260907', '20260913/20260914')
$c = $c.Replace('new Date("2026-10-31T16:30:00")', 'new Date("2026-09-13T10:00:00")')

# 3. Venue - All parts
$c = $c.Replace('Villa Medicea di Artimino', 'Akhil Convention Centre')
$c = $c.Replace('Via di Papa Leone X, 28', 'Shankaramangalam Koyivila Rd')
$c = $c.Replace('Artimino, Florencia', 'Thevalakkara, Kerala')
$c = $c.Replace('Moutiers-Sainte-Marie, France', 'Kollam, Kerala')

# 4. Remove Extra Badge
$badgePattern = 'f\.jsx\(z\.div,\{initial:\{opacity:0,scale:\.8\},whileInView:\{opacity:1,scale:1\},transition:\{duration:\.5,delay:\.6\},viewport:\{once:!0\},className:"absolute -top-2 -right-2 md:top-0 md:right-0 z-10",children:f\.jsx\("div",\{className:"px-3 py-1\.5 rounded-full shadow-md text-center",style:\{backgroundColor:"#5C2018",maxWidth:"140px"\},children:f\.jsx\("span",\{className:"font-body text-\[9px\] md:text-\[10px\] tracking-wide text-white leading-tight block",children:e\("saveTheDate\.extraBadge"\)\}\)\}\)\}\)'
$c = $c -replace $badgePattern, 'null'

# 5. Remove "Please avoid wearing white"
$avoidWhitePattern = 'f\.jsx\(z\.div,\{initial:\{opacity:0,y:30\},whileInView:\{opacity:1,y:0\},transition:\{duration:\.8,ease:"easeOut",delay:.8\},viewport:\{once:!0\},className:"text-center",children:f\.jsx\("p",\{className:"font-script text-2xl md:text-3xl",style:\{color:"#5C2018"\},children:e\("dressCode\.avoidWhite"\)\}\)\}\)'
$c = $c -replace $avoidWhitePattern, 'null'

# 6. Replace Menu with Wedding Events
$eventsHtml = @"
f.jsxs("div",{className:"space-y-8 py-4",children:[
    f.jsxs("div",{className:"text-center",children:[
        f.jsx("h3",{className:"font-display text-sm tracking-widest uppercase mb-1",style:{color:"#5C2018"},children:"Mehndi"}),
        f.jsx("p",{className:"font-body text-xs",style:{color:"#5C2018"},children:"September 11, 2026 | 3:00 PM"}),
        f.jsx("p",{className:"font-body text-[10px] italic",style:{color:"#5C2018"},children:"Akhil Convention Centre"})
    ]}),
    f.jsxs("div",{className:"text-center",children:[
        f.jsx("h3",{className:"font-display text-sm tracking-widest uppercase mb-1",style:{color:"#5C2018"},children:"Pudava & Sangeet"}),
        f.jsx("p",{className:"font-body text-xs",style:{color:"#5C2018"},children:"September 12, 2026 | 5:00 PM"}),
        f.jsx("p",{className:"font-body text-[10px] italic",style:{color:"#5C2018"},children:"Akhil Convention Centre"})
    ]}),
    f.jsxs("div",{className:"text-center",children:[
        f.jsx("h3",{className:"font-display text-sm tracking-widest uppercase mb-1",style:{color:"#5C2018"},children:"Wedding (Saat Phere)"}),
        f.jsx("p",{className:"font-body text-xs",style:{color:"#5C2018"},children:"September 13, 2026 | 10:00 AM"}),
        f.jsx("p",{className:"font-body text-[10px] italic",style:{color:"#5C2018"},children:"Akhil Convention Centre"})
    ]})
]})
"@
$eventsHtml = $eventsHtml.Replace("`r`n", "").Replace("    ", "")
$menuChildrenPattern = 'f\.jsxs\("div",\{className:"space-y-8",children:\[f\.jsxs\(z\.div,\{initial:\{opacity:0,y:10\},whileInView:\{opacity:1,y:0\},transition:\{duration:\.5,delay:\.4\},viewport:\{once:!0\},className:"text-center",children:\[f\.jsx\("h3",\{className:"font-display text-xs md:text-sm tracking-\[0\.2em\] uppercase mb-1",style:\{color:"#5C2018"\},children:"Aperitivo"\}[\s\S]*?\}\)\]\}\)\]\}\)'
$c = $c -replace $menuChildrenPattern, $eventsHtml

# 7. Translation Sync
$c = $c.Replace('s("demo.title")', '"' + (Escape-JSString $en.'intro.invitation') + '"')
$c = $c.Replace('s("demo.buyNow")', '"' + (Escape-JSString $en.'intro.personalMessage') + '"')
$c = $c.Replace('e("dressCode.title")', '"' + (Escape-JSString $en.'dressCode.title') + '"')
$c = $c.Replace('e("dressCode.description")', '"' + (Escape-JSString $en.'dressCode.description') + '"')
$c = $c.Replace('e("dressCode.formal")', '"' + (Escape-JSString $en.'dressCode.formal') + '"')
$c = $c.Replace('e("transport.title")', '"' + (Escape-JSString $en.'transport.title') + '"')
$c = $c.Replace('e("transport.description")', '"' + (Escape-JSString $en.'transport.description') + '"')
$c = $c.Replace('e("transport.howToGet")', '"' + (Escape-JSString $en.'transport.howToGet') + '"')
$c = $c.Replace('e("transport.departure")', '"' + (Escape-JSString $en.'transport.departure') + '"')
$c = $c.Replace('e("transport.rsvpNote")', '"' + (Escape-JSString $en.'transport.rsvpNote') + '"')

# 8. RSVP Sections
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

# 9. Header & Switcher (Keep them removed)
$c = $c.Replace('f.jsxs("main",{className:"bg-white",children:[f.jsx(FV,{}),f.jsx(VV,{}),', 'f.jsxs("main",{className:"bg-white",children:[null,null,')
$c = $c.Replace('f.jsx($$,{}),f.jsx(V$,{}),', 'f.jsx($$,{}),null,')

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
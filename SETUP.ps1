# Final ultra-robust setup script
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

# 4. Remove Extra Badge (marked in screenshot)
# Pattern matches the brown badge near the venue illustration
$badgePattern = 'f\.jsx\(z\.div,\{initial:\{opacity:0,scale:\.8\},whileInView:\{opacity:1,scale:1\},transition:\{duration:\.5,delay:\.6\},viewport:\{once:!0\},className:"absolute -top-2 -right-2 md:top-0 md:right-0 z-10",children:f\.jsx\("div",\{className:"px-3 py-1\.5 rounded-full shadow-md text-center",style:\{backgroundColor:"#5C2018",maxWidth:"140px"\},children:f\.jsx\("span",\{className:"font-body text-\[9px\] md:text-\[10px\] tracking-wide text-white leading-tight block",children:e\("saveTheDate\.extraBadge"\)\}\)\}\)\}\)'
$c = $c -replace $badgePattern, 'null'

# 5. Remove "Please avoid wearing white" (marked in screenshot)
$avoidWhitePattern = 'f\.jsx\(z\.div,\{initial:\{opacity:0,y:30\},whileInView:\{opacity:1,y:0\},transition:\{duration:\.8,ease:"easeOut",delay:.8\},viewport:\{once:!0\},className:"text-center",children:f\.jsx\("p",\{className:"font-script text-2xl md:text-3xl",style:\{color:"#5C2018"\},children:e\("dressCode\.avoidWhite"\)\}\)\}\)'
$c = $c -replace $avoidWhitePattern, 'null'

# 6. Replace Menu with Wedding Events (marked in screenshot)
# We build a custom block for events
$eventsBlock = @"
f.jsxs("div",{className:"space-y-8 py-4",children:[
    f.jsxs("div",{className:"text-center",children:[
        f.jsx("h3",{className:"font-display text-sm tracking-widest uppercase mb-1",style:{color:"#5C2018"},children:"Mehndi"}),
        f.jsx("p",{className:"font-body text-xs",style:{color:"#5C2018"},children:"September 11, 2026 | 3:00 PM"}),
        f.jsx("p",{className:"font-body text-[10px] italic",style:{color:"#5C2018"},children:"Akhil Convention Centre"})
    ]}),
    f.jsxs("div",{className:"text-center",children:[
        f.jsx("h3",{className:"font-display text-sm tracking-widest uppercase mb-1",style:{color:"#5C2018"},children:"Podva & Sangeet"}),
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
$eventsBlock = $eventsBlock.Replace("`r`n", "").Replace("    ", "")

# This pattern matches the entire Italian menu container
$menuPattern = 'f\.jsx\("div",\{className:"bg-white/80 backdrop-blur-sm p-8 md:p-12 rounded-2xl shadow-xl border border-[#5C2018]/10 max-w-lg mx-auto relative z-10",children:f\.jsxs\("div",\{className:"space-y-8",children:\[f\.jsxs\(z\.div,\{initial:\{opacity:0,y:10\},whileInView:\{opacity:1,y:0\},transition:\{duration:\.5,delay:\.4\},viewport:\{once:!0\},className:"text-center",children:\[f\.jsx\("h3",\{className:"font-display text-xs md:text-sm tracking-\[0\.2em\] uppercase mb-1",style:\{color:"#5C2018"\},children:"Aperitivo"\}[\s\S]*?\}\)\]\}\)\]\}\)\}\)'
$c = $c -replace $menuPattern, ('f.jsx("div",{className:"bg-white/80 backdrop-blur-sm p-8 md:p-12 rounded-2xl shadow-xl border border-[#5C2018]/10 max-w-lg mx-auto relative z-10",children:' + $eventsBlock + '})')

# 7. Translations
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

# 8. RSVP Sections (jV and IV objects)
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
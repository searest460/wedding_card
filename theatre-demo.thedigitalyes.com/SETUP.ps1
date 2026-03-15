# =============================================================
# MASTER SETUP SCRIPT - Dhanya & Rahul Wedding Invitation
# Robust Version: Uses translations.json for UTF-8 support
# =============================================================

$root = "c:\Users\Rahuldev\Downloads\theatre_demo.thedigitalyes.com\theatre-demo.thedigitalyes.com"
$jsPath = "$root\assets\index-BBIwAgSn.js"
$translationsPath = "$root\translations.json"

# ------------------------------------------------------------
# STEP 1: Download fresh original JS bundle
# ------------------------------------------------------------
Write-Host "[1/4] Downloading original JS bundle..."
Invoke-WebRequest -Uri "https://theatre-demo.thedigitalyes.com/assets/index-BBIwAgSn.js" -OutFile $jsPath
Write-Host "      Done."

# ------------------------------------------------------------
# STEP 2: Load the bundle and translations
# ------------------------------------------------------------
Write-Host "[2/4] Loading files..."
$c = [System.IO.File]::ReadAllText($jsPath, [System.Text.Encoding]::UTF8)
$transJson = [System.IO.File]::ReadAllText($translationsPath, [System.Text.Encoding]::UTF8)

# ------------------------------------------------------------
# STEP 3: Apply all replacements
# ------------------------------------------------------------
Write-Host "[3/4] Applying customizations..."

# 1. COUPLE NAMES
$c = $c -replace 'Sam \& Sof.a', 'Dhanya & Rahul'
$c = $c -replace 'SAM \& SOF.A', 'DHANYA & RAHUL'
$c = $c -replace 'Sam \& Sofia', 'Dhanya & Rahul'
$c = $c -replace 'SAM \& SOFIA', 'DHANYA & RAHUL'
$c = $c.Replace('children:"Sam"', 'children:"Dhanya"')
$c = $c -replace 'children:"Sof.a"', 'children:"Rahul"'

# 2. TRANSLATIONS (Inject EN from JSON)
$jsTranslations = "T$=" + $transJson
$startIndex = $c.IndexOf("T$={en:{")
$endIndex = $c.IndexOf("}};function lr()", $startIndex)
if ($startIndex -ge 0 -and $endIndex -gt $startIndex) {
    $before = $c.Substring(0, $startIndex)
    $after = $c.Substring($endIndex + 2)
    $c = $before + $jsTranslations + $after
}

# 3. GLOBAL PATCHES (Dates, Locations)
$c = $c.Replace('["10","Sept","2027"]', '["13","Sept","2026"]')
$c = $c.Replace('new Date("2026-10-31T16:30:00")', 'new Date("2026-09-13T11:30:00")')
$c = $c.Replace('new Date("2026-09-06")', 'new Date("2026-09-13")')
$c = $c.Replace('Villa Medicea di Artimino', 'Akhil Convention Centre')
$c = $c.Replace('Thevalakkara, Kerala', 'Akhil Convention Centre, Shankaramangalam Koyivila Rd, Thevalakkara, Kerala 691590')
$c = $c.Replace('Artimino, Florencia', 'Thevalakkara, Kerala')
$c = $c.Replace('"VIA DI PAPA LEONE X, 28"', '"SHANKARAMANGALAM KOYIVILA RD"')
$c = $c.Replace('Akhil Convention Centre, Shankaramangalam Koyivila Rd, Akhil Convention Centre, Shankaramangalam Koyivila Rd, Thevalakkara, Kerala 691590', 'Thevalakkara, Kerala')

# 4. REMOVALS & UI CLEANUP
$c = $c.Replace('f.jsxs("main",{className:"bg-white",children:[f.jsx(FV,{}),f.jsx(VV,{}),', 'f.jsxs("main",{className:"bg-white",children:[null,null,')
$c = $c.Replace('f.jsx(V$,{}),f.jsx(U$,{})', 'null,f.jsx(U$,{})')

# Define WelcomeNote Carousel Component (Revised for visibility)
$welcomeCarousel = 'W$=()=>{const{t:e}=lr(),[n,r]=g.useState(0),s=["/assets/couple-wedding.png","/assets/couple-dance.png","/assets/couple-garden.png"];g.useEffect(()=>{const o=setInterval(()=>{r(a=>(a+1)%s.length)},4e3);return()=>clearInterval(o)},[s.length]);return f.jsxs("section",{className:"py-20 bg-[#FAF8F5] flex flex-col items-center justify-center px-8",children:[f.jsxs("div",{className:"text-center max-w-3xl mb-16",children:[f.jsx("h2",{className:"font-script text-5xl md:text-6xl mb-6",style:{color:"#5C2018"},children:e("welcome.title")}),f.jsx("p",{className:"font-body text-lg md:text-xl leading-relaxed",style:{color:"#5C2018"},children:e("welcome.message")})]}),f.jsx("div",{className:"relative w-full max-w-4xl aspect-[16/9] rounded-3xl overflow-hidden shadow-2xl bg-gray-100",children:s.map((o,a)=>f.jsx("div",{className:"absolute inset-0 w-full h-full transition-opacity duration-1000",style:{opacity:n===a?1:0,zIndex:n===a?1:0},children:f.jsx("img",{src:o,alt:"Couple",className:"w-full h-full object-cover"})},a))})]})};'

# Inject W$ before N$ definition
$c = $c.Replace('N$=()=>{', $welcomeCarousel + 'N$=()=>{')

# Inject W$ into main children between N$ and I$
$c = $c.Replace('f.jsx(N$,{}),f.jsx(I$,{})', 'f.jsx(N$,{}),f.jsx(W$,{}),f.jsx(I$,{})')

$badgePattern = 'f.jsx(z.div,{initial:{opacity:0,scale:.8},whileInView:{opacity:1,scale:1},transition:{duration:.5,delay:.6},viewport:{once:!0},className:"absolute -top-2 -right-2 md:top-0 md:right-0 z-10",children:f.jsx("div",{className:"px-3 py-1.5 rounded-full shadow-md text-center",style:{backgroundColor:"#5C2018",maxWidth:"140px"},children:f.jsx("span",{className:"font-body text-[9px] md:text-[10px] tracking-wide text-white leading-tight block",children:e("saveTheDate.extraBadge")})})})'
$c = $c.Replace($badgePattern, 'null')

$customizablePattern = 'f.jsxs(z.div,{initial:{opacity:0,y:-10},whileInView:{opacity:1,y:0},viewport:{once:!0},className:"flex items-center justify-center gap-2 mb-6 px-4 py-2 rounded-full mx-auto w-fit",style:{backgroundColor:"rgba(92, 32, 24, 0.08)",border:"1px solid rgba(92, 32, 24, 0.15)"},children:[f.jsx(Z1,{size:14,style:{color:"#5C2018",opacity:.7}}),f.jsx("span",{className:"font-body text-xs tracking-wide",style:{color:"rgba(92, 32, 24, 0.8)"},children:t.customizable})]})'
$c = $c.Replace($customizablePattern, 'null')

# 5. PROGRAMME / EVENTS TRANSLATIONS (Converting Menu to Events)
$c = $c -replace 'children:"Aperitivo"', 'children:"MEHNDI"'
$c = $c -replace 'children:"Selecci.n de antipasti toscanos"', 'children:"Malepurath House"'
$c = $c -replace 'f\.jsx\("p",\{className:"font-body text-\[10px\] md:text-xs italic",style:\{color:"#5C2018"\},children:"Bruschetta, crostini & affettati misti"\}\)', 'f.jsx("p",{className:"font-body text-[10px] md:text-xs",style:{color:"#5C2018"},children:"11 Sep, 3:00 PM"})'

$c = $c -replace 'children:"Primo"', 'children:"PUDAVA & SANGEET"'
$c = $c -replace 'children:"Risotto al tartufo nero di Norcia"', 'children:"Malepurath House"'
$c = $c -replace 'f\.jsx\("p",\{className:"font-body text-\[10px\] md:text-xs italic",style:\{color:"#5C2018"\},children:"con parmigiano reggiano 24 mesi"\}\)', 'f.jsx("p",{className:"font-body text-[10px] md:text-xs",style:{color:"#5C2018"},children:"12 Sep, 5:00 PM"})'

$c = $c -replace 'children:"Secondo"', 'children:"SAAT PHERE"'
$c = $c -replace 'children:"Filetto di manzo alla griglia"', 'children:"Akhil Convention Centre"'
$c = $c -replace 'f\.jsx\("p",\{className:"font-body text-\[10px\] md:text-xs italic",style:\{color:"#5C2018"\},children:"con salsa al vino rosso e verdure di stagione"\}\)', 'f.jsx("p",{className:"font-body text-[10px] md:text-xs",style:{color:"#5C2018"},children:"13 Sep, 11:30 AM"})'

$c = $c -replace 'children:"Dolce"', 'children:"RECEPTION"'
$c = $c -replace 'children:"Torta nuziale con crema di mascarpone"', 'children:"Kollam, Kerala"'
$c = $c -replace 'f\.jsx\("p",\{className:"font-body text-\[10px\] md:text-xs italic",style:\{color:"#5C2018"\},children:"e frutti di bosco freschi"\}\)', 'f.jsx("p",{className:"font-body text-[10px] md:text-xs",style:{color:"#5C2018"},children:"13 Sep, 7:00 PM"})'

$c = $c.Replace('children:"Tradition"', 'children:"Wedding Day"')
$c = $c.Replace('children:"Vini della Tenuta"', 'children:"Blessings Only"')

# Hack to add "Events" Title (Replacing original Menu structure)
$c = $c.Replace('children:[f.jsxs(z.div,{initial:{opacity:0,y:10},whileInView:{opacity:1,y:0},transition:{duration:.5,delay:.4},viewport:{once:!0},className:"text-center mb-5",children:[f.jsx("h3"', 'children:[f.jsx("h2",{className:"font-display text-3xl mb-8",style:{color:"#5C2018"},children:"Events"}),f.jsxs(z.div,{initial:{opacity:0,y:10},whileInView:{opacity:1,y:0},transition:{duration:.5,delay:.4},viewport:{once:!0},className:"text-center mb-5",children:[f.jsx("h3"')

# 8. FINAL CLEANUP (Fallback names, RSVP confirmation, leftover Italian)
$c = $c.Replace('"Matthias"', '"Dhanya"')
$c = $c.Replace('"Flora"', '"Rahul"')
$c = $c.Replace('Moutiers-Sainte-Marie, France', 'Thevalakkara, Kerala')
$c = $c.Replace('Monastère de Ségries', 'Akhil Convention Centre')
$c = $c.Replace('September 4-6', 'September 11-13')

# Completely wipe the Italian section in RSVP to avoid any accidental fallback
$itIdx = $c.IndexOf('it:{customizable:"Questo modulo')
if ($itIdx -ge 0) {
    $endIdx = $c.IndexOf('guest:"Ospite"}', $itIdx)
    if ($endIdx -gt $itIdx) {
        $c = $c.Remove($itIdx, $endIdx - $itIdx + 15)
    }
}

# Also handle the leading comma if it exists
$c = $c.Replace(',}', '}')
$c = $c.Replace(',,', ',')

# 7. LOCATION & TRANSPORTATION REDESIGN (Careful replacement)
$newLocTrans = 'U$=()=>{const{t:e}=lr();return f.jsxs("section",{className:"bg-[#FAF8F5] flex flex-col items-center justify-center py-20 px-6",children:[f.jsxs(z.div,{initial:{opacity:0,y:30},whileInView:{opacity:1,y:0},transition:{duration:.8,ease:"easeOut"},viewport:{once:!0},className:"text-center mb-12",children:[f.jsx("h2",{className:"font-script text-5xl md:text-6xl tracking-wide",style:{color:"#5C2018"},children:e("transport.title")})]}),f.jsx(z.div,{initial:{opacity:0,y:30},whileInView:{opacity:1,y:0},transition:{duration:.8,ease:"easeOut",delay:.2},viewport:{once:!0},className:"w-full max-w-4xl",children:f.jsxs("div",{className:"bg-white rounded-3xl shadow-xl p-8 md:p-12 flex flex-col items-center",children:[f.jsx("div",{className:"mb-6",children:f.jsxs("svg",{width:"32",height:"32",viewBox:"0 0 24 24",fill:"none",stroke:"#5C2018",strokeWidth:"1.5",strokeLinecap:"round",strokeLinejoin:"round",children:[f.jsx("path",{d:"M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"}),f.jsx("circle",{cx:"12",cy:"10",r:"3"})]})}),f.jsx("p",{className:"font-body text-base md:text-lg text-center mb-8 max-w-md",style:{color:"#5C2018"},children:e("transport.description")}),f.jsxs("a",{href:"https://www.google.com/maps/search/?api=1&query=Akhil+Convention+Centre+Thevalakkara",target:"_blank",rel:"noopener noreferrer",className:"font-display text-sm tracking-[0.2em] border-b-2 pb-1 mb-12 hover:opacity-70 transition-opacity",style:{color:"#5C2018",borderColor:"#5C2018"},children:[e("transport.googleMaps")]}),f.jsx("div",{className:"w-1/4 h-px mb-12",style:{backgroundColor:"rgba(92, 32, 24, 0.2)"}}),f.jsx("div",{className:"mb-6",children:f.jsxs("svg",{width:"32",height:"32",viewBox:"0 0 24 24",fill:"none",stroke:"#5C2018",strokeWidth:"1.5",strokeLinecap:"round",strokeLinejoin:"round",children:[f.jsx("path",{d:"M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.4 2.9A3.7 3.7 0 0 0 2 12v4c0 .6.4 1 1 1h2"}),f.jsx("circle",{cx:"7",cy:"17",r:"2"}),f.jsx("path",{d:"M9 17h6"}),f.jsx("circle",{cx:"17",cy:"17",r:"2"})]})}),f.jsx("p",{className:"font-body text-xs tracking-[0.2em] uppercase mb-4",style:{color:"#5C2018"},children:e("transport.departure")}),f.jsx("p",{className:"font-body text-sm md:text-base text-center leading-relaxed",style:{color:"#5C2018"},children:e("transport.directions")})]})})]})}'

# Use Regex for more robust replacement of the U$ component
$pattern = [regex]::Escape("U$=()=>{") + ".*?" + [regex]::Escape(")},kg=")
$replacement = $newLocTrans + "," + "kg="
$c = [regex]::Replace($c, $pattern, $replacement)

# ------------------------------------------------------------
# STEP 4: Save the bundle
# ------------------------------------------------------------
[System.IO.File]::WriteAllText($jsPath, $c, [System.Text.Encoding]::UTF8)
Write-Host "      Done."

# ------------------------------------------------------------
# STEP 5: Write the final index.html
# ------------------------------------------------------------
Write-Host "[4/4] Writing index.html..."
$html = @"
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Dhanya & Rahul Wedding</title>
  <meta name="description" content="Wedding Invitation | Dhanya & Rahul | September 13, 2026">
  <meta property="og:title" content="Dhanya & Rahul Wedding">
  <script type="module" crossorigin src="./assets/index-BBIwAgSn.js"></script>
  <link rel="stylesheet" crossorigin href="./assets/index-bYuRLTYZ.css">
</head>
<body>
  <div id="root">
    <div id="initial-loader" style="position: fixed; inset: 0; background: #000; display: flex; align-items: center; justify-content: center; z-index: 9999;">
      <img src="./assets/curtain-closed-Bpkadld4.jpg" style="position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; opacity: 0.5;" />
      <div style="position: relative; text-align: center; color: white;">
        <div style="width: 40px; height: 40px; border: 3px solid rgba(255,255,255,0.3); border-top-color: white; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 20px;"></div>
        <p style="font-family: serif; letter-spacing: 4px; font-size: 14px; text-transform: uppercase;">Loading Invitation</p>
      </div>
    </div>
    <style>
      @keyframes spin { to { transform: rotate(360deg); } }
    </style>
  </div>
</body>
</html>
"@
[System.IO.File]::WriteAllText("$root\index.html", $html, [System.Text.Encoding]::UTF8)
Write-Host "      Done."
Write-Host ""
Write-Host "=============================================="
Write-Host " ALL DONE! Open http://localhost:8080"
Write-Host "=============================================="

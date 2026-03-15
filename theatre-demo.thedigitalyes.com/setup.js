const fs = require('fs');
const https = require('https');
const path = require('path');

const root = '.';
const jsPath = path.join(root, 'assets', 'index-BBIwAgSn.js');
const indexPath = path.join(root, 'index.html');

console.log('[1/4] Downloading original JS bundle...');

const download = (url, dest) => {
    return new Promise((resolve, reject) => {
        const file = fs.createWriteStream(dest);
        https.get(url, (response) => {
            response.pipe(file);
            file.on('finish', () => {
                file.close(resolve);
            });
        }).on('error', (err) => {
            fs.unlink(dest, () => reject(err));
        });
    });
};

(async () => {
    try {
        // Original download URL removed for privacy
        // await download('...', jsPath);

        console.log('      Done.');

        console.log('[2/4] Loading bundle...');
        let c = fs.readFileSync(jsPath, 'utf8');

        console.log('[3/4] Applying customizations...');

        // 1. COUPLE NAMES
        c = c.replace(/Sam \& Sof.a/g, 'Dhanya & Rahul');
        c = c.replace(/SAM \& SOF.A/g, 'DHANYA & RAHUL');
        c = c.replace(/Sam \& Sofia/g, 'Dhanya & Rahul');
        c = c.replace(/SAM \& SOFIA/g, 'DHANYA & RAHUL');
        c = c.replace(/children:"Sam"/g, 'children:"Dhanya"');
        c = c.replace(/children:"Sof.a"/g, 'children:"Rahul"');

        // 2. LANGUAGE SWITCHER UI (REMOVED)
        // The language switcher is removed from the layout in Step 5 below.

        // 3. TRANSLATIONS
        const en = {
            "intro.tapToContinue": "Tap to continue",
            "intro.invitation": "A Journey of Two Souls, One Heart",
            "intro.personalMessage": "You are cordially invited to celebrate the wedding of Dhanya & Rahul. We would like to invite you to celebrate with us the most special day of our lives.",
            "intro.scroll": "Scroll",
            "reveal.title": "Reveal",
            "reveal.subtitle": "Scratch to discover the date",
            "reveal.scratchHint": "Scratch all three circles to continue",
            "reveal.weddingAnnouncement": "We're getting married!",
            "countdown.title": "Countdown",
            "countdown.days": "Days",
            "countdown.hours": "Hours",
            "countdown.minutes": "Min",
            "countdown.seconds": "Sec",
            "countdown.forTheBigDay": "until the big day",
            "saveTheDate.celebrationAt": "The celebration will take place at",
            "saveTheDate.receptionToFollow": "Dhanya Weds Rahul - Saat Phere | 10:00 AM",
            "dressCode.title": "Dress Code by Event",
            "dressCode.description": "Each event has its own dress code to make the celebration vibrant and colourful.",
            "dressCode.formal": "Mehndi (11 Sep): Shades of Pink (Traditional) | Sangeet (12 Sep): Sharara, Gharara or Kurta | Wedding (13 Sep): Davani, Traditional or Mundu & Kurta",
            "dressCode.avoidWhite": "",
            "gifts.title": "Gifts",
            "gifts.message": "Your presence is the best gift we could receive. However, if you wish to contribute to our new life together, you can do so via bank transfer.",
            "gifts.bankDetails": "Bank details",
            "gifts.concept": "REFERENCE: Dhanya & Rahul Wedding",
            "transport.title": "Wedding Events",
            "transport.description": "Join us for three days of celebration, love, and togetherness. All events will be held at Akhil Convention Centre, Thevalakkara, Kerala.",
            "transport.departure": "Mehndi - 11 Sep, 3:00 PM",
            "transport.returnTo": "Sangeet - 12 Sep, 5:00 PM",
            "transport.rsvpNote": "Please bless us with your presence for all three days of celebration.",
            "rsvp.title": "Confirm your attendance",
            "rsvp.deadline": "Please respond by August 25th",
            "rsvp.fullName": "Full name *",
            "rsvp.yesButton": "I'll be there!",
            "rsvp.noButton": "Can't make it",
            "rsvp.dietary": "",
            "rsvp.dietaryPlaceholder": ""
        };

        const jsTranslations = `T$={en:${JSON.stringify(en)}}`;

        const startMarker = 'T$={en:{';
        const endMarker = '}};function lr()';

        const startIndex = c.indexOf(startMarker);
        const endIndex = c.indexOf(endMarker, startIndex);

        if (startIndex >= 0 && endIndex > startIndex) {
            const before = c.substring(0, startIndex);
            const after = c.substring(endIndex + 2);
            c = before + jsTranslations + after;
        }

        // 4. GLOBAL PATCHES
        c = c.replace(/\["10","Sept","2027"\]/g, '["13","Sept","2026"]');
        c = c.replace(/new Date\("2026-10-31T16:30:00"\)/g, 'new Date("2026-09-13T10:00:00")');
        c = c.replace(/new Date\("2026-09-06"\)/g, 'new Date("2026-09-13")');
        c = c.replace(/Villa Medicea di Artimino/g, 'Akhil Convention Centre');
        c = c.replace(/Via di Papa Leone X, 28, Artimino, Florencia \(Italy\)/g, 'Akhil Convention Centre, Shankaramangalam Koyivila Rd, Thevalakkara, Kerala 691590');
        c = c.replace(/Artimino, Florencia/g, 'Thevalakkara, Kerala');
        c = c.replace(/"VIA DI PAPA LEONE X, 28"/g, '"SHANKARAMANGALAM KOYIVILA RD"');

        // Clean up Italian remnants found in strings
        c = c.replace(/Matrimonio/g, 'Vivah');
        c = c.replace(/Sposi/g, 'Couple');
        c = c.replace(/Ricevimento/g, 'Reception');
        c = c.replace(/Invitati/g, 'Guests');
        c = c.replace(/Abbigliamento Formale/g, 'Traditional Attire');

        // 5. REMOVALS (Per user request)
        // Remove Header Left (FV) and Language Switcher (VV) from main UV component
        c = c.replace('f.jsxs("main",{className:"bg-white",children:[f.jsx(FV,{}),f.jsx(VV,{}),', 'f.jsxs("main",{className:"bg-white",children:[null,null,');
        
        // Remove Gifts section (V$) from main layout
        c = c.replace('f.jsx($$,{}),f.jsx(V$,{}),', 'f.jsx($$,{}),null,');

        // Remove the extra badge (small brown dot) near building illustration
        const badgePattern = /f\.jsx\(z\.div,\{initial:\{opacity:0,scale:\.8\},whileInView:\{opacity:1,scale:1\},transition:\{duration:\.5,delay:\.6\},viewport:\{once:!0\},className:"absolute -top-2 -right-2 md:top-0 md:right-0 z-10",children:f\.jsx\("div",\{className:"px-3 py-1\.5 rounded-full shadow-md text-center",style:\{backgroundColor:"#5C2018",maxWidth:"140px"\},children:f\.jsx\("span",\{className:"font-body text-\[9px\] md:text-\[10px\] tracking-wide text-white leading-tight block",children:e\("saveTheDate\.extraBadge"\)\}\)\}\)\}\)/;
        c = c.replace(badgePattern, 'null');

        // Remove "This form is fully customizable" message in RSVP
        const customizablePattern = /f\.jsxs\(z\.div,\{initial:\{opacity:0,y:-10\},whileInView:\{opacity:1,y:0\},viewport:\{once:!0\},className:"flex items-center justify-center gap-2 mb-6 px-4 py-2 rounded-full mx-auto w-fit",style:\{backgroundColor:"rgba\(92, 32, 24, 0\.08\)",border:"1px solid rgba\(92, 32, 24, 0\.15\)"\},children:\[f\.jsx\(Z1,\{size:14,style:\{color:"#5C2018",opacity:\.7\}\}\),f\.jsx\("span",\{className:"font-body text-xs tracking-wide",style:\{color:"rgba\(92, 32, 24, 0\.8\)"\},children:t\.customizable\}\)\]\}\)/;
        c = c.replace(customizablePattern, 'null');

        // 6. MENU TRANSLATIONS (Restoring what was accidentally removed)
        c = c.replace(/Bruschetta, crostini & affettati misti/g, 'Chaat and Savories');
        c = c.replace(/con parmigiano reggiano 24 mesi/g, 'With traditional accompaniments');
        c = c.replace(/Special Wedding Feast \(Saat Phere\)/g, 'Saat Phere Ceremony Feast');
        c = c.replace(/con salsa al vino rosso e verdure di stagione/g, 'With festive Indian sides');

        // Align events with Mehndi, Podva & Sangeet, Saat Phere, Reception
        c = c.replace(/children:"Aperitivo"/g, 'children:"Mehndi"');
        c = c.replace(/children:"Primo"/g, 'children:"Podva & Sangeet"');
        c = c.replace(/children:"Secondo"/g, 'children:"Saat Phere"');
        c = c.replace(/children:"Tradition"/g, 'children:"Saat Phere"');

        c = c.replace(/Selección de antipasti toscanos/g, 'Indian Appetizers');
        c = c.replace(/Risotto al tartufo nero di Norcia/g, 'Special Wedding Feast');
        c = c.replace(/Filetto di manzo alla griglia/g, 'Main Course');

        // 7. REMOVE MARKED ITEMS (DOLCE section and avoidWhite) and ADD RECEPTION
        // We replace the removed Dolce section with the new Reception section
        const receptionBlock = 'f.jsxs(z.div,{initial:{opacity:0,y:10},whileInView:{opacity:1,y:0},transition:{duration:.5,delay:.7},viewport:{once:!0},className:"text-center mb-5",children:[f.jsx("h3",{className:"font-display text-xs md:text-sm tracking-[0.2em] uppercase mb-1",style:{color:"#5C2018"},children:"Reception"}),f.jsx("p",{className:"font-body text-[10px] md:text-xs",style:{color:"#5C2018"},children:"Grand Celebration"}),f.jsx("p",{className:"font-body text-[10px] md:text-xs italic",style:{color:"#5C2018"},children:"Dinner & Dance"})]})';

        // Using regex for flexibility in matching translations or original strings
        c = c.replace(/f\.jsxs\(z\.div,\{initial:\{opacity:0,y:10\},whileInView:\{opacity:1,y:0\},transition:\{duration:\.5,delay:\.7\},viewport:\{once:!0\},className:"text-center mb-4",children:\[f\.jsx\("h3",\{className:"font-display text-xs md:text-sm tracking-\[0\.2em\] uppercase mb-1",style:\{color:"#5C2018"\},children:"Dolce"\}[\s\S]*?\}\)\]\}\),f\.jsx\(z\.div,\{initial:\{opacity:0,y:10\},whileInView:\{opacity:1,y:0\},transition:\{duration:\.5,delay:\.8\},viewport:\{once:!0\},className:"text-center",children:f\.jsx\("p",\{className:"font-script text-lg md:text-xl",style:\{color:"#5C2018"\},children:[\s\S]*?\}\)\}\)/g, `${receptionBlock},null`);

        // Remove dressCode.avoidWhite
        const avoidWhiteBlock = 'f.jsx(z.div,{initial:{opacity:0,y:30},whileInView:{opacity:1,y:0},transition:{duration:.8,ease:"easeOut",delay:.8},viewport:{once:!0},className:"text-center",children:f.jsx("p",{className:"font-script text-2xl md:text-3xl",style:{color:"#5C2018"},children:e("dressCode.avoidWhite")})})';
        c = c.replace(avoidWhiteBlock, 'null');

        // 8. INSERT WELCOME CAROUSEL SECTION
        const welcomeComponent = 'const WV=()=>{const{t:e}=lr(),r=["./assets/3.png","./assets/4.png","./assets/5.1.png","./assets/6.png","./assets/7.png","./assets/8.1.png"];return f.jsxs("section",{className:"py-16 bg-[#FAF8F5] overflow-hidden",children:[f.jsxs(z.div,{initial:{opacity:0,y:20},whileInView:{opacity:1,y:0},transition:{duration:.8},viewport:{once:!0},className:"text-center px-6 mb-12",children:[f.jsx("h2",{className:"font-script text-5xl md:text-6xl mb-6",style:{color:"#5C2018"},children:e("welcome.title")}),f.jsx("p",{className:"font-body text-sm md:text-base max-w-2xl mx-auto leading-relaxed italic",style:{color:"#5C2018"},children:e("welcome.message")})]}),f.jsx(z.div,{className:"flex gap-4 overflow-x-auto px-6 pb-8 no-scrollbar",initial:{opacity:0},whileInView:{opacity:1},transition:{duration:1,delay:.2},viewport:{once:!0},children:r.map((o,a)=>f.jsx(z.div,{className:"flex-none w-64 h-96 rounded-lg overflow-hidden shadow-lg",whileHover:{scale:1.05},transition:{duration:.3},children:f.jsx("img",{src:o,className:"w-full h-full object-cover",alt:`Couple ${a+1}`})},a))})]})};';
        c = c.replace('const UV=', welcomeComponent + 'const UV=');
        c = c.replace('f.jsx(N$,{}),', 'f.jsx(N$,{}),f.jsx(WV,{}),');

        fs.writeFileSync(jsPath, c, 'utf8');
        console.log('      Done.');

        console.log('[4/4] Writing index.html...');
        const html = `<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Dhanya & Rahul Wedding</title>
  <meta name="description" content="Wedding Invitation | Dhanya & Rahul | September 13, 2026">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500&family=Yatra+One&display=swap" rel="stylesheet">
  <script type="module" crossorigin src="./assets/index-BBIwAgSn.js"></script>
  <link rel="stylesheet" crossorigin href="./assets/index-bYuRLTYZ.css">
  <style>
    :root {
      --color-saffron: #FF6B00;
      --color-maroon: #800020;
      --color-gold: #FFB300;
      --color-ivory: #FDF3E3;
      --font-hindi: 'Yatra One', cursive;
      --font-body: 'Inter', sans-serif;
    }

    body {
      background: radial-gradient(circle at center, var(--color-ivory) 0%, var(--color-ivory) 40%, rgba(128, 0, 32, 0.1) 100%);
      margin: 0;
      overflow-x: hidden;
    }

    /* Override some React styles to match theme */
    #root button { font-family: var(--font-hindi) !important; }
    #root h1, #root h2, #root h3 { font-family: var(--font-hindi) !important; color: var(--color-maroon) !important; }
    
    /* Antigravity Styles */
    #antigravity-container {
      position: fixed;
      inset: 0;
      pointer-events: none;
      z-index: 50;
    }
    .floating-el {
      position: absolute;
      pointer-events: auto;
      cursor: pointer;
      transition: transform 0.3s ease-out;
      will-change: transform;
    }
    .burst-particle {
      position: absolute;
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: var(--color-saffron);
      pointer-events: none;
      z-index: 60;
    }
    #gravity-toggle {
      position: fixed;
      bottom: 24px;
      right: 24px;
      z-index: 100;
      background: var(--color-maroon);
      color: var(--color-ivory);
      padding: 12px 24px;
      border-radius: 50px;
      font-family: var(--font-hindi);
      border: 1px solid rgba(255, 179, 0, 0.3);
      cursor: pointer;
      box-shadow: 0 10px 25px rgba(0,0,0,0.2);
      transition: all 0.3s;
      display: flex;
      align-items: center;
      gap: 8px;
      pointer-events: auto;
    }
    #gravity-toggle:hover { transform: scale(1.05); }
    #gravity-toggle:active { transform: scale(0.95); }
  </style>
</head>
<body>
  <div id="root"></div>
  
  <div id="antigravity-container"></div>
  
  <button id="gravity-toggle">
    <span>🕉️</span>
    <span id="toggle-text">Toggle Gravity</span>
  </button>

  <script>
    (function() {
      const container = document.getElementById('antigravity-container');
      const toggleBtn = document.getElementById('gravity-toggle');
      const toggleText = document.getElementById('toggle-text');
      
      let elements = [];
      let isGravityOn = false;
      let mouseX = -1000, mouseY = -1000;
      
      const SVGS = {
        marigold: \`<svg viewBox="0 0 100 100" width="100%" height="100%"><circle cx="50" cy="50" r="40" fill="#FF6B00"/><g opacity="0.8">\${[0,45,90,135,180,225,270,315].map(d=>\`<ellipse cx="50" cy="25" rx="15" ry="25" fill="#FFB300" transform="rotate(\${d} 50 50)"/>\`).join('')}</g></svg>\`,
        om: \`<div style="font-family:'Yatra One';color:#FF6B00;font-size:32px;user-select:none;opacity:0.8">ॐ</div>\`,
        lotus: \`<svg viewBox="0 0 100 100" width="100%" height="100%"><g fill="#FFB300" opacity="0.3">\${[0,60,120,180,240,300].map(d=>\`<path d="M50 50 Q70 20 50 5 L30 20 Q50 50 50 50" transform="rotate(\${d} 50 50)"/>\`).join('')}</g></svg>\`,
        diya: \`<svg viewBox="0 0 100 100" width="100%" height="100%"><path d="M20 60 Q50 90 80 60 L80 50 Q50 30 20 50 Z" fill="#800020"/><path d="M45 40 Q50 10 55 40 Z" fill="#FFB300" class="diya-flame"/></svg>\`
      };

      const types = ['marigold', 'om', 'lotus', 'diya'];
      
      function createElements() {
        for(let i=0; i<35; i++) {
          const type = types[i % types.length];
          const el = document.createElement('div');
          el.className = 'floating-el';
          el.innerHTML = SVGS[type];
          
          const data = {
            dom: el,
            x: Math.random() * innerWidth,
            y: Math.random() * innerHeight,
            size: 25 + Math.random() * 25,
            vx: (Math.random() - 0.5) * 0.5,
            vy: (Math.random() - 0.5) * 0.5,
            rotation: Math.random() * 360,
            rv: (Math.random() - 0.5) * 1,
            phase: Math.random() * Math.PI * 2,
            type: type
          };
          
          el.style.width = data.size + 'px';
          el.style.height = data.size + 'px';
          
          el.addEventListener('click', (e) => {
            e.stopPropagation();
            createBurst(data.x, data.y);
            el.remove();
            elements = elements.filter(item => item !== data);
          });
          
          container.appendChild(el);
          elements.push(data);
        }
      }

      function createBurst(x, y) {
        for(let i=0; i<8; i++) {
          const p = document.createElement('div');
          p.className = 'burst-particle';
          p.style.left = x + 'px';
          p.style.top = y + 'px';
          document.body.appendChild(p);
          
          const angle = Math.random() * Math.PI * 2;
          const speed = 2 + Math.random() * 4;
          const vx = Math.cos(angle) * speed;
          const vy = Math.sin(angle) * speed;
          
          let life = 1.0;
          function anim() {
            life -= 0.02;
            if(life <= 0) { p.remove(); return; }
            const curX = parseFloat(p.style.left) + vx;
            const curY = parseFloat(p.style.top) + vy + (1.0 - life) * 5;
            p.style.left = curX + 'px';
            p.style.top = curY + 'px';
            p.style.opacity = life;
            requestAnimationFrame(anim);
          }
          anim();
        }
      }

      function update() {
        elements.forEach(el => {
          if (isGravityOn) {
            el.vy += 0.2;
            el.vx *= 0.98;
            if (el.y > innerHeight - el.size) {
              el.y = innerHeight - el.size;
              el.vy *= -0.4;
            }
          } else {
            el.phase += 0.01;
            el.vx += Math.sin(el.phase) * 0.01;
            el.vy += Math.cos(el.phase) * 0.01;
            el.vx *= 0.99;
            el.vy *= 0.99;
            
            // Mouse repulsion
            const dx = el.x - mouseX;
            const dy = el.y - mouseY;
            const dist = Math.sqrt(dx*dx + dy*dy);
            if(dist < 150) {
              const force = (150 - dist) / 150;
              el.vx += (dx/dist) * force * 2;
              el.vy += (dy/dist) * force * 2;
            }
          }
          
          el.x += el.vx;
          el.y += el.vy;
          el.rotation += el.rv;
          
          // Wrap around if not in gravity mode
          if(!isGravityOn) {
            if(el.x < -el.size) el.x = innerWidth;
            if(el.x > innerWidth) el.x = -el.size;
            if(el.y < -el.size) el.y = innerHeight;
            if(el.y > innerHeight) el.y = -el.size;
          }

          el.dom.style.transform = \`translate3d(\${el.x}px, \${el.y}px, 0) rotate(\${el.rotation}deg)\`;
        });
        requestAnimationFrame(update);
      }

      window.addEventListener('mousemove', (e) => {
        mouseX = e.clientX;
        mouseY = e.clientY;
      });

      toggleBtn.addEventListener('click', () => {
        isGravityOn = !isGravityOn;
        toggleText.innerText = isGravityOn ? 'Floating back...' : 'Toggle Gravity';
        if(!isGravityOn) {
          elements.forEach(el => {
            el.vx = (Math.random() - 0.5) * 2;
            el.vy = (Math.random() - 0.5) * 5;
          });
        }
      });

      createElements();
      update();
    })();
  </script>
</body>
</html>`;
        fs.writeFileSync(indexPath, html, 'utf8');
        console.log('      Done.');

        console.log('\n==============================================');
        console.log(' ALL DONE! Open http://localhost:8080');
        console.log('==============================================');

    } catch (err) {
        console.error('ERROR:', err);
        process.exit(1);
    }
})();

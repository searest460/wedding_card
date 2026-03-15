const fs = require('fs');
const content = fs.readFileSync('assets/index-BBIwAgSn.js', 'utf8');

const components = ['O$', 'M$', '\\$\\$', 'V$', 'U$', 'DV', 'LV'];
components.forEach(comp => {
  const regex = new RegExp(`${comp}=(?:[^=]*?)=>`, 'g');
  let match;
  console.log(`--- ${comp} ---`);
  while ((match = regex.exec(content)) !== null) {
    const start = match.index;
    const snippet = content.substring(start, start + 500);
    console.log(snippet);
    console.log('---');
  }
});

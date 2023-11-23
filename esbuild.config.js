require('esbuild').build({
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  outfile: 'app/assets/builds/application.js', // この行を修正
}).catch(() => process.exit(1));
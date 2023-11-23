require('esbuild').build({
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  outfile: 'app/assets/builds/application.js',
}).catch(() => process.exit(1));
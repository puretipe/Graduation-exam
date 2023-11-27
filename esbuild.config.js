const esbuild = require('esbuild');

esbuild.build({
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  outfile: 'app/assets/builds/application.js',
  globalName: 'jQuery',
  format: 'iife'
}).catch(() => process.exit(1));
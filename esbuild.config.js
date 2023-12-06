const esbuild = require('esbuild');

esbuild.build({
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  outfile: 'app/assets/builds/application.js',
  format: 'iife',
  loader: {
    '.png': 'file'
  },
}).catch(() => process.exit(1));

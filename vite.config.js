import { defineConfig } from 'vite';

export default defineConfig({
  server: {
    host: '127.0.0.1',
    port: 5173,
    strictPort: true,
    watch: {
      ignored: [
        '**/.git/**',
        '**/source/**',
        '**/source/knowyourknot-binweevils/**'
      ]
    },
    fs: {
      deny: [
        'source',
        'source/**',
        'source/knowyourknot-binweevils/**'
      ]
    }
  },
  optimizeDeps: {
    entries: ['index.html']
  }
});

import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 4174,
    host: true,
    strictPort: true  // WICHTIG: Verhindert Ausweichen auf anderen Port
  },
  preview: {
    port: 4174,
    host: true,
    strictPort: true
  }
})
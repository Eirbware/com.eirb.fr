import { defineConfig } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";

// https://vite.dev/config/
export default defineConfig({
  root: "./src",
  server: {
    port: 3000,
    strictPort: true,
  },
  resolve: {
    alias: {
      "@": "/src",
    },
  },
  plugins: [svelte()],
  build: {
    manifest: true,
    rollupOptions: {
      input: '/main.ts'
    }
  }
});

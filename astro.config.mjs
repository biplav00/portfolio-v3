import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://biplavsubedi.com.np',
  output: 'static',
  server: {
    port: 4321,
  },
  integrations: [mdx(), sitemap()],
});

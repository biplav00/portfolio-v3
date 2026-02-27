import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';

export default defineConfig({
  output: 'static',
  server: {
    port: 4321,
  },
  integrations: [mdx()],
});

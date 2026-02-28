import { getCollection } from 'astro:content';
import rss from '@astrojs/rss';
import type { APIContext } from 'astro';

export async function GET(context: APIContext) {
  const posts = await getCollection('posts', ({ data }) => !data.draft);

  const site = context.site ?? new URL('https://biplavsubedi.com.np');

  return rss({
    title: 'Biplav Subedi - Blog',
    description:
      'Technical blog about QA engineering, testing best practices, and software quality',
    site,
    items: posts
      .sort((a, b) => b.data.publishDate.valueOf() - a.data.publishDate.valueOf())
      .map((post) => ({
        title: post.data.title,
        pubDate: post.data.publishDate,
        description: post.data.description,
        link: `/blog/${post.slug}/`,
      })),
  });
}

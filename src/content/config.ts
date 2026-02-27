import { defineCollection, z } from 'astro:content';

const posts = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    publishDate: z.coerce.date(),
    updatedDate: z.coerce.date().optional(),
    tags: z.array(z.string()).optional(),
    coverImage: z.string().optional(),
    draft: z.boolean().default(false),
  }),
});

const about = defineCollection({
  type: 'data',
});

export const collections = { posts, about };

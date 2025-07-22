// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	integrations: [
		starlight({
			title: 'financial_chart',
			social: [{ 
				icon: 'github', label: 'GitHub', href: 'https://github.com/cjjapan/financial_chart' 
			}, { 
				icon: 'seti:dart', label: 'Pub.dev', href: 'https://pub.dev/packages/financial_chart' 
			}
		],
			sidebar: [
				{
					label: 'Guides',
					items: [
						// Each item here is one entry in the navigation menu.
						{ label: 'Getting started', slug: 'guides/01_start' },
					],
				},
				{
					label: 'Reference',
					autogenerate: { directory: 'reference' },
				},
			],
		}),
	],
});

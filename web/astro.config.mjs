// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

const GITHUB = 'https://github.com/taynotfound/BoykisserLinux';

export default defineConfig({
	site: 'https://boykisser.taymaerz.de',
	trailingSlash: 'always',
	integrations: [
		starlight({
			title: 'Boykisser Linux',
			description:
				'Docs for Boykisser Linux: a pink, daily-drivable Debian 13 distro with XFCE or KDE Plasma.',
			logo: { src: './src/assets/mascot.png', alt: '' },
			favicon: '/favicon.png',
			customCss: [
				'@fontsource-variable/fredoka',
				'@fontsource-variable/nunito',
				'@fontsource-variable/jetbrains-mono',
				'./src/styles/starlight.css',
			],
			social: [
				{ icon: 'github', label: 'GitHub', href: GITHUB },
				{ icon: 'discord', label: 'Discord', href: 'https://discord.gg/3ZpwE9PPfP' },
			],
			editLink: { baseUrl: `${GITHUB}/edit/main/web/` },
			lastUpdated: true,
			head: [
				{ tag: 'meta', attrs: { property: 'og:image', content: 'https://boykisser.taymaerz.de/og.png' } },
				{ tag: 'meta', attrs: { name: 'twitter:card', content: 'summary_large_image' } },
				{ tag: 'meta', attrs: { name: 'theme-color', content: '#ff5fa2' } },
			],
			sidebar: [
				{
					label: 'Start here',
					items: [
						'docs/getting-started',
						'docs/downloading',
						'docs/installation',
						'docs/after-install',
						'docs/old-hardware',
					],
				},
				{
					label: 'Using Boykisser',
					items: ['docs/boykisser-center', 'docs/apps', 'docs/gaming', 'docs/theming', 'docs/terminal-basics'],
				},
				{
					label: 'Reference',
					items: ['docs/cli', 'docs/boykisser-tools', 'docs/building'],
				},
				{
					label: 'Help',
					items: ['docs/troubleshooting', 'docs/faq'],
				},
			],
		}),
	],
});

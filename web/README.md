# Boykisser Linux website

The site at **[boykisser.taymaerz.de](https://boykisser.taymaerz.de)**: a landing page plus the docs.
Built with [Astro](https://astro.build/) and [Starlight](https://starlight.astro.build/).

```sh
npm install
npm run dev       # http://localhost:4321
npm run build     # static site in dist/
```

| Path | What |
| --- | --- |
| `src/pages/index.astro` | Landing page |
| `src/styles/landing.css` | Landing page styles |
| `src/scripts/landing.ts` | Latest-release info, screenshot tabs, easter eggs |
| `src/content/docs/docs/*.md` | Docs pages (served under `/docs/`) |
| `src/styles/starlight.css` | Pink theme for the docs |
| `astro.config.mjs` | Site config and the docs sidebar |
| `public/` | Favicon, social preview image, wallpaper thumbnails, old `docs.html` redirect |

Fonts are self-hosted through Fontsource, so the site makes no third-party requests
apart from the GitHub API call for the latest release.

## Deploying

Vercel builds this folder automatically. Project settings: **Root Directory** `web`,
framework preset **Astro** (build `npm run build`, output `dist`).

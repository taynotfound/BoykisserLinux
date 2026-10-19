// Landing page behaviour: live release info, screenshot tabs, the typing
// terminal, fade-ins and the kisses.

const REPO = 'taynotfound/BoykisserLinux';

type Asset = { name: string; size: number; browser_download_url: string };
type Release = { tag_name: string; published_at: string; html_url: string; body?: string; assets: Asset[] };

const gb = (bytes: number) => `${(bytes / 1024 ** 3).toFixed(1)} GB`;

/** Fill in the latest version, real sizes and Internet Archive links. The static
 *  links to the releases page keep working if GitHub is unreachable. */
async function loadRelease() {
	try {
		const res = await fetch(`https://api.github.com/repos/${REPO}/releases/latest`);
		if (!res.ok) return;
		const rel: Release = await res.json();

		const info = document.querySelector<HTMLElement>('[data-release]');
		if (info) {
			const date = new Date(rel.published_at).toLocaleDateString(undefined, { dateStyle: 'medium' });
			const link = Object.assign(document.createElement('a'), { href: rel.html_url, textContent: rel.tag_name });
			info.replaceChildren('Latest build ', link, ` · ${date}`);
			info.hidden = false;
		}

		const body = rel.body ?? '';
		const isos = body.match(/https:\/\/archive\.org\/download\/\S+?\.iso/g) ?? [];
		const torrents = body.match(/https:\/\/archive\.org\/download\/\S+?_archive\.torrent/g) ?? [];

		for (const card of document.querySelectorAll<HTMLElement>('[data-flavour]')) {
			const id = card.dataset.flavour!;
			const file = id === 'full' ? 'boykisser-linux-amd64.iso' : `boykisser-linux-${id}-amd64.iso`;
			const match = (u: string) => (id === 'full' ? !/netinstall|lite/.test(u) : u.includes(`-${id}`));

			const parts = rel.assets.filter((a) => a.name.startsWith(file));
			const size = parts.reduce((n, a) => n + a.size, 0);
			const sizeEl = card.querySelector<HTMLElement>('[data-size]');
			if (size && sizeEl) sizeEl.textContent = gb(size);

			const direct = card.querySelector<HTMLAnchorElement>('[data-direct]');
			const mirror = isos.find(match);
			const single = parts.length === 1 ? parts[0].browser_download_url : null;
			if (direct) direct.href = mirror ?? single ?? rel.html_url;

			const torrent = card.querySelector<HTMLAnchorElement>('[data-torrent]');
			const t = torrents.find(match);
			if (torrent && t) {
				torrent.href = t;
				torrent.hidden = false;
			}
		}
	} catch {
		/* offline or rate-limited: the static links still work */
	}
}

function initTabs() {
	const tabs = [...document.querySelectorAll<HTMLButtonElement>('[role="tab"]')];
	const select = (tab: HTMLButtonElement) => {
		for (const t of tabs) {
			const on = t === tab;
			t.setAttribute('aria-selected', String(on));
			t.tabIndex = on ? 0 : -1;
			document.getElementById(t.getAttribute('aria-controls')!)!.hidden = !on;
		}
	};
	tabs.forEach((tab, i) => {
		tab.addEventListener('click', () => select(tab));
		tab.addEventListener('keydown', (e) => {
			const step = e.key === 'ArrowRight' ? 1 : e.key === 'ArrowLeft' ? -1 : 0;
			if (!step) return;
			const next = tabs[(i + step + tabs.length) % tabs.length];
			select(next);
			next.focus();
		});
	});
}

/** Click anywhere for a little kiss; type "boykisser" (or tap the cat 7 times) for party mode. */
function initKisses() {
	if (reducedMotion()) return;
	// text faces or Font Awesome icons (paw, heart)
	const KISSES = [':3', ':3c', 'fa-paw', 'fa-heart', 'fa-heart'];

	const kiss = (x: number, y: number) => {
		const el = document.createElement('span');
		el.className = 'kiss';
		const k = KISSES[Math.floor(Math.random() * KISSES.length)];
		if (k.startsWith('fa-')) {
			const icon = document.createElement('i');
			icon.className = `fa-solid ${k}`;
			el.append(icon);
		} else {
			el.textContent = k;
		}
		el.style.left = `${x}px`;
		el.style.top = `${y}px`;
		document.body.append(el);
		el.addEventListener('animationend', () => el.remove());
	};

	document.addEventListener('click', (e) => {
		if ((e.target as Element).closest('a, button, summary')) return;
		kiss(e.clientX, e.clientY);
	});

	const party = () => {
		const on = document.body.classList.toggle('party');
		if (!on) return;
		const toast = document.createElement('div');
		toast.className = 'toast';
		toast.textContent = 'you found the secret!! party mode :3';
		document.body.append(toast);
		setTimeout(() => toast.remove(), 4000);
		for (let i = 0; i < 24; i++) {
			setTimeout(() => kiss(Math.random() * innerWidth, Math.random() * innerHeight), i * 90);
		}
	};

	let buffer = '';
	addEventListener('keydown', (e) => {
		if ((e.target as Element).matches('input, textarea')) return;
		buffer = (buffer + e.key.toLowerCase()).slice(-9);
		if (buffer === 'boykisser') {
			buffer = '';
			party();
		}
	});

	let taps = 0;
	let timer: ReturnType<typeof setTimeout>;
	document.querySelector('[data-cat]')?.addEventListener('click', () => {
		clearTimeout(timer);
		timer = setTimeout(() => (taps = 0), 1500);
		if (++taps >= 7) {
			taps = 0;
			party();
		}
	});
}

const reducedMotion = () => matchMedia('(prefers-reduced-motion: reduce)').matches;

/** The terminal types `boykisser`, then shows the output, once it scrolls into view. */
function initTerminal() {
	const term = document.querySelector<HTMLElement>('[data-terminal]');
	const typed = term?.querySelector<HTMLElement>('[data-typed]');
	if (!term || !typed || reducedMotion()) return;
	const text = typed.textContent ?? '';
	term.classList.add('typing');
	typed.textContent = '';
	const io = new IntersectionObserver((entries) => {
		if (!entries.some((e) => e.isIntersecting)) return;
		io.disconnect();
		let i = 0;
		const tick = () => {
			typed.textContent = text.slice(0, ++i);
			if (i < text.length) setTimeout(tick, 70 + Math.random() * 60);
			else setTimeout(() => term.classList.remove('typing'), 350);
		};
		setTimeout(tick, 400);
	}, { threshold: 0.4 });
	io.observe(term);
}

/** Fade sections in as they scroll into view (opacity only). */
function initReveal() {
	const items = document.querySelectorAll<HTMLElement>('.reveal');
	if (reducedMotion() || !('IntersectionObserver' in window)) {
		items.forEach((el) => el.classList.add('shown'));
		return;
	}
	const io = new IntersectionObserver((entries) => {
		for (const e of entries) {
			if (!e.isIntersecting) continue;
			e.target.classList.add('shown');
			io.unobserve(e.target);
		}
	}, { threshold: 0.15 });
	items.forEach((el) => io.observe(el));
}

export function initLanding() {
	initTabs();
	initTerminal();
	initReveal();
	initKisses();
	loadRelease();
}

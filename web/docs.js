// docs.js  -  renders markdown pages from docs/ into the docs shell
const PAGES = [
  { id: "getting-started",        title: "Getting started",            cat: "Setup" },
  { id: "downloading",            title: "Downloading & verifying",    cat: "Setup" },
  { id: "installation",           title: "Installing to disk",         cat: "Setup" },
  { id: "after-install",          title: "First steps after install",  cat: "Setup" },
  { id: "old-hardware",           title: "Old hardware",               cat: "Setup" },
  { id: "terminal-basics",        title: "Terminal basics",            cat: "Using Boykisser" },
  { id: "theming",                title: "Theming & customization",    cat: "Using Boykisser" },
  { id: "gaming",                 title: "Gaming",                     cat: "Using Boykisser" },
  { id: "presets-and-apps",       title: "Presets & apps",             cat: "Using Boykisser" },
  { id: "boykisser-cli",          title: "The boykisser CLI",          cat: "boykisser-tools" },
  { id: "boykisser-tools-install",title: "Installing boykisser-tools", cat: "boykisser-tools" },
  { id: "faq",                    title: "FAQ",                        cat: "Help" },
];

const nav = document.getElementById("docs-nav");
const content = document.getElementById("docs-content");

const currentPage = () => {
  const id = location.hash.replace(/^#\/?/, "");
  return PAGES.some((p) => p.id === id) ? id : PAGES[0].id;
};

function buildNav() {
  nav.innerHTML = "";
  const active = currentPage();
  let lastCat = null;
  for (const p of PAGES) {
    if (p.cat !== lastCat) {
      const h = document.createElement("span");
      h.className = "nav-category";
      h.textContent = p.cat;
      nav.appendChild(h);
      lastCat = p.cat;
    }
    const a = document.createElement("a");
    a.href = `#/${p.id}`;
    a.textContent = p.title;
    if (p.id === active) a.classList.add("active");
    nav.appendChild(a);
  }
}

async function loadPage() {
  const id = currentPage();
  buildNav();
  try {
    const res = await fetch(`docs/${id}.md`);
    if (!res.ok) throw new Error(res.status);
    const md = await res.text();
    content.innerHTML = DOMPurify.sanitize(marked.parse(md));
    document.title = `${PAGES.find((p) => p.id === id).title} · Boykisser Linux docs`;
    // copy buttons on code blocks, same as the landing page
    content.querySelectorAll("pre").forEach((pre) => {
      const btn = document.createElement("button");
      btn.className = "copy-btn";
      btn.textContent = "copy";
      btn.addEventListener("click", async () => {
        try {
          await navigator.clipboard.writeText(pre.querySelector("code")?.innerText ?? "");
          btn.textContent = "copied :3";
          btn.classList.add("copied");
          setTimeout(() => { btn.textContent = "copy"; btn.classList.remove("copied"); }, 1600);
        } catch { /* clipboard blocked */ }
      });
      pre.appendChild(btn);
    });
    scrollTo(0, 0);
  } catch {
    content.innerHTML = "<p>Couldn't load that page :(  -  try the <a href='#/getting-started'>getting started</a> guide.</p>";
  }
}

addEventListener("hashchange", loadPage);
loadPage();

// scroll progress bar
const progress = document.querySelector(".progress");
if (progress) {
  const update = () => {
    const max = document.documentElement.scrollHeight - innerHeight;
    progress.style.width = max > 0 ? `${(scrollY / max) * 100}%` : "0";
  };
  addEventListener("scroll", update, { passive: true });
  update();
}

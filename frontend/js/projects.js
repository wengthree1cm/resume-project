const PROJECTS = [
  {
    title: "Scuba Dives 日志平台",
    slug: "scuba-dives",
    cover: "./assets/dive.png",
    desc: "记录潜点、海况、能见度与潜伴，前端 Leaflet 地图选点，后端 FastAPI + PostgreSQL，部署在 Render。",
    tech: ["FastAPI", "PostgreSQL", "Leaflet", "Render", "CORS"],
    links: {
      demo: "https://scuba-dives-page.onrender.com",
      code: "https://github.com/yourname/scuba-dives"
    }
  },
  {
    title: "Resume Project",
    slug: "resume-project",
    cover: "./assets/resume.png",
    desc: "工业级数据流水线 + FastAPI 推理服务，加入特征工程、模型版本管理与 A/B 评估。",
    tech: ["Python", "XGBoost", "FastAPI", "Optuna", "Docker"],
    links: {
      demo: "https://d142g2ii1hj9c0.cloudfront.net/",
      code: "https://github.com/wengthree1cm/resume-project"
    }
  }
];

const grid = document.getElementById("grid");
const modal = document.getElementById("modal");
const modalImg = document.getElementById("modalImg");
const modalTitle = document.getElementById("modalTitle");
const modalDesc = document.getElementById("modalDesc");
const modalTags = document.getElementById("modalTags");
const modalLinks = document.getElementById("modalLinks");

function renderCards(list){
  grid.innerHTML = "";
  list.forEach(p => {
    const card = document.createElement("article");
    card.className = "card";
    card.setAttribute("data-slug", p.slug);

    const img = document.createElement("img");
    img.className = "card__cover";
    img.src = p.cover || "";
    img.alt = p.title;
    img.loading = "lazy";

    const body = document.createElement("div");
    body.className = "card__body";

    const title = document.createElement("h3");
    title.className = "card__title";
    title.textContent = p.title;

    const desc = document.createElement("p");
    desc.className = "card__desc";
    desc.textContent = p.desc;

    const chips = document.createElement("div");
    chips.className = "chips";
    (p.tech||[]).forEach(t => {
      const chip = document.createElement("span");
      chip.className = "chip";
      chip.textContent = t;
      chips.appendChild(chip);
    });

    body.appendChild(title);
    body.appendChild(desc);
    body.appendChild(chips);

    card.appendChild(img);
    card.appendChild(body);

    card.addEventListener("click", () => openModal(p));
    grid.appendChild(card);
  });
}

function openModal(p){
  modalImg.src = p.cover || "";
  modalTitle.textContent = p.title;
  modalDesc.textContent = p.desc;

  modalTags.innerHTML = "";
  (p.tech||[]).forEach(t => {
    const chip = document.createElement("span");
    chip.className = "chip";
    chip.textContent = t;
    modalTags.appendChild(chip);
  });

  modalLinks.innerHTML = "";
  if(p.links?.demo){
    const a = document.createElement("a");
    a.href = p.links.demo;
    a.target = "_blank";
    a.rel = "noopener";
    a.className = "btn";
    a.textContent = "Live Demo";
    modalLinks.appendChild(a);
  }
  if(p.links?.code){
    const a = document.createElement("a");
    a.href = p.links.code;
    a.target = "_blank";
    a.rel = "noopener";
    a.className = "btn";
    a.textContent = "Source Code";
    modalLinks.appendChild(a);
  }

  modal.setAttribute("aria-hidden", "false");
}

function closeModal(){ modal.setAttribute("aria-hidden", "true"); }
modal.addEventListener("click", (e) => { if(e.target.hasAttribute("data-close")) closeModal(); });
document.addEventListener("keydown", (e) => { if(e.key === "Escape") closeModal(); });

renderCards(PROJECTS);

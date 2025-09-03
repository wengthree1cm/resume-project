// 配置你的项目数据（按需增删改）
const PROJECTS = [
  {
    title: "Scuba Dives 日志平台",
    slug: "scuba-dives",
    cover: "./assets/projects/dive.png",
    desc: "记录潜点、海况、能见度与潜伴，前端 Leaflet 地图选点，后端 FastAPI + PostgreSQL，部署在 Render。",
    tech: ["FastAPI", "PostgreSQL", "Leaflet", "Render", "CORS"],
    links: {
      demo: "https://scuba-dives-page.onrender.com",
      code: "https://github.com/yourname/scuba-dives"
    }
  },
  {
    title: "客户流失预测（Churn ML）",
    slug: "churn-ml",
    cover: "./assets/projects/churn_cover.jpg",
    desc: "工业级数据流水线 + FastAPI 推理服务，加入特征工程、模型版本管理与 A/B 评估。",
    tech: ["Python", "XGBoost", "FastAPI", "Optuna", "Docker"],
    links: {
      demo: "#",
      code: "https://github.com/yourname/churn-ml"
    }
  },
  {
    title: "ECG 向量嵌入研究",
    slug: "ecg-emb",
    cover: "./assets/projects/ecg_cover.jpg",
    desc: "探索 CLOCS/PCLR 等自监督算法在 ECG 表征学习中的偏倚与公平性。",
    tech: ["PyTorch", "CLOCS", "PCLR", "Bias Mitigation"],
    links: {
      demo: "#",
      code: "#"
    }
  },
  {
    title: "Popularity Bias in Recommenders",
    slug: "pop-bias",
    cover: "./assets/projects/reco_cover.jpg",
    desc: "缓解电商推荐的流行度偏差，兼顾公平曝光与用户参与度。",
    tech: ["Python", "RecSys", "Two-Sided Fairness"],
    links: {
      demo: "#",
      code: "#"
    }
  }
];

// 渲染卡片
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

// 初始渲染
renderCards(PROJECTS);

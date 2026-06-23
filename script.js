const menuBtn = document.querySelector("#menuBtn");
const navLinks = document.querySelector("#navLinks");
const themeBtn = document.querySelector("#themeBtn");
const contactForm = document.querySelector("#contactForm");
const formMessage = document.querySelector("#formMessage");

if (menuBtn && navLinks) {
  menuBtn.addEventListener("click", () => {
    navLinks.classList.toggle("open");
  });
}

document.querySelectorAll(".nav-links a").forEach((link) => {
  link.addEventListener("click", () => {
    navLinks.classList.remove("open");
  });
});

if (themeBtn) {
  const savedTheme = localStorage.getItem("theme");

  if (savedTheme === "dark") {
    document.body.classList.add("dark");
    themeBtn.textContent = "☀️";
  }

  themeBtn.addEventListener("click", () => {
    document.body.classList.toggle("dark");

    const isDark = document.body.classList.contains("dark");
    themeBtn.textContent = isDark ? "☀️" : "🌙";

    localStorage.setItem("theme", isDark ? "dark" : "light");
  });
}

const revealElements = document.querySelectorAll(".reveal");

const revealOnScroll = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("visible");
      }
    });
  },
  {
    threshold: 0.15,
  }
);

revealElements.forEach((element) => {
  revealOnScroll.observe(element);
});

const counters = document.querySelectorAll("[data-count]");
let countersStarted = false;

function animateCounters() {
  if (countersStarted) return;

  const statsSection = document.querySelector(".stats");

  if (!statsSection) return;

  const statsTop = statsSection.getBoundingClientRect().top;

  if (statsTop < window.innerHeight - 80) {
    countersStarted = true;

    counters.forEach((counter) => {
      const target = Number(counter.dataset.count);
      const duration = 850;
      const startTime = performance.now();

      function updateCounter(currentTime) {
        const progress = Math.min((currentTime - startTime) / duration, 1);
        const value = Math.floor(progress * target);

        counter.textContent = value;

        if (progress < 1) {
          requestAnimationFrame(updateCounter);
        } else {
          counter.textContent = target;
        }
      }

      requestAnimationFrame(updateCounter);
    });
  }
}

window.addEventListener("scroll", animateCounters);
window.addEventListener("load", animateCounters);

if (contactForm && formMessage) {
  contactForm.addEventListener("submit", (event) => {
    event.preventDefault();

    const nameInput = document.querySelector("#name");
    const name = nameInput.value.trim() || "toi";

    formMessage.textContent = `Merci ${name}, ton message a bien été simulé ✅`;

    contactForm.reset();

    setTimeout(() => {
      formMessage.textContent = "";
    }, 4500);
  });
}

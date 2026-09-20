// Toggles `.nav-toggle`'s `aria-expanded` in mobile, as this can't be done in CSS. 
document.querySelectorAll(".nav-toggle").forEach((toggle) => {
  toggle.addEventListener("click", () => {
    const open = toggle.getAttribute("aria-expanded") === "true";
    toggle.setAttribute("aria-expanded", String(!open));
  });
});

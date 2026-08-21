// Toggles `.nav-toggle`'s `aria-expanded`, nothing else. Every visual change —
// the bars morphing into a cross, `.site-nav` sliding down — is a CSS rule
// reading that one attribute (see style.css), so there is only one piece of
// state to keep in step.
document.querySelectorAll(".nav-toggle").forEach((toggle) => {
  toggle.addEventListener("click", () => {
    const open = toggle.getAttribute("aria-expanded") === "true";
    toggle.setAttribute("aria-expanded", String(!open));
  });
});

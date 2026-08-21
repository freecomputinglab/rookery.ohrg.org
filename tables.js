// Copies each column's `<th>` onto that column's cells as `data-label`, so a
// cell can print its own label once the header row is gone.
//
// Below 600px every table on this site stops being a grid and becomes one card
// per row (see the Responsive section in style.css), which hides `<thead>` —
// and with it the only thing saying which column a value came from. Typst's
// html export does write a real `<thead>`, so the labels are already in the
// document; this puts them where a stacked cell can reach them, and the CSS
// prints them with `attr(data-label)`.
//
// Progressive enhancement: with this script blocked the stack still reads,
// one cell per line, minus the labels. Nothing here has a desktop effect.
document.querySelectorAll("table").forEach((table) => {
  const labels = [...table.querySelectorAll("thead th")].map((th) =>
    th.textContent.trim(),
  );
  if (labels.length === 0) return;

  table.querySelectorAll("tbody tr").forEach((row) => {
    [...row.children].forEach((cell, i) => {
      if (labels[i]) cell.setAttribute("data-label", labels[i]);
    });
  });
});

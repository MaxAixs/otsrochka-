/* Shared offline storage for Otsrochka+ PWA (demo data only). */
(function (global) {
  const KEY = "otsrochka.person.v1";

  function savePerson(person) {
    global.localStorage.setItem(KEY, JSON.stringify(person));
  }

  function loadPerson() {
    const raw = global.localStorage.getItem(KEY);
    if (!raw) {
      return null;
    }
    try {
      return JSON.parse(raw);
    } catch {
      return null;
    }
  }

  function clearPerson() {
    global.localStorage.removeItem(KEY);
  }

  function fullName(person) {
    return [person.lastName, person.firstName, person.patronymic]
      .filter(Boolean)
      .join(" ");
  }

  function registerServiceWorker() {
    if ("serviceWorker" in navigator) {
      navigator.serviceWorker.register("./sw.js").catch((error) => {
        console.warn("SW registration failed:", error);
      });
    }
  }

  function paintRibbon(elementId) {
    const ribbon = document.getElementById(elementId);
    if (ribbon) {
      const date = new Date().toLocaleDateString("uk-UA", { dateStyle: "long" });
      ribbon.textContent = `Документи оновлено: ${date}`;
    }
  }

  function formatDateUA(isoDate) {
    if (!isoDate) {
      return "—";
    }
    const parsed = new Date(isoDate + "T00:00:00");
    if (Number.isNaN(parsed.getTime())) {
      return "—";
    }
    return parsed.toLocaleDateString("uk-UA", { day: "2-digit", month: "2-digit", year: "numeric" });
  }

  function formatTimeUA(date) {
    return date.toLocaleTimeString("uk-UA", { hour: "2-digit", minute: "2-digit" });
  }

  /// Builds the live ticker text: "Документ оновлено о HH:MM | DD.MM.YYYY • ".
  function tickerText(now) {
    return `Документ оновлено о ${formatTimeUA(now)} | ${formatDateUA(
      now.getFullYear() + "-" + String(now.getMonth() + 1).padStart(2, "0") + "-" + String(now.getDate()).padStart(2, "0")
    )} • `;
  }

  global.Otsrochka = { savePerson, loadPerson, clearPerson, fullName, registerServiceWorker, paintRibbon, formatDateUA, formatTimeUA, tickerText };
})(window);

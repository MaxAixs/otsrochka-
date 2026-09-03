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

  global.Otsrochka = { savePerson, loadPerson, clearPerson, fullName, registerServiceWorker, paintRibbon };
})(window);

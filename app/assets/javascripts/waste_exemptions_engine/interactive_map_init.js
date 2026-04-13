// Initialize the interactive map on the site grid reference page.
// All map logic is in the defra_ruby_map gem (DefraMap.init).

(function () {
  "use strict";

  function init() {
    var container = document.getElementById("interactive-map-container");
    if (!container || typeof DefraMap === "undefined") { return; }

    DefraMap.init(container, {
      mapLabel: "Select waste activity location",
      gridRefFieldId: "site-grid-reference-form-grid-reference-field"
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();

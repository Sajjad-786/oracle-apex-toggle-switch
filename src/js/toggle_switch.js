/* ======================================================================
   S&H Software Solutions
   Segmented Toggle Switch - Oracle APEX Item Plugin
   ----------------------------------------------------------------------
   Component : Client-side behavior
   Version   : 1.1.0
   Date      : 2026-07-31
   Author    : S&H Software Solutions
   License   : MIT License. This code is free and open to use, modify,
               and redistribute, with or without attribution, for
               personal or commercial projects.
   ----------------------------------------------------------------------
   Namespace "shToggleSwitch" to avoid global scope conflicts.
   All DOM lookups use defensive checks so a missing element never
   throws an unhandled error that could block APEX's onload queue.
   ====================================================================== */

var shToggleSwitch = {

  init: function (pElementId, pSegmentCount) {
    var container = document.getElementById(pElementId + "_SH_SWITCH");
    if (!container) {
      console.warn("shToggleSwitch: container not found for " + pElementId);
      return;
    }

    var hiddenInput = document.getElementById(pElementId);
    var knob         = container.querySelector(".sh-tgl-knob");
    var segments     = container.querySelectorAll(".sh-tgl-segment");

    if (!hiddenInput || !knob || segments.length === 0) {
      console.warn("shToggleSwitch: incomplete markup for " + pElementId);
      return;
    }

    var segmentWidthPct = 100 / pSegmentCount;

    function moveKnobTo(pIndex) {
      knob.style.width     = "calc(" + segmentWidthPct + "% - " + (pIndex === 0 ? 2 : 1) + "px)";
      knob.style.transform = "translateX(" + (pIndex * 100) + "%)";
    }

    function setActive(pIndex) {
      segments.forEach(function (seg, i) {
        seg.classList.toggle("sh-tgl-segment--active", i === pIndex);
      });
      moveKnobTo(pIndex);
    }

    // Creates a short-lived ripple element at the click position,
    // purely cosmetic, auto-removed after the CSS animation ends.
    function spawnRipple(pSegment, pEvent) {
      var rect = pSegment.getBoundingClientRect();
      var size = Math.max(rect.width, rect.height);
      var ripple = document.createElement("span");

      ripple.className = "sh-tgl-ripple";
      ripple.style.width  = size + "px";
      ripple.style.height = size + "px";
      ripple.style.left   = (pEvent.clientX - rect.left - size / 2) + "px";
      ripple.style.top    = (pEvent.clientY - rect.top - size / 2) + "px";

      pSegment.appendChild(ripple);

      ripple.addEventListener("animationend", function () {
        ripple.remove();
      });
    }

    // Initial state: find the segment marked active by PL/SQL.
    // Fallback to the first segment if no value matched yet.
    var initialIndex = -1;
    segments.forEach(function (seg, i) {
      if (seg.classList.contains("sh-tgl-segment--active")) { initialIndex = i; }
    });

    if (initialIndex === -1) {
      initialIndex = 0;
      hiddenInput.value = segments[0].getAttribute("data-value");
      segments[0].classList.add("sh-tgl-segment--active");
    }

    moveKnobTo(initialIndex);

    // Track whether the user is navigating via keyboard, so the
    // focus ring only appears for keyboard users, not mouse clicks.
    container.addEventListener("mousedown", function () {
      container.classList.remove("sh-tgl-using-keyboard");
    });

    container.addEventListener("keydown", function (pEvent) {
      if (pEvent.key === "Tab") {
        container.classList.add("sh-tgl-using-keyboard");
      }
    });

    // Click handler per segment: updates value, moves knob, fires
    // ripple effect, and dispatches a native change event so APEX
    // session state and Dynamic Actions pick up the new value.
    segments.forEach(function (seg, i) {
      seg.addEventListener("click", function (pEvent) {
        hiddenInput.value = seg.getAttribute("data-value");
        setActive(i);
        spawnRipple(seg, pEvent);

        hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
      });

      // Keyboard accessibility: Enter/Space also triggers the segment
      seg.addEventListener("keydown", function (pEvent) {
        if (pEvent.key === "Enter" || pEvent.key === " ") {
          pEvent.preventDefault();
          seg.click();
        }
      });
    });
  }

};

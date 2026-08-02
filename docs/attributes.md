# ⚙️ Attributes

This page documents every attribute of the **Toggle Switch** item plug-in — what it does, what values it accepts, and how it behaves when left empty.

---

## 📋 Overview

| # | Attribute | Type | Required | Default |
|---|-----------|------|----------|---------|
| 1 | 🎨 Background color | Text | No | `#eef0f3` |
| 2 | 🔘 Toggle color | Text | No | `#3a6df0` |
| 3 | 🖌️ Border color | Text | No | `rgba(0,0,0,0.08)` |
| 4 | 📏 Border thickness | Number | No | `1` |

All attributes are optional. If an attribute is left empty, the default value shown above is applied automatically, so the plug-in works out of the box without any configuration.

---

## 🎨 Background color

**Type:** Text · **Default:** `#eef0f3`

Sets the color of the switch track — the rounded bar the sliding knob moves inside. This is the color visible behind the segments that are *not* currently selected.

Accepts any valid CSS color value:

| Format | Example |
|--------|---------|
| Hex | `#eef0f3` |
| Hex (short) | `#eee` |
| RGB | `rgb(238, 240, 243)` |
| RGBA | `rgba(238, 240, 243, 0.8)` |
| Named color | `whitesmoke` |

**Tip:** Pick a light, low-contrast color here. The track sits behind the inactive segment labels, so a strong color makes those labels hard to read.

---

## 🔘 Toggle color

**Type:** Text · **Default:** `#3a6df0`

Sets the color of the sliding knob — the filled shape that moves to mark the selected segment. The label of the active segment is rendered in white on top of it, so this should be a color with enough contrast against white text.

The knob also carries a subtle light gradient overlay and a drop shadow, both defined in the stylesheet. These adapt automatically to whatever base color is set here.

**Tip:** This is usually your application's primary or accent color. Very light colors will make the active label unreadable, since that label is always white.

---

## 🖌️ Border color

**Type:** Text · **Default:** `rgba(0,0,0,0.08)`

Sets the color of the outer border drawn around the switch track. Accepts the same color formats as the two attributes above.

The default is a barely visible translucent black, which works on both light and dark backgrounds. Set a solid color here if you want the switch to have a clearly defined outline.

**Note:** This has no visible effect if **Border thickness** is set to `0`.

---

## 📏 Border thickness

**Type:** Number · **Default:** `1`

Sets the border width in pixels.

| Value | Result |
|-------|--------|
| `0` | No border at all |
| `1` | Hairline border (default) |
| `2`–`4` | Clearly visible outline |
| `5`+ | Heavy frame, mostly decorative |

**Range:** Values are clamped server-side to `0`–`99`. Anything below `0` becomes `0`, anything above `99` becomes `99`, so an accidental typo can never break the layout.

---

## 📐 Sizing

Sizing is **not** controlled through custom attributes. The plug-in follows the standard APEX item **Width** setting under *Appearance*, exactly like a built-in item does:

| APEX Width setting | Switch width | Switch height |
|--------------------|--------------|---------------|
| Default | 200px | 34px |
| Large | 300px | 42px |
| X-Large | 400px | 50px |
| Stretch | 100% of the container | 34px |

Font size scales with the larger sizes so the labels stay proportional.

**Why height scales too:** Native APEX items only change width across these settings. This plug-in deliberately scales height as well, because a wide but thin segmented switch looks visually unbalanced at larger widths. Stretch is the exception — it grows only in width, since a full-width switch that is also taller would look oversized.

---

## 🗂️ List of Values

The switch renders **one segment per LOV entry**. This is not an attribute but a standard APEX item setting, and it is what makes the plug-in flexible.

Both LOV types are supported:

**Static values**

```
STATIC:One-Time Login;NO,Remember 1 Year;YES
```

**SQL query**

```sql
SELECT coca_name AS d
     , coca_id   AS r
  FROM course_category
 WHERE coca_active_yn = 'YES'
   AND coca_deleted_yn = 'NO'
 ORDER BY coca_name
```

The first column is the **display value** (the label shown inside the segment) and the second is the **return value** (what gets stored in session state).

**Practical limit:** There is no hard cap on the number of segments, but the switch width is fixed per size setting, so each additional entry gets a narrower share of it. Labels that no longer fit are truncated with an ellipsis. Two to four segments work comfortably at Default width; beyond that, use a larger width setting or shorter labels.

---

## 💾 Value handling

The selected return value is stored in a hidden input and submitted like any other page item. It is available in session state as `:P1_MY_ITEM` and can be used in processes, validations, computations and Dynamic Actions without any special handling.

When the item has no value yet — for example on a new record where no default was set — the plug-in selects the **first segment** and writes its return value into session state. This avoids a state where the switch appears to have a selection visually but submits an empty value.

Changing the selection fires a native `change` event, so Dynamic Actions bound to the item's *Change* event work as expected.

---

## ♿ Accessibility

- Each segment is reachable via **Tab** and can be activated with **Enter** or **Space**
- A focus outline is shown for keyboard navigation and suppressed for mouse clicks, so the ring never lingers after a click
- Segments carry `role="button"` so assistive technology announces them as interactive

---

## 🎯 Configuration examples

**Minimal — everything left at defaults**

Create the item, set the LOV, done. The switch renders in the default blue-on-light-gray scheme.

**Brand colors**

| Attribute | Value |
|-----------|-------|
| Background color | `#f5f0f2` |
| Toggle color | `#8b1e3f` |
| Border color | `#8b1e3f` |
| Border thickness | `1` |

**Borderless, flat look**

| Attribute | Value |
|-----------|-------|
| Background color | `#e8e8e8` |
| Toggle color | `#2d2d2d` |
| Border color | *(leave empty)* |
| Border thickness | `0` |

**High-contrast, strong outline**

| Attribute | Value |
|-----------|-------|
| Background color | `#ffffff` |
| Toggle color | `#0a5c36` |
| Border color | `#0a5c36` |
| Border thickness | `3` |
---

## 📄 About

**Toggle Switch** — an item plug-in for Oracle APEX.

| | |
|---|---|
| Author | Sajjad Hanifa |
| Vendor | S&H Software Solutions |
| Version | 1.0.0 |
| License | [MIT](../LICENSE) |
| Repository | [oracle-apex-toggle-switch](https://github.com/Sajjad-786/oracle-apex-toggle-switch) |

Found a bug or have a suggestion? Open an [issue](https://github.com/Sajjad-786/oracle-apex-toggle-switch/issues).

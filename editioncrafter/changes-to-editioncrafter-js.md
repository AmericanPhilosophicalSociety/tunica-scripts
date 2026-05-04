This file preserves some notes on changes I made to EditionCrafter's minimized JS file while trying to add/remove/change particular features in the viewer. This took some trial and error because most of the function names are arbitrary letters and aren't documented, so I figured this out by searching CSS class/ID names and text appearing in particular elements that I wanted to change.

I wish I'd documented this more systematically, but here we are. Some of this info is probably also tracked in the Git repo for the Tunica site, or can be figured out by comparing the Tunica site's version of EditionCrafter's JS to the official one.

---

Removed and put back:

```
Ee.jsx(o0, { primary: "Toggle XML Mode" }),
  function WP(e) {
    return Ee.jsx("button", {
      className: `toggle-button ${e.active ? "active" : ""}`,
      onClick: e.onClick,
      title: "Toggle XML Mode",
      type: "button",
      children: Ee.jsx(e.icon, {}),
    });
  }
```

Removed and it successfully got rid of the Toggle XML Mode button:

```
Ee.jsx(WP, {
              onClick: K,
              active: e.documentView[e.side].isXMLMode,
              icon: Tj,
            }),
```


Remove this to get rid of Folio Help, probably:

```
Ee.jsxs("button", {
  title: "Toggle folio help",
  className: `toggle-button ${o ? "active" : ""}`,
  onClick: F,
  ref: x,
  type: "button",
  children: [
    Ee.jsx(Cj, {}),
    Ee.jsx(Rj, {
      marginStyle: Le,
      anchorEl: x.current,
      open: o,
      onClose: F,
    }),
```

Took this out then put it back because removing it broke everything:

```
Ee.jsxs("div", {
  className: "toolbar-side toolbar-right",
  children: [
    Ee.jsxs("div", {
      className: "book-mode-toggles",
      title: "Toggle book mode",
      onClick: ae,
      children: [
        Ee.jsx("button", {
          className: e.documentView.bookMode
            ? "selected"
            : "",
          type: "button",
          children: Ee.jsx(xJ, {}),
        }),
        Ee.jsx("button", {
          className: e.documentView.bookMode
            ? ""
            : "selected",
          type: "button",
          children: Ee.jsx(CJ, {}),
        }),
      ],
    }),
```

You can change the display names of layers with this bit of the code:

```
Eb.transcriptionTypeLabels = {
    f: "Facsimile",
    glossary: "Glossary",
    notes: "Table of Contents",
  };
```

Change display text with:

```
function Rj(e)
```

Get rid of ? icon by commenting out:

```
  !We &&
  Ee.jsx("div", { className: "vertical-separator" }),
  te &&
    Ee.jsx(WP, { active: g, onClick: H, icon: kj }),
  Ee.jsxs("button", {
    title: "Toggle folio help",
    className: `toggle-button ${o ? "active" : ""}`,
    onClick: F,
    ref: x,
    type: "button",
    children: [
      Ee.jsx(Cj, {}),
      Ee.jsx(Rj, {
        marginStyle: Le,
        anchorEl: x.current,
        open: o,
        onClose: F,
      }),
    ],
  }),
```


Getting rid of this doesn't do anything:

```
Ee.jsxs(pb, {
  children: [
    Ee.jsx("span", { className: "fa fa-lock" }),
    Ee.jsx(o0, { primary: "Toggle Sync Views" }),
  ],
}),
Ee.jsxs(pb, {
  children: [
    Ee.jsx("span", { className: "fa fa-book" }),
    Ee.jsx(o0, { primary: "Toggle Book Mode" }),
  ],
}),
```


This got rid of lock mode:

```
Ee.jsxs("label", {
    className: "lockmode-container",
    children: [
    Ee.jsx("input", {
        onChange: oe,
        title: "Toggle coordination of views",
        type: "checkbox",
        value: e.documentView.linkedMode,
    }),
    Ee.jsx("span", {
        className: "switch",
        children: Ee.jsx("span", {
        className: "slider",
        children: Ee.jsx(TJ, {}),
        }),
    }),
    ],
}),
```

I can't remember what this text was but I'm guessing it's related to lock mode:

```
Scroll: "ScrollLock",

lockEnabled

.fa.fa-lock,.editioncrafter .fa.fa-lock-open{border-radius:max(2rem,32px)

.lockmode-container

if (!r.disableScrollLock)
```

This got rid of book mode:

```
Ee.jsxs("div", {
  className: "toolbar-side toolbar-right",
  children: [
    Ee.jsxs("div", {
      className: "book-mode-toggles",
      title: "Toggle book mode",
      onClick: ae,
      children: [
        Ee.jsx("button", {
          className: e.documentView.bookMode
            ? "selected"
            : "",
          type: "button",
          children: Ee.jsx(xJ, {}),
        }),
        Ee.jsx("button", {
          className: e.documentView.bookMode
            ? ""
            : "selected",
          type: "button",
          children: Ee.jsx(CJ, {}),
        }),
      ],
    }),
```
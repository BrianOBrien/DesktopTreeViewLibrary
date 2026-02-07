# DesktopTreeViewLibrary API

## Overview
DesktopTreeViewLibrary provides a pixel-scrolling TreeView for Xojo Desktop.
It consists of:
- DesktopTreeViewCntrl (ContainerControl): owns scrollbar and layout
- XojoTreeView (Canvas-based control): owns rendering, hit-testing, row rebuilding, and scroll physics

This file documents the **current cleaned API** only.

---

## Public API (v1.0)

### XojoTreeView

#### BeginUse(rootTree As Dictionary, levelSpec As Dictionary, host As Object)
Bind the tree view to its data and host. This is a one-time operation.

#### Update()
Call after mutating the bound tree structure to rebuild rows and refresh display.

#### SetScrollY(y As Integer)
Set vertical scroll position in **pixels**. Value is clamped internally.

#### MaxScrollY() As Integer
Returns the maximum legal scroll position in pixels for the current content.

---

## Callbacks

### ScrollChanged
Emitted when the tree scroll position changes (mouse wheel, drag, expand/collapse).

- payload: current scroll position in pixels (string form)

The host is expected to:
- update scrollbar MaximumValue using MaxScrollY
- clamp scrollbar Value
- guard against feedback loops

---

## Visibility Notes

- Fire(...) is **Protected**
  - prevents external event spoofing
  - allows subclasses to emit legitimate notifications

All rendering, layout, and rebuild helpers are Private.

---

## Scrolling Model

- Pixel-based scrolling
- Scrollbar.Value == mScrollY
- Scrollbar.MaximumValue == MaxScrollY
- Scrollbar.PageStep == viewport height

---

## Expand / Collapse Contract

When a disclosure triangle is clicked:
1. Toggle _Expanded
2. Rebuild visible rows immediately
3. Clamp scroll
4. Refresh view
5. Emit ScrollChanged

This guarantees scrollbar and mouse wheel never desync.

---

## Tree Node Dictionary Keys

Reserved keys:
- _Key        : String (unique id)
- _Value      : display value
- _Expanded   : Boolean
- _Children   : Dictionary (child nodes)

Additional domain-specific keys are allowed.

---

## Minimal Usage

Bind once:
    XTree.BeginUse(rootDict, levelSpec, Self)

After tree mutation:
    XTree.Update

---

API frozen for v1.0.

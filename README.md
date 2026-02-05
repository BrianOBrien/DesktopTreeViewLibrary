# XojoTreeView (Canvas-based)

<img width="602" height="632" alt="image" src="https://github.com/user-attachments/assets/30cedcc4-9ba6-470c-8797-06b027aa2af8" />


A lightweight, modern **TreeView implemented on top of `Canvas`**, built to explore and validate **Xojo’s new Library feature** while producing something genuinely useful for real projects.

This TreeView is:
- Dark-theme friendly
- Dictionary-driven
- Fully custom-drawn
- Independent of `DesktopTreeView` limitations

It is suitable for use in Desktop projects where you want **full visual control** and **predictable behavior**.

---

## Features

- Canvas-based rendering (no DesktopTreeView)
- Hierarchical data driven by `Dictionary`
- Expand / collapse support
- Custom disclosure triangles
- Optional icons per node type
- Attribute indicators (e.g. star markers)
- Clean separation of:
  - model (dictionary)
  - layout
  - rendering
- Designed for dark themes
- No reliance on `Color.Alpha` for state

---

## Why Canvas?

Xojo’s built-in TreeView is convenient, but:
- styling is limited
- behavior can be opaque
- extending it can be frustrating

This approach trades convenience for **clarity and control**:
everything you see is drawn intentionally.

---

## Data Model

Nodes are simple `Dictionary` objects.  
Common keys include:

```text
_Key
_Value
_Type
_Expanded (Boolean)
_Attribute (optional)
Children (Dictionary)

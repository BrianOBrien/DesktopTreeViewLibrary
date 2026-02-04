XojoTreeView v14

This version introduces a LevelSpec abstraction.

BeginUse signature:
  BeginUse(tree As Dictionary, callback As TreeViewCallback, levelSpec As Dictionary)

Each node dictionary uses:
  _Type   : String   (e.g. Library, Artist, Album, Track, Patient, Study, Series, Instance)
  Value   : String   (display text)
  Children: Dictionary (optional)

LevelSpec format:
  key   = _Type string
  value = Dictionary with:
            Caption : String
            Icon    : Picture

Import order:
  1) XojoTreeViewDelegates.xojo_code
  2) XojoTreeView.xojo_code
  3) XojoTreeViewSampleData.xojo_code


v15: Increased dotted guide line contrast and restored disclosure triangle drawing in Paint.


v18: Adds AttributeColor and DrawStar methods (star polygon 0,2,4,1,3) and Paint integration. Fixes DrawTriangle integer division.


v19: SampleData restored to a large scrolling dataset; sets _Attribute="green" on first track of each album.


v20: Adds horizontal dotted elbow connectors (DrawDottedH) for classic tree look.


v21: Restores interaction events (MouseDown selection/expand, MouseWheel scrolling) and selected-row highlight.


v22: Fix star visibility by making AttributeColor robust for String/Text Variants (uses StringValue first, then IntegerValue fallback).

#tag Class
Protected Class XojoTreeView
Inherits DesktopCanvas
	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  If mNeedsRebuild Then RebuildRows
		  
		  Var rowIndex As Integer = (y + mScrollY) \ mRowH
		  If rowIndex < 0 Or rowIndex > mRows.LastIndex Then Return False
		  
		  Var row As Dictionary = mRows(rowIndex)
		  Var node As Dictionary = Dictionary(row.Value("Node"))
		  Var depth As Integer = row.Value("Depth").IntegerValue
		  Var nodeKey As String = row.Value("NodeKey").StringValue
		  
		  Var kids As Dictionary = ChildDict(node)
		  Var hasKids As Boolean = (kids <> Nil And kids.KeyCount > 0)
		  
		  ' Hit test disclosure triangle
		  Var triX As Integer = 10 + depth * mIndent
		  Var triY As Integer = rowIndex * mRowH - mScrollY + (mRowH - mTriangleSize) \ 2
		  If hasKids Then
		    If x >= triX And x <= (triX + mTriangleSize) And y >= triY And y <= (triY + mTriangleSize) Then
		      node.Value("_Expanded") = Not node.Value("_Expanded").BooleanValue
		      mNeedsRebuild = True
		      Refresh
		      Return True ' expanding/collapsing does not fire selection callback
		    End If
		  End If
		  
		  ' Selection
		  If mRoot <> Nil Then ClearSelectionRecursive(mRoot)
		  node.Value("_Selected") = True
		  Refresh
		  Fire("NodeSelected", node, nodeKey)
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Function MouseWheel(x As Integer, y As Integer, deltaX As Integer, deltaY As Integer) As Boolean
		  #Pragma Unused x
		  #Pragma Unused y
		  #Pragma Unused deltaX
		  
		  ' deltaY is typically +/-1 per notch; scale for pleasant scrolling
		  mScrollY = mScrollY - (deltaY * (mRowH \ 2))
		  ClampScroll
		  Refresh
		  
		  Fire("ScrollChanged", Nil, mScrollY.ToString)
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  #Pragma Unused areas
		  If mNeedsRebuild Then RebuildRows
		  
		  ' Dark theme palette
		  Var bg As Color = Color.RGB(30, 30, 34)
		  Var rowAlt As Color = Color.RGB(34, 34, 40)
		  Var textCol As Color = Color.RGB(230, 230, 235)
		  Var guideCol As Color = Color.RGB(92, 92, 110) ' brighter dotted lines
		  
		  g.DrawingColor = bg
		  g.FillRectangle(0, 0, Self.Width, Self.Height)
		  
		  Var firstRow As Integer = mScrollY \ mRowH
		  If firstRow < 0 Then firstRow = 0
		  Var lastRow As Integer = (mScrollY + Self.Height) \ mRowH
		  If lastRow > mRows.LastIndex Then lastRow = mRows.LastIndex
		  
		  For i As Integer = firstRow To lastRow
		    Var y As Integer = i * mRowH - mScrollY
		    
		    ' Alt row fill
		    If (i Mod 2) = 1 Then
		      g.DrawingColor = rowAlt
		      g.FillRectangle(0, y, Self.Width, mRowH)
		    End If
		    
		    Var row As Dictionary = mRows(i)
		    Var node As Dictionary = Dictionary(row.Value("Node"))
		    
		    Var isSelected As Boolean = node.Lookup("_Selected", False).BooleanValue
		    If isSelected Then
		      // Fill highlight (deep purple-ish, dark-mode friendly)
		      g.DrawingColor = Color.RGB(60, 45, 85)
		      g.FillRectangle(0, y, Self.Width, mRowH)
		      
		      // Optional border to make it pop
		      g.DrawingColor = Color.RGB(120, 80, 200)
		      g.DrawRectangle(0, y, Self.Width, mRowH)
		    End If
		    
		    
		    Var depth As Integer = row.Value("Depth").IntegerValue
		    
		    ' Dotted guide columns (brighter)
		    For d As Integer = 0 To depth - 1
		      Var gx As Integer = 10 + d * mIndent
		      DrawDottedV(g, gx, y + 2, y + mRowH - 3, guideCol)
		    Next
		    
		    
		    ' Horizontal elbow from parent spine to this node
		    If depth > 0 Then
		      Var spineX As Integer = 10 + (depth - 1) * mIndent
		      Var nodeX As Integer = 10 + depth * mIndent
		      Var midY As Integer = y + (mRowH \ 2)
		      DrawDottedH(g, spineX, nodeX, midY, guideCol)
		    End If
		    
		    Var typeName As String = node.Lookup("_Type", "").StringValue
		    Var valueText As String = node.Lookup("Value", "").StringValue
		    
		    Var icon As Picture
		    Var caption As String = typeName
		    If mLevelSpec <> Nil And mLevelSpec.HasKey(typeName) Then
		      Var info As Dictionary = Dictionary(mLevelSpec.Value(typeName))
		      icon = Picture(info.Lookup("Icon", Nil))
		      caption = info.Lookup("Caption", typeName).StringValue
		    End If
		    
		    Var x As Integer = 10 + depth * mIndent
		    
		    ' Disclosure triangle if children exist
		    Var kids As Dictionary = ChildDict(node)
		    Var hasKids As Boolean = (kids <> Nil And kids.KeyCount > 0)
		    If hasKids Then
		      Var triY As Integer = y + (mRowH - mTriangleSize) \ 2
		      DrawTriangle(g, x, triY, mTriangleSize, node.Value("_Expanded").BooleanValue, guideCol)
		    End If
		    x = x + mTriangleSize + 6
		    
		    ' Icon + text
		    If icon <> Nil Then
		      g.DrawPicture(icon, x, y + (mRowH - icon.Height) \ 2)
		      x = x + icon.Width + 6
		      g.DrawingColor = textCol
		      g.DrawText(valueText, x, y + mRowH - 6)
		    Else
		      g.DrawingColor = textCol
		      g.DrawText(caption + " " + valueText, x, y + mRowH - 6)
		    End If
		    
		    ' Right-justified attribute indicator (optional)
		    ' NEW: flag is presence of "_Attribute", not alpha
		    If node <> Nil And node.HasKey("_Attribute") Then
		      Var ac As Color = AttributeColor(node)
		      Var sr As Integer = 6
		      Var starX As Integer = Self.Width - 12
		      Var starY As Integer = y + (mRowH \ 2)
		      
		      //g.DrawingOpacity = 0.65
		      DrawStar(g, starX, starY, sr, ac)
		      //g.DrawingOpacity = 1.0
		    End If
		    
		  Next
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub AddNodeToRows(node As Dictionary, depth As Integer, nodeKey As String)
		  Var row As New Dictionary
		  row.Value("Node") = node
		  row.Value("Depth") = depth
		  row.Value("NodeKey") = nodeKey
		  mRows.Add(row)
		  
		  If Not node.Value("_Expanded").BooleanValue Then Return
		  Var kids As Dictionary = ChildDict(node)
		  If kids = Nil Then Return
		  
		  For Each k As Variant In kids.Keys
		    AddNodeToRows(Dictionary(kids.Value(k)), depth + 1, k.StringValue)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function AttributeColor(node As Dictionary) As Color
		  Var bg As Color = Color.RGB(30, 30, 34) // your canvas background
		  
		  If node = Nil Or Not node.HasKey("_Attribute") Then
		    Return Blend(Color.RGB(180,180,180), bg, 0.35)
		  End If
		  
		  Var v As Variant = node.Value("_Attribute")
		  
		  Var base As Color = Color.RGB(180, 180, 180)
		  
		  Try
		    Var s As String = v.StringValue.Trim.Lowercase
		    Select Case s
		    Case "green", "ok", "good"
		      base = Color.RGB(80, 200, 120)
		    Case "yellow", "warn", "warning"
		      base = Color.RGB(240, 210, 90)
		    Case "red", "bad", "error"
		      base = Color.RGB(235, 95, 95)
		    End Select
		  Catch
		  End Try
		  
		  Try
		    Var n As Integer = v.IntegerValue
		    Select Case n
		    Case 1
		      base = Color.RGB(80, 200, 120)
		    Case 2
		      base = Color.RGB(240, 210, 90)
		    Case 3
		      base = Color.RGB(235, 95, 95)
		    End Select
		  Catch
		  End Try
		  
		  // “fake alpha” by blending into background
		  Return Blend(base, bg, 0.65)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BeginUse(theTree As Dictionary, levelSpec As Dictionary, host As ITreeHost)
		  mRoot = theTree
		  mLevelSpec = levelSpec
		  mHost = host
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Blend(over As Color, back As Color, a As Double) As Color
		  Var r As Integer = back.Red   + (over.Red   - back.Red)   * a
		  Var gg As Integer = back.Green + (over.Green - back.Green) * a
		  Var b As Integer = back.Blue  + (over.Blue  - back.Blue)  * a
		  Return Color.RGB(r, gg, b)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ChildDict(node As Dictionary) As Dictionary
		  If node = Nil Then Return Nil
		  If node.HasKey("Children") And node.Value("Children") IsA Dictionary Then Return Dictionary(node.Value("Children"))
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ClampScroll()
		  Var maxScroll As Integer = TotalContentHeight - Self.Height
		  If maxScroll < 0 Then maxScroll = 0
		  If mScrollY < 0 Then mScrollY = 0
		  If mScrollY > maxScroll Then mScrollY = maxScroll
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ClearSelectionRecursive(node As Dictionary)
		  If node = Nil Then Return
		  If node.HasKey("_Selected") Then node.Value("_Selected") = False
		  Var kids As Dictionary = ChildDict(node)
		  If kids <> Nil Then
		    For Each k As Variant In kids.Keys
		      ClearSelectionRecursive(Dictionary(kids.Value(k)))
		    Next
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawDottedH(g As Graphics, x1 As Integer, x2 As Integer, y As Integer, c As Color)
		  ' Short horizontal dotted connector ("elbow")
		  g.DrawingColor = c
		  Var stepPx As Integer = 3
		  Var dashLen As Integer = 2
		  Var xx As Integer = x1
		  While xx <= x2
		    g.DrawLine(xx, y, xx + dashLen, y)
		    xx = xx + (stepPx * 2)
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawDottedV(g As Graphics, x As Integer, y1 As Integer, y2 As Integer, c As Color)
		  ' Higher-contrast dotted guide for dark themes
		  g.DrawingColor = c
		  Var stepPx As Integer = 3
		  Var dashLen As Integer = 2
		  Var yy As Integer = y1
		  While yy <= y2
		    g.DrawLine(x, yy, x, yy + dashLen)
		    yy = yy + (stepPx * 2)
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawStar(g As Graphics, cx As Integer, cy As Integer, r As Integer, c As Color)
		  ' 5-point star polygon using vertex order: 0,2,4,1,3
		  g.DrawingColor = c
		  
		  Var px(4) As Double
		  Var py(4) As Double
		  
		  For k As Integer = 0 To 4
		    Var a As Double = (-3.14159265358979 / 2.0) + (k * (2.0 * 3.14159265358979 / 5.0))
		    px(k) = cx + (r * Cos(a))
		    py(k) = cy + (r * Sin(a))
		  Next
		  
		  Var order() As Integer = Array(0, 2, 4, 1, 3)
		  
		  Var path As New GraphicsPath
		  path.MoveToPoint(px(order(0)), py(order(0)))
		  For i As Integer = 1 To order.LastIndex
		    path.AddLineToPoint(px(order(i)), py(order(i)))
		  Next
		  
		  g.FillPath(path, True)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawTriangle(g As Graphics, x As Integer, y As Integer, size As Integer, expanded As Boolean, c As Color)
		  g.DrawingColor = c
		  Var p As New GraphicsPath
		  If expanded Then
		    p.MoveToPoint(x, y)
		    p.AddLineToPoint(x + size, y)
		    p.AddLineToPoint(x + (size \ 2), y + size)
		  Else
		    p.MoveToPoint(x, y)
		    p.AddLineToPoint(x, y + size)
		    p.AddLineToPoint(x + size, y + (size \ 2))
		  End If
		  g.FillPath(p, True)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EnsureFlagsRecursive(node As Dictionary)
		  If node = Nil Then Return
		  If Not node.HasKey("_Expanded") Then node.Value("_Expanded") = False
		  If Not node.HasKey("_Selected") Then node.Value("_Selected") = False
		  Var kids As Dictionary = ChildDict(node)
		  If kids <> Nil Then
		    For Each k As Variant In kids.Keys
		      EnsureFlagsRecursive(Dictionary(kids.Value(k)))
		    Next
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Fire(EventName As String, node As Dictionary, nodeKey As String)
		  If mHost <> Nil Then
		    mHost.TreeViewCallback(EventName, node, nodeKey)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RebuildRows()
		  mRows.RemoveAll
		  If mRoot = Nil Then Return
		  AddNodeToRows(mRoot, 0, "root")
		  mNeedsRebuild = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetLevelSpec(levelSpec as Dictionary)
		  Self.mLevelSpec = levelSpec
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetScrollY(y As Integer)
		  mScrollY = y
		  ClampScroll
		  Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetTree(theTree as Dictionary)
		  mRoot = theTree
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TotalContentHeight() As Integer
		  Return mRows.Count * mRowH
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update()
		  If mRoot <> Nil Then EnsureFlagsRecursive(mRoot)
		  mNeedsRebuild = True
		  Refresh
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mHost As ITreeHost
	#tag EndProperty

	#tag Property, Flags = &h0
		mIndent As Integer = 18
	#tag EndProperty

	#tag Property, Flags = &h0
		mLevelSpec As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		mNeedsRebuild As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRoot As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		mRowH As Integer = 22
	#tag EndProperty

	#tag Property, Flags = &h0
		mRows() As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		mScrollY As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		mTriangleSize As Integer = 10
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowAutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Tooltip"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocus"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowTabs"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="mRowH"
			Visible=false
			Group="Behavior"
			InitialValue="22"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="mIndent"
			Visible=false
			Group="Behavior"
			InitialValue="18"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="mTriangleSize"
			Visible=false
			Group="Behavior"
			InitialValue="10"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="mScrollY"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="mNeedsRebuild"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

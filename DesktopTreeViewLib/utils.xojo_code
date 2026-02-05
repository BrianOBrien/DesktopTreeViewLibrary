#tag Module
Protected Module utils
	#tag Method, Flags = &h0
		Function FlattenTreePreserveState(srcRoot As Dictionary, joinKeys() As String, joinSep As String = " - ") As Dictionary
		  // joinKeys: e.g. Array("StudyDescription", "StudyDate")
		  // Returns a NEW tree, copying _Selected/_Expanded and keeping same _Key values.
		  
		  If srcRoot Is Nil Then Return Nil
		  
		  // 1) Clone this node (shallow fields)
		  Var dst As New Dictionary
		  
		  // Copy all scalar fields except Children (we will rebuild Children)
		  For Each k As Variant In srcRoot.Keys
		    Var ks As String = k.StringValue
		    If ks = "Children" Then Continue
		    dst.Value(ks) = srcRoot.Value(ks)
		  Next
		  
		  // Ensure flags exist if you rely on them
		  // (If not present in src, Lookup defaults are fine in your view)
		  If Not dst.HasKey("_Selected") Then dst.Value("_Selected") = False
		  If Not dst.HasKey("_Expanded") Then dst.Value("_Expanded") = False
		  
		  // 2) Rebuild children recursively
		  Var srcKids As Dictionary = Dictionary(srcRoot.Lookup("Children", Nil))
		  Var dstKids As New Dictionary
		  
		  If srcKids <> Nil Then
		    For Each childKey As Variant In srcKids.Keys
		      Var childNode As Dictionary = Dictionary(srcKids.Value(childKey))
		      dstKids.Value(childKey.StringValue) = FlattenTreePreserveState(childNode, joinKeys, joinSep)
		    Next
		  End If
		  
		  dst.Value("Children") = dstKids
		  
		  // 3) Apply flattening rule at THIS node (using its children)
		  // Only flatten if all required keys exist among children and have Values.
		  Var parts() As String
		  For Each needKey As String In joinKeys
		    If srcKids = Nil Or Not srcKids.HasKey(needKey) Then
		      parts.RemoveAll
		      Exit For
		    End If
		    
		    Var kid As Dictionary = Dictionary(srcKids.Value(needKey))
		    Var v As String = kid.Lookup("Value", "").StringValue.Trim
		    If v = "" Then
		      parts.RemoveAll
		      Exit For
		    End If
		    
		    parts.Add(v)
		  Next
		  
		  If parts.Count = joinKeys.Count Then
		    // Put the flattened caption into this node's Value
		    dst.Value("Value") = String.FromArray(parts, joinSep)
		  End If
		  
		  Return dst
		End Function
	#tag EndMethod


	#tag Note, Name = How to flatten
		
		// Your current tree (the one you already show)
		Var currentTree As Dictionary = theTree
		
		// Flatten “Study” nodes by combining these child keys:
		Var keys() As String = Array("StudyDescription", "StudyDate")
		
		Var flatTree As Dictionary = FlattenTreePreserveState(currentTree, keys, " - ")
		
		// Now just re-bind / update the view with the new tree
		XojoTreeView1.Update(flatTree)
		
	#tag EndNote


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
			InitialValue="-2147483648"
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
	#tag EndViewBehavior
End Module
#tag EndModule

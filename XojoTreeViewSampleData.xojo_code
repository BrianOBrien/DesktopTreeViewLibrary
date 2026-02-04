#tag Module
Protected Module XojoTreeViewSampleData
	#tag Method, Flags = &h0
		Function BuildMusicSample() As Dictionary
		  // Large sample tree to exercise scrolling + attributes.
		  // Node schema:
		  //   _Type : String   (Library/Artist/Album/Track)
		  //   Value : String
		  //   Children : Dictionary (optional)
		  //   _Attribute : optional "green|yellow|red" (stars in view)
		  
		  Var root As New Dictionary
		  root.Value("_Type") = "Library"
		  root.Value("Value") = "Music Library"
		  root.Value("_Expanded") = True
		  
		  Var rootKids As New Dictionary
		  
		  // ------------------------------------------------------------
		  // Artist: Daft Punk
		  // ------------------------------------------------------------
		  Var a1 As New Dictionary
		  a1.Value("_Type") = "Artist"
		  a1.Value("Value") = "Daft Punk"
		  a1.Value("_Expanded") = True
		  
		  Var a1Kids As New Dictionary
		  
		  Var a1alb1 As New Dictionary
		  a1alb1.Value("_Type") = "Album"
		  a1alb1.Value("Value") = "Random Access Memories"
		  a1alb1.Value("_Expanded") = True
		  Var a1alb1Kids As New Dictionary
		  a1alb1Kids.Value("01") = New Dictionary("_Type":"Track","Value":"Give Life Back to Music (04:35)","_Attribute":"green")
		  a1alb1Kids.Value("02") = New Dictionary("_Type":"Track","Value":"The Game of Love (05:22)")
		  a1alb1Kids.Value("03") = New Dictionary("_Type":"Track","Value":"Giorgio by Moroder (09:04)")
		  a1alb1Kids.Value("04") = New Dictionary("_Type":"Track","Value":"Within (03:48)")
		  a1alb1Kids.Value("05") = New Dictionary("_Type":"Track","Value":"Instant Crush (05:37)")
		  a1alb1Kids.Value("06") = New Dictionary("_Type":"Track","Value":"Lose Yourself to Dance (05:53)")
		  a1alb1Kids.Value("07") = New Dictionary("_Type":"Track","Value":"Touch (08:18)")
		  a1alb1Kids.Value("08") = New Dictionary("_Type":"Track","Value":"Get Lucky (06:09)")
		  a1alb1Kids.Value("09") = New Dictionary("_Type":"Track","Value":"Contact (06:21)")
		  a1alb1.Value("Children") = a1alb1Kids
		  a1Kids.Value("RAM") = a1alb1
		  
		  Var a1alb2 As New Dictionary
		  a1alb2.Value("_Type") = "Album"
		  a1alb2.Value("Value") = "Discovery"
		  a1alb2.Value("_Expanded") = False
		  Var a1alb2Kids As New Dictionary
		  a1alb2Kids.Value("01") = New Dictionary("_Type":"Track","Value":"One More Time (05:20)","_Attribute":"green")
		  a1alb2Kids.Value("02") = New Dictionary("_Type":"Track","Value":"Aerodynamic (03:27)")
		  a1alb2Kids.Value("03") = New Dictionary("_Type":"Track","Value":"Digital Love (04:58)")
		  a1alb2Kids.Value("04") = New Dictionary("_Type":"Track","Value":"Harder Better Faster Stronger (03:45)")
		  a1alb2Kids.Value("05") = New Dictionary("_Type":"Track","Value":"Something About Us (03:52)")
		  a1alb2Kids.Value("06") = New Dictionary("_Type":"Track","Value":"Too Long (10:00)")
		  a1alb2.Value("Children") = a1alb2Kids
		  a1Kids.Value("Discovery") = a1alb2
		  
		  Var a1alb3 As New Dictionary
		  a1alb3.Value("_Type") = "Album"
		  a1alb3.Value("Value") = "Homework"
		  a1alb3.Value("_Expanded") = False
		  Var a1alb3Kids As New Dictionary
		  a1alb3Kids.Value("01") = New Dictionary("_Type":"Track","Value":"Daftendirekt (02:44)","_Attribute":"green")
		  a1alb3Kids.Value("02") = New Dictionary("_Type":"Track","Value":"WDPK 83.7 FM (00:28)")
		  a1alb3Kids.Value("03") = New Dictionary("_Type":"Track","Value":"Revolution 909 (05:25)")
		  a1alb3Kids.Value("04") = New Dictionary("_Type":"Track","Value":"Around the World (07:10)")
		  a1alb3Kids.Value("05") = New Dictionary("_Type":"Track","Value":"Teachers (02:52)")
		  a1alb3Kids.Value("06") = New Dictionary("_Type":"Track","Value":"Burnin' (06:53)")
		  a1alb3Kids.Value("07") = New Dictionary("_Type":"Track","Value":"Fresh (04:03)")
		  a1alb3Kids.Value("08") = New Dictionary("_Type":"Track","Value":"Alive (05:15)")
		  a1alb3.Value("Children") = a1alb3Kids
		  a1Kids.Value("Homework") = a1alb3
		  
		  a1.Value("Children") = a1Kids
		  rootKids.Value("DaftPunk") = a1
		  
		  // ------------------------------------------------------------
		  // Artist: Massive Attack
		  // ------------------------------------------------------------
		  Var a2 As New Dictionary
		  a2.Value("_Type") = "Artist"
		  a2.Value("Value") = "Massive Attack"
		  a2.Value("_Expanded") = True
		  Var a2Kids As New Dictionary
		  
		  Var a2alb1 As New Dictionary
		  a2alb1.Value("_Type") = "Album"
		  a2alb1.Value("Value") = "Mezzanine"
		  a2alb1.Value("_Expanded") = True
		  Var a2alb1Kids As New Dictionary
		  a2alb1Kids.Value("01") = New Dictionary("_Type":"Track","Value":"Angel (06:19)","_Attribute":"green")
		  a2alb1Kids.Value("02") = New Dictionary("_Type":"Track","Value":"Risingson (04:58)")
		  a2alb1Kids.Value("03") = New Dictionary("_Type":"Track","Value":"Teardrop (05:30)")
		  a2alb1Kids.Value("04") = New Dictionary("_Type":"Track","Value":"Inertia Creeps (05:56)")
		  a2alb1Kids.Value("05") = New Dictionary("_Type":"Track","Value":"Dissolved Girl (06:06)")
		  a2alb1Kids.Value("06") = New Dictionary("_Type":"Track","Value":"Man Next Door (05:55)")
		  a2alb1.Value("Children") = a2alb1Kids
		  a2Kids.Value("Mezzanine") = a2alb1
		  
		  Var a2alb2 As New Dictionary
		  a2alb2.Value("_Type") = "Album"
		  a2alb2.Value("Value") = "Blue Lines"
		  a2alb2.Value("_Expanded") = False
		  Var a2alb2Kids As New Dictionary
		  a2alb2Kids.Value("01") = New Dictionary("_Type":"Track","Value":"Safe From Harm (05:18)","_Attribute":"green")
		  a2alb2Kids.Value("02") = New Dictionary("_Type":"Track","Value":"One Love (05:45)")
		  a2alb2Kids.Value("03") = New Dictionary("_Type":"Track","Value":"Blue Lines (04:20)")
		  a2alb2Kids.Value("04") = New Dictionary("_Type":"Track","Value":"Unfinished Sympathy (05:12)")
		  a2alb2Kids.Value("05") = New Dictionary("_Type":"Track","Value":"Daydreaming (05:28)")
		  a2alb2.Value("Children") = a2alb2Kids
		  a2Kids.Value("BlueLines") = a2alb2
		  
		  a2.Value("Children") = a2Kids
		  rootKids.Value("MassiveAttack") = a2
		  
		  // ------------------------------------------------------------
		  // Artist: Pink Floyd
		  // ------------------------------------------------------------
		  Var a3 As New Dictionary
		  a3.Value("_Type") = "Artist"
		  a3.Value("Value") = "Pink Floyd"
		  a3.Value("_Expanded") = False
		  Var a3Kids As New Dictionary
		  
		  Var a3alb1 As New Dictionary
		  a3alb1.Value("_Type") = "Album"
		  a3alb1.Value("Value") = "The Dark Side of the Moon"
		  a3alb1.Value("_Expanded") = False
		  Var a3alb1Kids As New Dictionary
		  a3alb1Kids.Value("01") = New Dictionary("_Type":"Track","Value":"Speak to Me (01:30)","_Attribute":"green")
		  a3alb1Kids.Value("02") = New Dictionary("_Type":"Track","Value":"Breathe (02:43)")
		  a3alb1Kids.Value("03") = New Dictionary("_Type":"Track","Value":"Time (06:53)")
		  a3alb1Kids.Value("04") = New Dictionary("_Type":"Track","Value":"Money (06:22)")
		  a3alb1Kids.Value("05") = New Dictionary("_Type":"Track","Value":"Us and Them (07:49)")
		  a3alb1.Value("Children") = a3alb1Kids
		  a3Kids.Value("DarkSide") = a3alb1
		  
		  Var a3alb2 As New Dictionary
		  a3alb2.Value("_Type") = "Album"
		  a3alb2.Value("Value") = "Wish You Were Here"
		  a3alb2.Value("_Expanded") = False
		  Var a3alb2Kids As New Dictionary
		  a3alb2Kids.Value("01") = New Dictionary("_Type":"Track","Value":"Shine On You Crazy Diamond (13:32)","_Attribute":"green")
		  a3alb2Kids.Value("02") = New Dictionary("_Type":"Track","Value":"Welcome to the Machine (07:31)")
		  a3alb2Kids.Value("03") = New Dictionary("_Type":"Track","Value":"Have a Cigar (05:08)")
		  a3alb2Kids.Value("04") = New Dictionary("_Type":"Track","Value":"Wish You Were Here (05:35)")
		  a3alb2.Value("Children") = a3alb2Kids
		  a3Kids.Value("WYWH") = a3alb2
		  
		  a3.Value("Children") = a3Kids
		  rootKids.Value("PinkFloyd") = a3
		  
		  // ------------------------------------------------------------
		  // Artist: Radiohead
		  // ------------------------------------------------------------
		  Var a4 As New Dictionary
		  a4.Value("_Type") = "Artist"
		  a4.Value("Value") = "Radiohead"
		  a4.Value("_Expanded") = False
		  Var a4Kids As New Dictionary
		  
		  Var a4alb1 As New Dictionary
		  a4alb1.Value("_Type") = "Album"
		  a4alb1.Value("Value") = "OK Computer"
		  a4alb1.Value("_Expanded") = False
		  Var a4alb1Kids As New Dictionary
		  a4alb1Kids.Value("01") = New Dictionary("_Type":"Track","Value":"Airbag (04:44)","_Attribute":"green")
		  a4alb1Kids.Value("02") = New Dictionary("_Type":"Track","Value":"Paranoid Android (06:23)")
		  a4alb1Kids.Value("03") = New Dictionary("_Type":"Track","Value":"Subterranean Homesick Alien (04:27)")
		  a4alb1Kids.Value("04") = New Dictionary("_Type":"Track","Value":"Karma Police (04:21)")
		  a4alb1Kids.Value("05") = New Dictionary("_Type":"Track","Value":"No Surprises (03:48)")
		  a4alb1.Value("Children") = a4alb1Kids
		  a4Kids.Value("OKC") = a4alb1
		  
		  Var a4alb2 As New Dictionary
		  a4alb2.Value("_Type") = "Album"
		  a4alb2.Value("Value") = "In Rainbows"
		  a4alb2.Value("_Expanded") = False
		  Var a4alb2Kids As New Dictionary
		  a4alb2Kids.Value("01") = New Dictionary("_Type":"Track","Value":"15 Step (03:57)","_Attribute":"green")
		  a4alb2Kids.Value("02") = New Dictionary("_Type":"Track","Value":"Bodysnatchers (04:02)")
		  a4alb2Kids.Value("03") = New Dictionary("_Type":"Track","Value":"Nude (04:15)")
		  a4alb2Kids.Value("04") = New Dictionary("_Type":"Track","Value":"Weird Fishes/Arpeggi (05:18)")
		  a4alb2Kids.Value("05") = New Dictionary("_Type":"Track","Value":"Reckoner (04:50)")
		  a4alb2.Value("Children") = a4alb2Kids
		  a4Kids.Value("InRainbows") = a4alb2
		  
		  a4.Value("Children") = a4Kids
		  rootKids.Value("Radiohead") = a4
		  
		  root.Value("Children") = rootKids
		  Return root
		End Function
	#tag EndMethod


End Module
#tag EndModule

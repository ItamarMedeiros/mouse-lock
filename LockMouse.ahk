#SingleInstance Force
SetWorkingDir, % A_ScriptDir


radius = 500
running:= false
oX:= (A_ScreenWidth // 2)
oY:= (A_ScreenHeight// 2) ;
 CircleClipRadius :=radius
 CircleClipX := CircleClipY := ""

step := 50

LAlt::
	CoordMode, Mouse, Screen
	
running:=!running
if(running){	
	CoordMode, Mouse, Screen
	CircleClip(radius,oX,oY)	
	
}else{	
	CircleClip() 	
}
return


ClipCursor(confine := False, x1 := 0 , y1 := 0, x2 := 0, y2 := 0) {

 VarSetCapacity(R, 16, 0), NumPut(x1, &R+0), NumPut(y1, &R+4), NumPut(x2, &R+8), NumPut(y2, &R+12)

 Return confine ? DllCall("ClipCursor", UInt, &R) : DllCall("ClipCursor")
}


up::
	if(running){
		newradius:=radius + step
		if(newradius > A_ScreenWidth // 2){
		  return
		}
		radius :=newradius
		CircleClip(radius,oX,oY)	
		return
	}
	Send {up}
    	return
down::
	if(running){
		newradius:=radius - step
		if(newradius < 5 ){
		return
		}
		radius :=newradius
		CircleClip(radius,oX,oY)

		return
	}
		Send {down}
	return

CircleClip(radius=0, x:="", y:=""){
	global CircleClipRadius, CircleClipX, CircleClipY
	static hHookMouse, _:={base:{__Delete: "CircleClip"}}, CC:=RegisterCallback("CircleClip_WH_MOUSE_LL", "Fast")

	If (hHookMouse){
		DllCall("UnhookWindowsHookEx", "Uint", hHookMouse)
		hHookMouse:=""
		CircleClipX:=CircleClipY:=""
	}
	If (radius>0)
		CircleClipRadius:=radius
		, CircleClipX:=x
		, CircleClipY:=y
		, hHookMouse := DllCall("SetWindowsHookEx", "int", 14, "Uint", CC, "Uint", 0, "Uint", 0)
	return
}


CircleClip_WH_MOUSE_LL(nCode, wParam, lParam){
		global CircleClipRadius, CircleClipX, CircleClipY
		global innerRadius
		Critical	

	if !nCode && (wParam = 0x200){ ; WM_MOUSEMOVE 
		nx := NumGet(lParam+0, 0, "Int") ; x-coord
		ny := NumGet(lParam+0, 4, "Int") ; y-coord

		If (CircleClipX="" || CircleClipY="")
			CircleClipX:=nx, CircleClipY:=ny
		  
		dx := nx - CircleClipX
		dy := ny - CircleClipY
		dist := sqrt( ((dx) ** 2) + (dy ** 2) )

		if ( dist > CircleClipRadius ) {
			dist := CircleClipRadius / dist
			dx *= dist
			dy *= dist
			
			nx := CircleClipX + dx
			ny := CircleClipY + dy
		}



		DllCall("SetCursorPos", "Int", nx, "Int", ny)
		Return 1
		
	}else 
	Return DllCall("CallNextHookEx", "Uint", 0, "int", nCode, "Uint", wParam, "Uint", lParam) 
} 



^Esc::ExitApp


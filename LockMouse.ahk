;========================================================================================
; Script:   Mouse Lock 
; Author:   Itamar Medeiros
; Date:     August 2, 2022
; Description: Locks the mouse pointer to the central part of the browser,
;              preventing it from touching other areas. For half screener people ;)
; Usage:    Press F3 to toggle the script on/off.
;           Press Ctrl+Esc to terminate the script.
;========================================================================================
#SingleInstance

toggle := False

F3:: 
    toggle := !toggle
 
    if (toggle)
    {  
        ; Get the position and size of the active window
        WinGetPos, winX, winY, winWidth, winHeight, A

       ; Define the offsets for the inner area
		innerOffsetX := 10       							; Offset from the left border of the window
		innerOffsetY := 105       							; Offset from the top border of the window and address bar height
		innerWidth   := winWidth - 20    					; Width of the inner area (excluding left and right borders)
		innerHeight  := winHeight - innerOffsetY - 10   	; Height of the inner area (excluding top and bottom borders)

        ; Calculate the cursor boundaries within the inner area of the window
        cursorX1 := winX + innerOffsetX
        cursorY1 := winY + innerOffsetY
        cursorX2 := winX + innerOffsetX + innerWidth
        cursorY2 := winY + innerOffsetY + innerHeight

        ; Call the ClipCursor function to confine the cursor to the desired area
        ClipCursor(True, cursorX1, cursorY1, cursorX2, cursorY2)
    }
    else
    {
        ; Desabilita a função de clip do cursor
        ClipCursor(False,0,0,0,0)  
    }
Return

ClipCursor( Confine=True, x1=0 , y1=0, x2=1, y2=1 ) {
  VarSetCapacity(R,16,0), NumPut(x1, &R+0), NumPut(y1, &R+4), NumPut(x2, &R+8), NumPut(y2, &R+12)
  Return Confine ? DllCall( "ClipCursor", UInt,&R ) : DllCall( "ClipCursor" )
}


^Esc::ExitApp
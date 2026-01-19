#Requires AutoHotkey v2.0

!\::Send "``"            ; (IT layout utility) "ALT + \"                     -> "`"
!|::Send "~"             ; (IT layout utility) "ALT + |" ("ALT + SHIFT + \") -> "~"
; !,::Send "<"             ; (US layout utility) "ALT + ,"                     -> "<"
; !SC034::Send ">"         ; (US layout utility) "ALT + ."                     -> ">"
; !SC01A::Send "{U+00E8}"  ; (US layout utility) "ALT + ["                     -> "è"
; !+SC01A::Send "{U+00E9}" ; (US layout utility) "ALT + {" ("ALT + SHIFT + [") -> "é"
; !=::Send "{U+00EC}"      ; (US layout utility) "ALT + ="                     -> "ì"

<!p::Send "{Backspace}"                         ; "LEFT ALT + p" -> "BACKSPACE"
<!<^p::Send "{LCtrl down}{Backspace}{LCtrl up}" ; "LEFT ALT + LEFT CTRL + p" -> "CTRL + BACKSPACE"

<!u::Send "{Delete}"                          ; "LEFT ALT + u" -> "DELETE"
<!+u::Send "{Shift down}{Delete}{Shift up}"   ; "LEFT ALT + SHIFT + u" -> "SHIFT + DELETE"
<!<^u::Send "{LCtrl down}{Delete}{LCtrl up}"  ; "LEFT ALT + LEFT CTRL + u" -> "CTRL + DELETE"

; ijkl cursor movements
<!i::Send "{Up}"       ; "LEFT ALT + i"                       -> "ARROW UP"
<!j::Send "{Left}"     ; "LEFT ALT + j"                       -> "ARROW LEFT"
<!k::Send "{Down}"     ; "LEFT ALT + k"                       -> "ARROW DOWN"
<!l::Send "{Right}"    ; "LEFT ALT + l"                       -> "ARROW RIGHT"
<!h::Send "{Home}"     ; "LEFT ALT + h"                       -> "HOME"
<!SC027::Send "{End}"  ; "LEFT ALT + (key to the right of l)" -> "END"
<!o::Send "{PgUp}"     ; "LEFT ALT + o"                       -> "PAGE UP"
<!SC034::Send "{PgDn}" ; "LEFT ALT + ."                       -> "PAGE DOWN"

; select text with ijkl cursor movements
<!+i::Send "{Shift down}{Up}{Shift up}"      ; "LEFT ALT + SHIFT + i"                       -> "SHIFT + ARROW UP"
<!+j::Send "{Shift down}{Left}{Shift up}"    ; "LEFT ALT + SHIFT + j"                       -> "SHIFT + ARROW LEFT"
<!+k::Send "{Shift down}{Down}{Shift up}"    ; "LEFT ALT + SHIFT + k"                       -> "SHIFT + ARROW DOWN"
<!+l::Send "{Shift down}{Right}{Shift up}"   ; "LEFT ALT + SHIFT + l"                       -> "SHIFT + ARROW RIGHT"
<!+h::Send "{Shift down}{Home}{Shift up}"    ; "LEFT ALT + SHIFT + h"                       -> "SHIFT + HOME"
<!+SC027::Send "{Shift down}{End}{Shift up}" ; "LEFT ALT + SHIFT + (key to the right of l)" -> "SHIFT + END"
<!+o::Send "{PgUp}"                          ; "LEFT ALT + SHIFT + o"                       -> "SHIFT + PAGE UP"
<!+SC034::Send "{PgDn}"                      ; "LEFT ALT + SHIFT + ."                       -> "SHIFT + PAGE DOWN"

; add ALT to ijkl cursor movements
<!<^>!i::Send "{LAlt down}{Up}{LAlt up}"    ; "LEFT ALT + RIGHT ALT + i" -> "ALT + ARROW UP"
<!<^>!j::Send "{LAlt down}{Left}{LAlt up}"  ; "LEFT ALT + RIGHT ALT + j" -> "ALT + ARROW LEFT"
<!<^>!k::Send "{LAlt down}{Down}{LAlt up}"  ; "LEFT ALT + RIGHT ALT + k" -> "ALT + ARROW DOWN"
<!<^>!l::Send "{LAlt down}{Right}{LAlt up}" ; "LEFT ALT + RIGHT ALT + l" -> "ALT + ARROW RIGHT"

; add WIN to ijkl cursor movements
<#<!i::Send "{LWin down}{Up}{LWin up}"
<#<!j::Send "{LWin down}{Left}{LWin up}"
<#<!k::Send "{LWin down}{Down}{LWin up}"
<#<!l::Send "{LWin down}{Right}{LWin up}"

; add CTRL to ijkl cursor movements
<!<^i::Send "{LCtrl down}{Up}{LCtrl up}"      ; "LEFT ALT + LEFT CTRL + i"                       -> "CTRL + ARROW UP"
<!<^j::Send "{LCtrl down}{Left}{LCtrl up}"    ; "LEFT ALT + LEFT CTRL + j"                       -> "CTRL + ARROW LEFT"
<!<^k::Send "{LCtrl down}{Down}{LCtrl up}"    ; "LEFT ALT + LEFT CTRL + k"                       -> "CTRL + ARROW DOWN"
<!<^l::Send "{LCtrl down}{Right}{LCtrl up}"   ; "LEFT ALT + LEFT CTRL + l"                       -> "CTRL + ARROW RIGHT"
<!<^h::Send "{LCtrl down}{Home}{LCtrl up}"    ; "LEFT ALT + LEFT CTRL + h"                       -> "CTRL + HOME"
<!<^SC027::Send "{LCtrl down}{End}{LCtrl up}" ; "LEFT ALT + LEFT CTRL + (key to the right of l)" -> "CTRL + END"

; add CTRL+SHIFT to ijkl cursor movements
<!<^+i::Send "{LCtrl down}{Shift down}{Up}{Shift up}{LCtrl up}"
<!<^+j::Send "{LCtrl down}{Shift down}{Left}{Shift up}{LCtrl up}"
<!<^+k::Send "{LCtrl down}{Shift down}{Down}{Shift up}{LCtrl up}"
<!<^+l::Send "{LCtrl down}{Shift down}{Right}{Shift up}{LCtrl up}"

; run Windows Terminal on WIN+ENTER
#Enter::Run "wt"

; turn Capslock into escape (caps2esc)
Capslock::Esc

; see https://www.autohotkey.com/docs/v2/scripts/index.htm#EasyWindowDrag_(KDE)
SetWinDelay 0
CoordMode "Mouse"

; move windows by pressing WIN and dragging with mouse left button
#LButton::
{
    ; Get the initial mouse position and window id, and
    ; abort if the window is maximized.
    MouseGetPos &KDE_X1, &KDE_Y1, &KDE_id
    if WinGetMinMax(KDE_id)
        return
    ; Get the initial window position.
    WinGetPos &KDE_WinX1, &KDE_WinY1,,, KDE_id
    Loop
    {
        if !GetKeyState("LButton", "P") ; Break if button has been released.
            break
        MouseGetPos &KDE_X2, &KDE_Y2 ; Get the current mouse position.
        KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
        KDE_Y2 -= KDE_Y1
        KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
        KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
        WinMove KDE_WinX2, KDE_WinY2,,, KDE_id ; Move the window to the new position.
    }
}

; resize windows by pressing WIN and dragging with mouse right button
#RButton::
{
    ; Get the initial mouse position and window id, and
    ; abort if the window is maximized.
    MouseGetPos &KDE_X1, &KDE_Y1, &KDE_id
    if WinGetMinMax(KDE_id)
        return
    ; Get the initial window position and size.
    WinGetPos &KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, KDE_id
    ; Define the window region the mouse is currently in.
    ; The four regions are Up and Left, Up and Right, Down and Left, Down and Right.
    if (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
        KDE_WinLeft := 1
    else
        KDE_WinLeft := -1
    if (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
        KDE_WinUp := 1
    else
        KDE_WinUp := -1
    Loop
    {
        if !GetKeyState("RButton", "P") ; Break if button has been released.
            break
        MouseGetPos &KDE_X2, &KDE_Y2 ; Get the current mouse position.
        ; Get the current window position and size.
        WinGetPos &KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, KDE_id
        KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
        KDE_Y2 -= KDE_Y1
        ; Then, act according to the defined region.
        WinMove KDE_WinX1 + (KDE_WinLeft+1)/2*KDE_X2  ; X of resized window
              , KDE_WinY1 +   (KDE_WinUp+1)/2*KDE_Y2  ; Y of resized window
              , KDE_WinW  -     KDE_WinLeft  *KDE_X2  ; W of resized window
              , KDE_WinH  -       KDE_WinUp  *KDE_Y2  ; H of resized window
              , KDE_id
        KDE_X1 := (KDE_X2 + KDE_X1) ; Reset the initial position for the next iteration.
        KDE_Y1 := (KDE_Y2 + KDE_Y1)
    }
}

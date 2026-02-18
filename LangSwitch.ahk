#Requires AutoHotkey v2.0

; ==================================================
; ФИНАЛЬНАЯ ВЕРСИЯ: Alt+Shift + Центрированное уведомление
; ==================================================

; ВАШИ КОДЫ РАСКЛАДОК
EN_CODE := 67699721
RU_CODE := 68748313

; Переключение на РУССКИЙ (Ctrl+Alt+R)
^!r::
{
    ; Жмем Alt+Shift пока не получим русский
    while (GetCurrentLayout() != RU_CODE) {
        Send "{Alt down}{Shift down}{Alt up}{Shift up}"
        Sleep 100
    }
    ShowLangCenter("РУССКИЙ")
}

; Переключение на АНГЛИЙСКИЙ (Ctrl+Alt+E)
^!e::
{
    ; Жмем Alt+Shift пока не получим английский
    while (GetCurrentLayout() != EN_CODE) {
        Send "{Alt down}{Shift down}{Alt up}{Shift up}"
        Sleep 100
    }
    ShowLangCenter("ENGLISH")
}

; Получение текущей раскладки
GetCurrentLayout() {
    activeHwnd := WinExist("A")
    threadID := DllCall("GetWindowThreadProcessId", "Ptr", activeHwnd, "Ptr", 0, "UInt")
    layout := DllCall("GetKeyboardLayout", "UInt", threadID, "Ptr")
    return layout
}

; Центрированное уведомление (как вам нравилось)
ShowLangCenter(lang) {
    ; Создаем окно уведомления
    MyGui := Gui("+AlwaysOnTop -Caption +ToolWindow +Border +LastFound")

    ; Разные цвета для языков
    if (lang = "РУССКИЙ")
        MyGui.BackColor := "0x4CAF50"  ; Зеленый
    else
        MyGui.BackColor := "0x2196F3"  ; Синий

    ; Настройка текста
    MyGui.SetFont("s48 bold cWhite", "Segoe UI")
    MyGui.Add("Text", , lang)

    ; Показываем окно
    MyGui.Show("NoActivate")

    ; Центрируем на экране
    WinGetPos &X, &Y, &W, &H, MyGui
    MyGui.Move(A_ScreenWidth / 2 - W / 2, A_ScreenHeight / 2 - H / 2)

    ; Убираем через 400 мс
    SetTimer () => MyGui.Destroy(), -400
}

; Диагностика (F12 - показать текущий язык)
F12::
{
    current := GetCurrentLayout()
    if (current = RU_CODE)
        msg := "РУССКИЙ"
    else if (current = EN_CODE)
        msg := "АНГЛИЙСКИЙ"
    else
        msg := "НЕИЗВЕСТНЫЙ (код: " current ")"

    MsgBox "Текущий язык: " msg
}
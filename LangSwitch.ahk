#Requires AutoHotkey v2.0

; ==================================================
; ФИНАЛ: Переключение языка + Конвертация выделенного текста
; ВЕРСИЯ С МАССИВАМИ (БЕЗ ОШИБОК)
; ==================================================

; ВАШИ КОДЫ РАСКЛАДОК
EN_CODE := 67699721
RU_CODE := 68748313

; ==================================================
; РУССКИЙ (Ctrl+Alt+R)
; ==================================================
^!r::
{
    ; Сохраняем буфер
    oldClipboard := A_Clipboard
    oldClipboardAll := ClipboardAll()

    ; Пытаемся скопировать выделенное
    A_Clipboard := ""
    Send "^c"
    if !ClipWait(0.2) {  ; Нет выделения
        A_Clipboard := oldClipboardAll
        SwitchToRussian()
        return
    }

    ; Есть текст — конвертируем из английского в русский
    selectedText := A_Clipboard
    convertedText := ConvertToRussian(selectedText)

    ; Вставляем обратно
    A_Clipboard := convertedText
    Sleep 50
    Send "^v"

    ; Восстанавливаем буфер
    Sleep 100
    A_Clipboard := oldClipboardAll

    ShowLangCenter("РУС (конверт)")
}

; ==================================================
; АНГЛИЙСКИЙ (Ctrl+Alt+E)
; ==================================================
^!e::
{
    ; Сохраняем буфер
    oldClipboard := A_Clipboard
    oldClipboardAll := ClipboardAll()

    ; Пытаемся скопировать
    A_Clipboard := ""
    Send "^c"
    if !ClipWait(0.2) {  ; Нет выделения
        A_Clipboard := oldClipboardAll
        SwitchToEnglish()
        return
    }

    ; Есть текст — конвертируем из русского в английский
    selectedText := A_Clipboard
    convertedText := ConvertToEnglish(selectedText)

    ; Вставляем
    A_Clipboard := convertedText
    Sleep 50
    Send "^v"

    ; Восстанавливаем буфер
    Sleep 100
    A_Clipboard := oldClipboardAll

    ShowLangCenter("ENG (конверт)")
}

; ==================================================
; ФУНКЦИИ ПЕРЕКЛЮЧЕНИЯ ЯЗЫКА
; ==================================================
SwitchToRussian() {
    while (GetCurrentLayout() != RU_CODE) {
        Send "{Alt down}{Shift down}{Alt up}{Shift up}"
        Sleep 100
    }
    ShowLangCenter("РУССКИЙ")
}

SwitchToEnglish() {
    while (GetCurrentLayout() != EN_CODE) {
        Send "{Alt down}{Shift down}{Alt up}{Shift up}"
        Sleep 100
    }
    ShowLangCenter("ENGLISH")
}

; ==================================================
; ФУНКЦИИ КОНВЕРТАЦИИ (БЕЗ MAP)
; ==================================================

ConvertToRussian(text) {
    ; Английские символы
    en := ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]", "a", "s", "d", "f", "g", "h", "j", "k", "l", ";",
        "'", "z", "x", "c", "v", "b", "n", "m", ",", ".", "/"]
    en_upper := ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "{", "}", "A", "S", "D", "F", "G", "H", "J", "K",
        "L", ":", '"', "Z", "X", "C", "V", "B", "N", "M", "<", ">", "?"]

    ; Русские соответствия
    ru := ["й", "ц", "у", "к", "е", "н", "г", "ш", "щ", "з", "х", "ъ", "ф", "ы", "в", "а", "п", "р", "о", "л", "д", "ж",
        "э", "я", "ч", "с", "м", "и", "т", "ь", "б", "ю", "."]
    ru_upper := ["Й", "Ц", "У", "К", "Е", "Н", "Г", "Ш", "Щ", "З", "Х", "Ъ", "Ф", "Ы", "В", "А", "П", "Р", "О", "Л",
        "Д", "Ж", "Э", "Я", "Ч", "С", "М", "И", "Т", "Ь", "Б", "Ю", ","]

    ; Объединяем
    enChars := []
    ruChars := []

    for v in en
        enChars.Push(v)
    for v in en_upper
        enChars.Push(v)
    for v in ru
        ruChars.Push(v)
    for v in ru_upper
        ruChars.Push(v)

    result := ""

    for char in StrSplit(text) {
        found := false
        for i, c in enChars {
            if (char = c) {
                result .= ruChars[i]
                found := true
                break
            }
        }
        if !found
            result .= char
    }

    return result
}

ConvertToEnglish(text) {
    ; Русские символы
    ru := ["й", "ц", "у", "к", "е", "н", "г", "ш", "щ", "з", "х", "ъ", "ф", "ы", "в", "а", "п", "р", "о", "л", "д", "ж",
        "э", "я", "ч", "с", "м", "и", "т", "ь", "б", "ю", "."]
    ru_upper := ["Й", "Ц", "У", "К", "Е", "Н", "Г", "Ш", "Щ", "З", "Х", "Ъ", "Ф", "Ы", "В", "А", "П", "Р", "О", "Л",
        "Д", "Ж", "Э", "Я", "Ч", "С", "М", "И", "Т", "Ь", "Б", "Ю", ","]

    ; Английские соответствия
    en := ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]", "a", "s", "d", "f", "g", "h", "j", "k", "l", ";",
        "'", "z", "x", "c", "v", "b", "n", "m", ",", ".", "/"]
    en_upper := ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "{", "}", "A", "S", "D", "F", "G", "H", "J", "K",
        "L", ":", '"', "Z", "X", "C", "V", "B", "N", "M", "<", ">", "?"]

    ; Объединяем
    ruChars := []
    enChars := []

    for v in ru
        ruChars.Push(v)
    for v in ru_upper
        ruChars.Push(v)
    for v in en
        enChars.Push(v)
    for v in en_upper
        enChars.Push(v)

    result := ""

    for char in StrSplit(text) {
        found := false
        for i, c in ruChars {
            if (char = c) {
                result .= enChars[i]
                found := true
                break
            }
        }
        if !found
            result .= char
    }

    return result
}

; ==================================================
; ПОЛУЧЕНИЕ ТЕКУЩЕЙ РАСКЛАДКИ
; ==================================================
GetCurrentLayout() {
    activeHwnd := WinExist("A")
    threadID := DllCall("GetWindowThreadProcessId", "Ptr", activeHwnd, "Ptr", 0, "UInt")
    layout := DllCall("GetKeyboardLayout", "UInt", threadID, "Ptr")
    return layout
}

; ==================================================
; ЦЕНТРИРОВАННОЕ УВЕДОМЛЕНИЕ
; ==================================================
ShowLangCenter(lang) {
    MyGui := Gui("+AlwaysOnTop -Caption +ToolWindow +Border +LastFound")

    if InStr(lang, "РУС")
        MyGui.BackColor := "0x4CAF50"  ; Зеленый
    else
        MyGui.BackColor := "0x2196F3"  ; Синий

    MyGui.SetFont("s48 bold cWhite", "Segoe UI")
    MyGui.Add("Text", , lang)
    MyGui.Show("NoActivate")

    WinGetPos &X, &Y, &W, &H, MyGui
    MyGui.Move(A_ScreenWidth / 2 - W / 2, A_ScreenHeight / 2 - H / 2)

    SetTimer () => MyGui.Destroy(), -400
}

; ==================================================
; ДИАГНОСТИКА
; ==================================================
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
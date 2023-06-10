return unless CLIENT
install 'class-war', 'https://github.com/toxidroma/class-war'
DetectMenuFocus = (panel, mousecode) ->
    if IsValid panel
        if panel.IsMenu or panel.m_bIsMenuComponent
            return
        return DetectMenuFocus panel\GetParent!, mousecode
    CloseDermaMenus!
hook.Add 'VGUIMousePressed', _PKG\GetIdentifier!, DetectMenuFocus

export ^
LPanel = include'lpanel.lua'
LLabel = include'llabel.lua'
LLabelCompute = include'llabelcompute.lua'
LImage = include'limage.lua'
LButton = include'lbutton.lua'
LFrame = include'lframe.lua'

{ 
    :LPanel
    :LLabel
    :LLabelCompute
    :LImage
    :LButton
    :LFrame
}
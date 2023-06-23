return unless CLIENT
install 'class-war', 'https://github.com/toxidroma/class-war'
DetectMenuFocus = (panel, mousecode) ->
    if IsValid panel
        if panel.IsMenu or panel.m_bIsMenuComponent
            return
        return DetectMenuFocus panel\GetParent!, mousecode
    CloseDermaMenus!
hook.Add 'VGUIMousePressed', 'MenuFocus', DetectMenuFocus

export luna = {}
with luna
    .Scale = (value) -> math.max(value * (ScrH! / 1080), 1)
    .Text = include'text.moon'
    .LTextEntry = include'ltextentry.moon'
    --.LPanel = include'lpanel.moon'
    .LLabel = include'llabel.moon'
    --.LLabelCompute = include'llabelcompute.moon'
    --.LImage = include'limage.moon'
    .LButton = include'lbutton.moon'
    .LFrame = include'lframe.moon'
    .LNumSlider = include'lnumslider.moon'

luna
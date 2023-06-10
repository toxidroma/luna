import IsShiftDown, IsControlDown from input
class LLabel extends VGUI
    Base: 'Label'

    IsMenu: false
    TextColor: nil
    TextStyleColor: nil
    Font: 'ChatFont'
    DoubleClickingEnabled: true
    AutoStretchVertical: false
    IsToggle: false
    Toggled: false
    Disabled: false
    Bright: false
    Dark: false
    Highlight: false

    new: (...) =>
        super ...
        @SetMouseInputEnabled false
        @SetKeyboardInputEnabled false
        @SetTall 20
        @SetPaintBackgroundEnabled false
        @SetPaintBorderEnabled false
        @SetFont @Font
    SetFont: (@Font) =>
        @SetFontInternal @Font
        @ApplySchemeSettings!
    SetTextColor: (@TextColor) => @UpdateFGColor!
    SetColor: (@TextColor) => @UpdateFGColor!
    GetColor: => @TextColor or @TextStyleColor
    UpdateFGColor: =>
        c = @TextStyleColor
        c = @TextColor if @TextColor
        return unless c
        @SetFGColor c.r, c.g, c.b, c.a
    Toggle: =>
        return unless @IsToggle
        @Toggled = not @Toggled
        OnToggle @Toggled
    SetDisabled: (@Disabled) => @InvalidateLayout!
    SetEnabled: (bool) => @SetDisabled not bool
    IsEnabled: => not @Disabled
    UpdateColours: (skin) =>
        with skin.Colours.Label
            @TextStyleColor = if @Bright
                .Bright
            elseif @Dark
                .Dark
            elseif @Highlight
                .Highlight
            else
                .Default
    ApplySchemeSettings: =>
        @UpdateColours @GetSkin!
        @UpdateFGColor!
    Think: => @SizeToContentsY! if @AutoStretchVertical
    PerformLayout: => @ApplySchemeSettings!
    OnCursorEntered: => @InvalidateLayout true
    OnCursorExited: => @InvalidateLayout true
    OnMousePressed: (mousecode) =>
        return if @Disabled
        if mousecode == MOUSE_LEFT and not dragndrop.IsDragging! and @DoubleClickingEnabled
            if @LastClickTime and SysTime! - @LastClickTime < .2
                @DoDoubleClickInternal!
                return @DoDoubleClick!
            @LastClickTime = SysTime!
            lp = LocalPlayer! if LocalPlayer
            isPlyMoving = if LocalPlayer and IsValid(LocalPlayer!)
                if lp\KeyDown IN_FORWARD
                    true
                elseif lp\KeyDown IN_BACK
                    true
                elseif lp\KeyDown IN_MOVELEFT
                    true
                elseif lp\KeyDown IN_MOVERIGHT
                    true
        if @IsSelectable! and mousecode == MOUSE_LEFT and (IsShiftDown! or IsControlDown!) and not isPlyMoving
            @StartBoxSelection!
        @MouseCapture true
        @Depressed = true
        @OnDepressed!
        @InvalidateLayout true
        @DragMousePress mousecode
    OnMouseReleased: (mousecode) =>
        @MouseCapture false
        return if @Disabled
        return if not @Depressed and dragndrop.m_DraggingMain != @
        if @Depressed
            @Depressed = nil
            @OnReleased!
            @InvalidateLayout true
        return if @DragMouseRelease mousecode
        if @IsSelectable! and mousecode == MOUSE_LEFT
            if canvas = @GetSelectionCanvas!
                canvas\UnselectAll!
        return unless @Hovered
        --https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dlabel.lua#L221
        @Depressed = true
        switch mousecode
            when MOUSE_RIGHT
                @DoRightClickInternal!
                @DoRightClick!
            when MOUSE_LEFT
                @DoClickInternal!
                @DoClick!
            when MOUSE_MIDDLE
                @DoMiddleClickInternal!
                @DoMiddleClick!
        @Depressed = nil
    OnReleased: =>
    OnDepressed: =>
    OnToggled: (bool) =>
    DoClick: => @Toggle!
    DoClickInternal: =>
    DoRightClick: =>
    DoRightClickInternal: =>
    DoMiddleClick: =>
    DoMiddleClickInternal: =>
    DoDoubleClick: =>
    DoDoubleClickInternal: =>

    m_bBackground: true 
    --a thousand curses on garry for forcing me to give my variable a terrible name
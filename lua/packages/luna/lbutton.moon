import ceil, min from math
local lp

class ButtonHover extends SOUND
    sound: 'luna/buttonrollover.ogg'

class ButtonDown extends SOUND
    sound: 'luna/buttonclick.ogg'

class ButtonUp extends SOUND
    sound: 'luna/buttonclickrelease.ogg'

class LButton extends VGUI
    m_bBackground: true --GOD DAMMIT GARRY
                    --DON'T TOUCH THIS OR IT WON'T DRAW
    Toggler: false
    new: (...) =>
        super ...
        @Toggled = false
        @SetMouseInputEnabled true
        @SetCursor 'hand'
        sz = luna.Scale 32
        @SetSize sz, sz
    DoToggle: (...) =>
        return unless @Toggler
        @Toggled = not @Toggled
        @OnToggled @Toggled, ...
    OnMousePressed: (mouseCode) =>
        return unless @IsEnabled!
        lp = LocalPlayer! unless lp
        if @IsSelectable! and mouseCode == MOUSE_LEFT and (input.IsShiftDown! or input.IsControlDown!) and not (
            lp\KeyDown IN_FORWARD or
            lp\KeyDown IN_BACK or
            lp\KeyDown IN_MOVELEFT or
            lp\KeyDown IN_MOVERIGHT)
                return @StartBoxSelection!
        @MouseCapture true
        @Depressed = true
        LocalPlayer!\EmitSound 'ButtonDown'
        @OnPressed mouseCode
        @DragMousePress mouseCode
    OnMouseReleased: (mouseCode) =>
        @MouseCapture false
        return unless @IsEnabled!
        return if not @Depressed and dragndrop.m_DraggingMain != @
        if @Depressed
            @Depressed = nil
            @OnReleased mouseCode
        return if @DragMouseRelease mouseCode
        if @IsSelectable! and mouseCode == MOUSE_LEFT
            @GetSelectionCanvas\UnselectAll! if @GetSelectionCanvas!
        return unless @Hovered
        LocalPlayer!\EmitSound 'ButtonUp'
        @Depressed = true
        switch mouseCode
            when MOUSE_LEFT
                @DoClick!
            when MOUSE_RIGHT
                @DoRightClick!
            when MOUSE_MIDDLE
                @DoMiddleClick!
        @Depressed = nil
    Paint: (w, h) =>
        derma.SkinHook 'Paint', 'Button', @, w, h
        false
    IsDown: => @Depressed
    OnPressed: (mouseCode) =>
    OnReleased: (mouseCode) =>
    OnToggled: (enabled) =>
    DoClick: (...) => @DoToggle ...
    DoRightClick: =>
    DoMiddleClick: =>
    Think: =>
        unless @HoveredLast
            if @Hovered
                @HoveredLast = true
                LocalPlayer!\EmitSound 'ButtonHover'
        elseif not @Hovered
            @HoveredLast = false


    --added for compatibility with derma skins
    GetToggle: => @Toggled
    GetDisabled: => not @IsEnabled
import Clamp from math
import MouseX, MouseY from gui
class LFrame extends VGUI
    Base: 'EditablePanel'
    Width: 640
    Height: 480

    Title: 'Window'
    IsMenu: false
    DeleteOnClose: true
    Draggable: true
    Sizable: false
    ScreenLock: false
    DeleteOnClose: true
    MinWidth: 50
    MinHeight: 50
    BackgroundBlur: false
    PaintShadow: true
    new: (...) =>
        super ...
        @SetFocusTopLevel true
        with @btnClose = LButton!
            @Add @btnClose
            \SetText ''
            .DoClick = -> @Close!
            .Paint = (panel, w, h) -> derma.SkinHook 'Paint', 'WindowCloseButton', panel, w, h

        with @lblTitle = LLabel!
            @Add @lblTitle
            \SetMouseInputEnabled false
            .UpdateColours = (label, skin) ->
                color = skin.Colours.Window.TitleInactive
                color = skin.Colours.Window.TitleActive if @IsActive!
                .TextStyleColor = color
            \SetText @Title
        @SetPaintBackgroundEnabled false
        @SetPaintBorderEnabled false
        @timeBirth = SysTime!
        @DockPadding 5, 24 + 5, 5, 5
    ShowCloseButton: (bShow) => @btnClose\SetVisible bShow
    GetTitle: => @lblTitle\GetText!
    SetTitle: (strTitle) => @lblTitle\SetText strTitle
    Close: => 
        @SetVisible false
        @Remove! if @DeleteOnClose
        @OnClose!
    OnClose: =>
    Center: =>
        @InvalidateLayout true
        @CenterVertical!
        @CenterHorizontal!
    IsActive: => true if @HasFocus! or vgui.FocusedHasParent @
    SetIcon: (str) =>
        return @imgIcon\Remove! if not str and IsValid @imgIcon
        @imgIcon = LImage! unless IsValid @imgIcon
        @imgIcon\SetMaterial Material str if IsValid @imgIcon
    Think: =>
        sW, sH = ScrW!, ScrH!
        mX = Clamp MouseX!, 1, sW - 1
        mY = Clamp MouseY!, 1, sH - 1
        w, h = @GetWide!, @GetTall!
        if @Dragging
            x = mX - @Dragging[1]
            y = mY - @Dragging[2]
            if @ScreenLock
                x = Clamp x, 0, sW - w
                y = Clamp y, 0, sH - h
            @SetPos x, y
        if @Sizing
            x = mX - @Sizing[1]
            y = mY - @Sizing[2]
            pX, pY = @GetPos!
            if x < @MinWidth
                x = @MinWidth
            elseif x > sW - pX and @ScreenLock
                x = sW - pX
            if y < @MinHeight
                y = @MinHeight
            elseif y > sH - pY and @ScreenLock
                y = sH - pY
            @SetSize x, y
            return @SetCursor 'sizenwse'
        sX, sY = @LocalToScreen 0, 0
        if @Hovered and @Sizable and mX > (sX + w - 20) and mY > (sY + h - 20)
            return @SetCursor 'sizenwse'
        if @Hovered and @Draggable and mY < (sY + 24)
            return @SetCursor 'sizeall'
        @SetCursor 'arrow'
        @SetPos @x, 0 if @y < 0
    Paint: (w, h) =>
        Derma_DrawBackgroundBlur @, @timeBirth if @BackgroundBlur
        derma.SkinHook 'Paint', 'Frame', @, w, h
        true
    OnMousePressed: =>
        sX, sY = @LocalToScreen 0, 0
        mX, mY = MouseX!, MouseY!
        if @Sizable and mX > (sX + w - 20) and mY > (sY + h - 20)
            @Sizing = {mX - w, mY - h}
            return @MouseCapture true
        if @Draggable and mY < (sY + 24)
            @Dragging = {mX - @x, mY - @y}
            return @MouseCapture true
    OnMouseReleased: =>
        @Dragging = nil
        @Sizing = nil
        @MouseCapture false
    PerformLayout: =>
        titlePush = 0
        if IsValid @imgIcon
            with @imgIcon
                \SetPos 5, 5
                \SetSize 16, 16
                titlePush = 16
        w = @GetWide!
        with @btnClose
            \SetPos w - 31 - 4, 0
            \SetSize 31, 24
        with @lblTitle
            \SetPos 8 + titlePush, 2
            \SetSize w - 25 - titlePush, 20
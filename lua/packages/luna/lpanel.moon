class LPanel extends VGUI
    Base: 'Panel'

    PaintBackground: true
    IsMenu: false
    TabbingDisabled: false
    Disabled: false
    BackgroundColor: nil

    new: (...) =>
        super ...
        @SetPaintBackgroundEnabled false
        @SetPaintBorderEnabled false
    Paint: (a, b, c, d) => derma.SkinHook 'Paint', 'Panel', @, a, b, c, d
    ApplySchemeSettings: (a, b, c, d) => derma.SkinHook 'Scheme', 'Panel', @, a, b, c, d
    PerformLayout: (a, b, c, d) => derma.SkinHook 'Layout', 'Panel', @, a, b, c, d
    SetDisabled: (@Disabled) =>
        if @Disabled
            @SetAlpha 75
            @SetMouseInputEnabled false
        else
            @SetAlpha 255
            @SetMouseInputEnabled true
    SetEnabled: (bool) => @SetDisabled not bool
    IsEnabled: => not @Disabled
    OnMousePressed: (mousecode) =>
        return @StartBoxSelection! if @IsSelectionCanvas! and not dragndrop.IsDragging!
        if @IsDraggable!
            @MouseCapture true
            @DragMousePress mousecode
    OnMouseReleased: (mousecode) =>
        return if @EndBoxSelection!
        @MouseCapture false
        return if @DragMouseRelease mousecode
    UpdateColours: =>
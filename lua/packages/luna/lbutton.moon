import ceil, min from math
class LButton extends LLabel
    DrawBorder: true
    ContentAlignment: 5
    Cursor: 'hand'
    Font: 'ChatFont'

    new: (...) =>
        super ...
        @SetContentAlignment @ContentAlignment
        @SetTall 22
        @SetMouseInputEnabled true
        @SetKeyboardInputEnabled true
        @SetCursor @Cursor
        @SetFont @Font
    IsDown: => @Depressed
    SetImage: (img) =>
        unless img
            @Image\Remove! if IsValid @Image
            return
        @Image = LImage! unless IsValid @Image
        with @Image
            if isstring img
                \SetImage img
            else
                \SetMaterial img
            \SizeToContents!
        @InvalidateLayout!
    @__base.SetIcon = @__base.SetImage
    @__base.SetMaterial = @__base.SetImage
    Paint: (w, h) =>
        derma.SkinHook 'Paint', 'Button', @, w, h
        false
    UpdateColours: (skin) =>
        with skin.Colours.Button
            @TextStyleColor = unless @IsEnabled!
                .Disabled
            elseif @IsDown! or @m_bSelected
                .Down
            elseif @Hovered
                .Hover
            else
                .Normal
    PerformLayout: (...) =>
        if IsValid @Image
            target = min @GetWide! - 4, @GetTall! - 4
            with @Image
                zoom = min target / \GetWide!, target / \GetTall!, 1
                \SetWide ceil(\GetWide! * zoom)
                \SetTall ceil(\GetTall! * zoom)
                if @GetWide! < @GetTall!
                    \SetPos 4, (@GetTall! - \GetTall!) * .5
                else
                    \SetPos 2 + (target - @Image\GetWide!) * .5, (@GetTall! - \GetTall!) * .5
                @SetTextInset \GetWide! + 16, 0
        super ...
    SetConsoleCommand: (name, args) => @DoClick = => RunConsoleCommand name, args
    SizeToContents: =>
        w, h = @GetContentSize!
        @SetSize w + 8, h + 4
    GetToggle: => @Toggle
    GetDisabled: => @Disabled
    --a thousand curses on garry for forcing me to write little handlers for his poorly extendable skin system
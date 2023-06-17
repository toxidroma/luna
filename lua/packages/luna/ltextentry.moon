class LTextEntry extends VGUI
    Base: 'TextEntry'

    EnterAllowed: true
    UpdateOnType: false
    Numeric: false
    HistoryEnabled: false
    PlaceholderText: '...'
    Disabled: false
    Colors:
        Text: nil
        Placeholder: nil
        Highlight: nil
        Cursor: nil

    new: (...) =>
        super ...
        @History = {}
        @HistoryPos = 0
        @SetPaintBorderEnabled false
        @SetPaintBackgroundEnabled false
        @SetAllowNonAsciiCharacters true
        @SetTall luna.Scale 34
        @m_bBackground = true --fucking awful variable names thanks garry
        @m_bLoseFocusOnClickAway = true --fucking awful variable names thanks garry
        @SetCursor 'beam'
        @SetFontInternal 'ChatFont'
        @SetText @PlaceholderText
    OnFocusChanged: (focus) => print focus
    IsEditing: => @ == vgui.GetKeyboardFocus!
    --FFS GARRY
    GetDisabled: => @Disabled
    GetTextColor: => @Colors.Text or @GetSkin!.colTextEntryText
    GetPlaceholderColor: => @Colors.Placeholder or @GetSkin!.colTextEntryTextPlaceholder
    GetHighlightColor: => @Colors.Highlight or @GetSkin!.colTextEntryTextHighlight
    GetCursorColor: => @Colors.Cursor or @GetSkin!.colTextEntryTextCursor
    --FFS GARRY END
    OnKeyCodeTyped: (code) =>
        @OnKeyCode code
        switch code
            when KEY_ENTER
                if @EnterAllowed and not @IsMultiline!
                    @Menu\Remove! if IsValid @Menu
                    @FocusNext!
                    @OnEnter!
                    @HistoryPos = 0
            when KEY_UP
                if @HistoryEnabled or @Menu
                    @HistoryPos -= 1
                    @UpdateFromHistory!
            when KEY_DOWN, KEY_TAB
                if @HistoryEnabled or @Menu
                    @HistoryPos += 1
                    @UpdateFromHistory!
    OnKeyCode: (code) =>
        return unless @GetParent!
        parent\OnKeyCode code if parent.OnKeyCode
    UpdateFromHistory: =>
        return @UpdateFromMenu! if IsValid @Menu
        pos = @HistoryPos
        pos = #@History if pos < 0
        pos = 0 if pos > #@History
        txt = @History[pos]
        txt or= ''
        @SetText txt
        @SetCaretPos txt\len!
        @OnTextChanged!
        @HistoryPos = pos
    UpdateFromMenu: =>
        pos = @HistoryPos
        num = @Menu\ChildCount!
        @Menu\ClearHighlights!
        pos = num if pos < 0
        pos = 0 if pos > num
        if child = @Menu\GetChild pos
            @Menu\HighlightItem child
            txt = child\GetText!
            @SetText txt
            @SetCaretPos txt\len!
            @OnTextChanged true
        else
            @SetText ''
        @HistoryPos = pos
    OnTextChanged: (preserveMenu) =>
        @HistoryPos = 0
        if @UpdateOnType
            --@UpdateConvarValue!
            @OnValueChange @GetText!
        @Menu\Remove! if IsValid @Menu and not preserveMenu
        if tab = @GetAutoComplete @GetText!
            @OpenAutoComplete tab
        @OnChange!
    OnChange: =>
        parent = @GetParent!
        parent\OnChange! if parent and parent.OnChange
    OpenAutoComplete: (tab) =>
        return unless tab
        return if #tab == 0
        @Menu = DermaMenu!
        for option in *tab
            @Menu\AddOption option, ->
                @SetText option
                @SetCaretPos option\len!
                @RequestFocus!
        x, y = @LocalToScreen 0, @GetTall!
        with @Menu
            \SetMinimumWidth @GetWide!
            \Open x, y, true, @
            \SetPos x, y
            \SetMaxHeight (ScrH! - y) - 10
    --Think: => @ConVarStringThink!
    OnEnter: =>
        --@UpdateConvarValue!
        @OnValueChange @GetText!
        parent = @GetParent!
        parent\OnEnter! if parent and parent.OnEnter
    --UpdateConvarValue: => @ConVarChanged @GetValue!
    Paint: (w, h) => 
        derma.SkinHook 'Paint', 'TextEntry', @, w, h
        false
    PerformLayout: => derma.SkinHook 'Layout', 'TextEntry', @
    SetValue: (value) =>
        return if @IsEditing!
        @SetText value
        @OnValueChange value
        @SetCaretPos @GetCaretPos!
    OnValueChange: (value) => 
        parent = @GetParent!
        parent\OnValueChange value 
    CheckNumeric: (value) =>
        return false unless @Numeric
        return true unless string.find numerics, values, 1, true
        false
    AllowInput: (value) =>
        return true if @CheckNumeric
        parent = @GetParent!
        parent\AllowInput value if parent and parent.AllowInput
    SetEditable: (enabled) =>
        @SetKeyboardInputEnabled enabled
        @SetMouseInputEnabled enabled
    OnGetFocus: =>
        print 'GOT FOCUS'
        hook.Run 'OnTextEntryGetFocus', @
        parent = @GetParent!
        parent\OnGetFocus! if parent and parent.OnGetFocus
        @SetText '' if @GetText! == @PlaceholderText
    OnLoseFocus: =>
        print 'LOST FOCUS'
        --@UpdateConvarValue!
        hook.Call 'OnTextEntryLoseFocus', nil, @
        parent\OnLoseFocus! if parent and parent.OnLoseFocus
        @SetText @PlaceholderText if @GetText\len! == 0
    OnMousePressed: (mcode) => 
        print(mcode)
        @OnGetFocus!
    AddHistory: (txt) =>
        return if txt == '' or not txt
        table.RemoveByValue @History, txt
        table.insert @History, txt
    GetAutoComplete: (txt) =>
        parent = @GetParent!
        parent\GetAutoComplete txt if parent and parent.GetAutoComplete
    GetInt: => 
        num = tonumber @GetText!
        return unless num
        math.floor num + .5
    GetFloat: => tonumber @GetText!
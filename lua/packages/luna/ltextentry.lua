local LTextEntry
do
  local _class_0
  local _parent_0 = VGUI
  local _base_0 = {
    Base = 'TextEntry',
    EnterAllowed = true,
    UpdateOnType = false,
    Numeric = false,
    HistoryEnabled = false,
    PlaceholderText = '...',
    Disabled = false,
    Colors = {
      Text = nil,
      Placeholder = nil,
      Highlight = nil,
      Cursor = nil
    },
    OnFocusChanged = function(self, focus)
      return print(focus)
    end,
    IsEditing = function(self)
      return self == vgui.GetKeyboardFocus()
    end,
    GetDisabled = function(self)
      return self.Disabled
    end,
    GetTextColor = function(self)
      return self.Colors.Text or self:GetSkin().colTextEntryText
    end,
    GetPlaceholderColor = function(self)
      return self.Colors.Placeholder or self:GetSkin().colTextEntryTextPlaceholder
    end,
    GetHighlightColor = function(self)
      return self.Colors.Highlight or self:GetSkin().colTextEntryTextHighlight
    end,
    GetCursorColor = function(self)
      return self.Colors.Cursor or self:GetSkin().colTextEntryTextCursor
    end,
    OnKeyCodeTyped = function(self, code)
      self:OnKeyCode(code)
      local _exp_0 = code
      if KEY_ENTER == _exp_0 then
        if self.EnterAllowed and not self:IsMultiline() then
          if IsValid(self.Menu) then
            self.Menu:Remove()
          end
          self:FocusNext()
          self:OnEnter()
          self.HistoryPos = 0
        end
      elseif KEY_UP == _exp_0 then
        if self.HistoryEnabled or self.Menu then
          self.HistoryPos = self.HistoryPos - 1
          return self:UpdateFromHistory()
        end
      elseif KEY_DOWN == _exp_0 or KEY_TAB == _exp_0 then
        if self.HistoryEnabled or self.Menu then
          self.HistoryPos = self.HistoryPos + 1
          return self:UpdateFromHistory()
        end
      end
    end,
    OnKeyCode = function(self, code)
      if not (self:GetParent()) then
        return 
      end
      if parent.OnKeyCode then
        return parent:OnKeyCode(code)
      end
    end,
    UpdateFromHistory = function(self)
      if IsValid(self.Menu) then
        return self:UpdateFromMenu()
      end
      local pos = self.HistoryPos
      if pos < 0 then
        pos = #self.History
      end
      if pos > #self.History then
        pos = 0
      end
      local txt = self.History[pos]
      txt = txt or ''
      self:SetText(txt)
      self:SetCaretPos(txt:len())
      self:OnTextChanged()
      self.HistoryPos = pos
    end,
    UpdateFromMenu = function(self)
      local pos = self.HistoryPos
      local num = self.Menu:ChildCount()
      self.Menu:ClearHighlights()
      if pos < 0 then
        pos = num
      end
      if pos > num then
        pos = 0
      end
      do
        local child = self.Menu:GetChild(pos)
        if child then
          self.Menu:HighlightItem(child)
          local txt = child:GetText()
          self:SetText(txt)
          self:SetCaretPos(txt:len())
          self:OnTextChanged(true)
        else
          self:SetText('')
        end
      end
      self.HistoryPos = pos
    end,
    OnTextChanged = function(self, preserveMenu)
      self.HistoryPos = 0
      if self.UpdateOnType then
        self:OnValueChange(self:GetText())
      end
      if IsValid(self.Menu and not preserveMenu) then
        self.Menu:Remove()
      end
      do
        local tab = self:GetAutoComplete(self:GetText())
        if tab then
          self:OpenAutoComplete(tab)
        end
      end
      return self:OnChange()
    end,
    OnChange = function(self)
      local parent = self:GetParent()
      if parent and parent.OnChange then
        return parent:OnChange()
      end
    end,
    OpenAutoComplete = function(self, tab)
      if not (tab) then
        return 
      end
      if #tab == 0 then
        return 
      end
      self.Menu = DermaMenu()
      for _index_0 = 1, #tab do
        local option = tab[_index_0]
        self.Menu:AddOption(option, function()
          self:SetText(option)
          self:SetCaretPos(option:len())
          return self:RequestFocus()
        end)
      end
      local x, y = self:LocalToScreen(0, self:GetTall())
      do
        local _with_0 = self.Menu
        _with_0:SetMinimumWidth(self:GetWide())
        _with_0:Open(x, y, true, self)
        _with_0:SetPos(x, y)
        _with_0:SetMaxHeight((ScrH() - y) - 10)
        return _with_0
      end
    end,
    OnEnter = function(self)
      self:OnValueChange(self:GetText())
      local parent = self:GetParent()
      if parent and parent.OnEnter then
        return parent:OnEnter()
      end
    end,
    Paint = function(self, w, h)
      derma.SkinHook('Paint', 'TextEntry', self, w, h)
      return false
    end,
    PerformLayout = function(self)
      return derma.SkinHook('Layout', 'TextEntry', self)
    end,
    SetValue = function(self, value)
      if self:IsEditing() then
        return 
      end
      self:SetText(value)
      self:OnValueChange(value)
      return self:SetCaretPos(self:GetCaretPos())
    end,
    OnValueChange = function(self, value)
      local parent = self:GetParent()
      return parent:OnValueChange(value)
    end,
    CheckNumeric = function(self, value)
      if not (self.Numeric) then
        return false
      end
      if not (string.find(numerics, values, 1, true)) then
        return true
      end
      return false
    end,
    AllowInput = function(self, value)
      if self.CheckNumeric then
        return true
      end
      local parent = self:GetParent()
      if parent and parent.AllowInput then
        return parent:AllowInput(value)
      end
    end,
    SetEditable = function(self, enabled)
      self:SetKeyboardInputEnabled(enabled)
      return self:SetMouseInputEnabled(enabled)
    end,
    OnGetFocus = function(self)
      print('GOT FOCUS')
      hook.Run('OnTextEntryGetFocus', self)
      local parent = self:GetParent()
      if parent and parent.OnGetFocus then
        parent:OnGetFocus()
      end
      if self:GetText() == self.PlaceholderText then
        return self:SetText('')
      end
    end,
    OnLoseFocus = function(self)
      print('LOST FOCUS')
      hook.Call('OnTextEntryLoseFocus', nil, self)
      if parent and parent.OnLoseFocus then
        parent:OnLoseFocus()
      end
      if self.GetText:len() == 0 then
        return self:SetText(self.PlaceholderText)
      end
    end,
    OnMousePressed = function(self, mcode)
      print(mcode)
      return self:OnGetFocus()
    end,
    AddHistory = function(self, txt)
      if txt == '' or not txt then
        return 
      end
      table.RemoveByValue(self.History, txt)
      return table.insert(self.History, txt)
    end,
    GetAutoComplete = function(self, txt)
      local parent = self:GetParent()
      if parent and parent.GetAutoComplete then
        return parent:GetAutoComplete(txt)
      end
    end,
    GetInt = function(self)
      local num = tonumber(self:GetText())
      if not (num) then
        return 
      end
      return math.floor(num + .5)
    end,
    GetFloat = function(self)
      return tonumber(self:GetText())
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.History = { }
      self.HistoryPos = 0
      self:SetPaintBorderEnabled(false)
      self:SetPaintBackgroundEnabled(false)
      self:SetAllowNonAsciiCharacters(true)
      self:SetTall(luna.Scale(34))
      self.m_bBackground = true
      self.m_bLoseFocusOnClickAway = true
      self:SetCursor('beam')
      self:SetFontInternal('ChatFont')
      return self:SetText(self.PlaceholderText)
    end,
    __base = _base_0,
    __name = "LTextEntry",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  LTextEntry = _class_0
  return _class_0
end

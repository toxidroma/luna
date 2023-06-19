local ceil, min
do
  local _obj_0 = math
  ceil, min = _obj_0.ceil, _obj_0.min
end
local lp
local ButtonHover
do
  local _class_0
  local _parent_0 = SOUND
  local _base_0 = {
    sound = 'luna/buttonrollover.ogg'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "ButtonHover",
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
  ButtonHover = _class_0
end
local ButtonDown
do
  local _class_0
  local _parent_0 = SOUND
  local _base_0 = {
    sound = 'luna/buttonclick.ogg'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "ButtonDown",
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
  ButtonDown = _class_0
end
local ButtonUp
do
  local _class_0
  local _parent_0 = SOUND
  local _base_0 = {
    sound = 'luna/buttonclickrelease.ogg'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "ButtonUp",
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
  ButtonUp = _class_0
end
local LButton
do
  local _class_0
  local _parent_0 = VGUI
  local _base_0 = {
    m_bBackground = true,
    Toggler = false,
    DoToggle = function(self, ...)
      if not (self.Toggler) then
        return 
      end
      self.Toggled = not self.Toggled
      return self:OnToggled(self.Toggled, ...)
    end,
    OnMousePressed = function(self, mouseCode)
      if not (self:IsEnabled()) then
        return 
      end
      if not (lp) then
        lp = LocalPlayer()
      end
      if self:IsSelectable() and mouseCode == MOUSE_LEFT and (input.IsShiftDown() or input.IsControlDown()) and not (lp:KeyDown(IN_FORWARD or lp:KeyDown(IN_BACK or lp:KeyDown(IN_MOVELEFT or lp:KeyDown(IN_MOVERIGHT))))) then
        return self:StartBoxSelection()
      end
      self:MouseCapture(true)
      self.Depressed = true
      LocalPlayer():EmitSound('ButtonDown')
      self:OnPressed(mouseCode)
      return self:DragMousePress(mouseCode)
    end,
    OnMouseReleased = function(self, mouseCode)
      self:MouseCapture(false)
      if not (self:IsEnabled()) then
        return 
      end
      if not self.Depressed and dragndrop.m_DraggingMain ~= self then
        return 
      end
      if self.Depressed then
        self.Depressed = nil
        self:OnReleased(mouseCode)
      end
      if self:DragMouseRelease(mouseCode) then
        return 
      end
      if self:IsSelectable() and mouseCode == MOUSE_LEFT then
        if self:GetSelectionCanvas() then
          self.GetSelectionCanvas:UnselectAll()
        end
      end
      if not (self.Hovered) then
        return 
      end
      LocalPlayer():EmitSound('ButtonUp')
      self.Depressed = true
      local _exp_0 = mouseCode
      if MOUSE_LEFT == _exp_0 then
        self:DoClick()
      elseif MOUSE_RIGHT == _exp_0 then
        self:DoRightClick()
      elseif MOUSE_MIDDLE == _exp_0 then
        self:DoMiddleClick()
      end
      self.Depressed = nil
    end,
    Paint = function(self, w, h)
      derma.SkinHook('Paint', 'Button', self, w, h)
      return false
    end,
    IsDown = function(self)
      return self.Depressed
    end,
    OnPressed = function(self, mouseCode) end,
    OnReleased = function(self, mouseCode) end,
    OnToggled = function(self, enabled) end,
    DoClick = function(self, ...)
      return self:DoToggle(...)
    end,
    DoRightClick = function(self) end,
    DoMiddleClick = function(self) end,
    Think = function(self)
      if not (self.HoveredLast) then
        if self.Hovered then
          self.HoveredLast = true
          return LocalPlayer():EmitSound('ButtonHover')
        end
      elseif not self.Hovered then
        self.HoveredLast = false
      end
    end,
    GetToggle = function(self)
      return self.Toggled
    end,
    GetDisabled = function(self)
      return not self.IsEnabled
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.Toggled = false
      self:SetMouseInputEnabled(true)
      self:SetCursor('hand')
      local sz = luna.Scale(32)
      return self:SetSize(sz, sz)
    end,
    __base = _base_0,
    __name = "LButton",
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
  LButton = _class_0
  return _class_0
end

local LPanel
do
  local _class_0
  local _parent_0 = VGUI
  local _base_0 = {
    Base = 'Panel',
    PaintBackground = true,
    IsMenu = false,
    TabbingDisabled = false,
    Disabled = false,
    BackgroundColor = nil,
    Paint = function(self, a, b, c, d)
      return derma.SkinHook('Paint', 'Panel', self, a, b, c, d)
    end,
    ApplySchemeSettings = function(self, a, b, c, d)
      return derma.SkinHook('Scheme', 'Panel', self, a, b, c, d)
    end,
    PerformLayout = function(self, a, b, c, d)
      return derma.SkinHook('Layout', 'Panel', self, a, b, c, d)
    end,
    SetDisabled = function(self, Disabled)
      self.Disabled = Disabled
      if self.Disabled then
        self:SetAlpha(75)
        return self:SetMouseInputEnabled(false)
      else
        self:SetAlpha(255)
        return self:SetMouseInputEnabled(true)
      end
    end,
    SetEnabled = function(self, bool)
      return self:SetDisabled(not bool)
    end,
    IsEnabled = function(self)
      return not self.Disabled
    end,
    OnMousePressed = function(self, mousecode)
      if self:IsSelectionCanvas() and not dragndrop.IsDragging() then
        return self:StartBoxSelection()
      end
      if self:IsDraggable() then
        self:MouseCapture(true)
        return self:DragMousePress(mousecode)
      end
    end,
    OnMouseReleased = function(self, mousecode)
      if self:EndBoxSelection() then
        return 
      end
      self:MouseCapture(false)
      if self:DragMouseRelease(mousecode) then
        return 
      end
    end,
    UpdateColours = function(self) end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self:SetPaintBackgroundEnabled(false)
      return self:SetPaintBorderEnabled(false)
    end,
    __base = _base_0,
    __name = "LPanel",
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
  LPanel = _class_0
  return _class_0
end

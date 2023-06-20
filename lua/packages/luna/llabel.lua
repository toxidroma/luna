local SetFont, GetTextSize
do
  local _obj_0 = surface
  SetFont, GetTextSize = _obj_0.SetFont, _obj_0.GetTextSize
end
local Ellipses, Wrap, Draw
do
  local _obj_0 = luna.Text
  Ellipses, Wrap, Draw = _obj_0.Ellipses, _obj_0.Wrap, _obj_0.Draw
end
local LLabel
do
  local _class_0
  local _parent_0 = VGUI
  local _base_0 = {
    Text = 'Label',
    Font = 'ChatFont',
    TextAlign = TEXT_ALIGN_LEFT,
    TextColor = color_white,
    Ellipses = false,
    AutoWidth = false,
    AutoHeight = false,
    AutoWrap = false,
    SetText = function(self, Text)
      self.Text = Text
      self.OriginalText = self.Text
    end,
    CalculateSize = function(self)
      SetFont(self.Font)
      return GetTextSize(self.Text)
    end,
    PerformLayout = function(self, w, h)
      local dW, dH = self:CalculateSize()
      if self.AutoWidth then
        self:SetWide(dW)
      end
      if self.AutoHeight then
        self:SetTall(dH)
      end
      if not (self.OriginalText) then
        self.OriginalText = self.Text
      end
      self.Text = Wrap(self.OriginalText, w, self.Font)
    end,
    Paint = function(self, w, h)
      local align = self.TextAlign
      local text
      if self.Ellipses then
        text = Ellipses(self.Text, w, self.Font)
      else
        text = self.Text
      end
      local _exp_0 = align
      if TEXT_ALIGN_CENTER == _exp_0 then
        return Draw(text, self.Font, w / 2, 0, self.TextColor, align)
      elseif TEXT_ALIGN_RIGHT == _exp_0 then
        return Draw(text, self.Font, w, 0, self.TextColor, align)
      else
        return Draw(text, self.Font, 0, 0, self.TextColor)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "LLabel",
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
  LLabel = _class_0
  return _class_0
end

local Clamp
Clamp = math.Clamp
local MouseX, MouseY
do
  local _obj_0 = gui
  MouseX, MouseY = _obj_0.MouseX, _obj_0.MouseY
end
local LButton, LLabel
do
  local _obj_0 = luna
  LButton, LLabel = _obj_0.LButton, _obj_0.LLabel
end
local size = luna.Scale(200)
local LFrame
do
  local _class_0
  local _parent_0 = VGUI
  local _base_0 = {
    Base = 'EditablePanel',
    Title = 'Window',
    Width = 320,
    Height = 200,
    IsMenu = false,
    DeleteOnClose = true,
    Draggable = true,
    Sizable = false,
    MinWidth = size,
    MinHeight = size,
    ScreenLock = true,
    DeleteOnClose = true,
    BackgroundBlur = false,
    PaintShadow = true,
    ShowCloseButton = function(self, bShow)
      return self.btnClose:SetVisible(bShow)
    end,
    GetTitle = function(self)
      return self.lblTitle:GetText()
    end,
    SetTitle = function(self, strTitle)
      return self.lblTitle:SetText(strTitle)
    end,
    Close = function(self)
      self:SetVisible(false)
      if self.DeleteOnClose then
        self:Remove()
      end
      return self:OnClose()
    end,
    OnClose = function(self) end,
    Center = function(self)
      self:InvalidateLayout(true)
      self:CenterVertical()
      return self:CenterHorizontal()
    end,
    IsActive = function(self)
      if self:HasFocus() or vgui.FocusedHasParent(self) then
        return true
      end
    end,
    SetIcon = function(self, str)
      if not str and IsValid(self.imgIcon) then
        return self.imgIcon:Remove()
      end
      if not (IsValid(self.imgIcon)) then
        self.imgIcon = LImage()
      end
      if IsValid(self.imgIcon) then
        return self.imgIcon:SetMaterial(Material(str))
      end
    end,
    Think = function(self)
      local sW, sH = ScrW(), ScrH()
      local mX = Clamp(MouseX(), 1, sW - 1)
      local mY = Clamp(MouseY(), 1, sH - 1)
      local w, h = self:GetWide(), self:GetTall()
      if self.Dragging then
        local x = mX - self.Dragging[1]
        local y = mY - self.Dragging[2]
        if self.ScreenLock then
          x = Clamp(x, 0, sW - w)
          y = Clamp(y, 0, sH - h)
        end
        self:SetPos(x, y)
      end
      if self.Sizing then
        local x = mX - self.Sizing[1]
        local y = mY - self.Sizing[2]
        local pX, pY = self:GetPos()
        if x < self.MinWidth then
          x = self.MinWidth
        elseif x > sW - pX and self.ScreenLock then
          x = sW - pX
        end
        if y < self.MinHeight then
          y = self.MinHeight
        elseif y > sH - pY and self.ScreenLock then
          y = sH - pY
        end
        self:SetSize(x, y)
        return self:SetCursor('sizenwse')
      end
      local sX, sY = self:LocalToScreen(0, 0)
      if self.Hovered and self.Sizable and mX > (sX + w - 20) and mY > (sY + h - 20) then
        return self:SetCursor('sizenwse')
      end
      if self.Hovered and self.Draggable and mY < (sY + 24) then
        return self:SetCursor('sizeall')
      end
      self:SetCursor('arrow')
      if self.y < 0 then
        return self:SetPos(self.x, 0)
      end
    end,
    Paint = function(self, w, h)
      if self.BackgroundBlur then
        Derma_DrawBackgroundBlur(self, self.timeBirth)
      end
      derma.SkinHook('Paint', 'Frame', self, w, h)
      return true
    end,
    OnMousePressed = function(self)
      local sX, sY = self:LocalToScreen(0, 0)
      local mX, mY = MouseX(), MouseY()
      if self.Sizable and mX > (sX + w - 20) and mY > (sY + h - 20) then
        self.Sizing = {
          mX - w,
          mY - h
        }
        return self:MouseCapture(true)
      end
      if self.Draggable and mY < (sY + 24) then
        self.Dragging = {
          mX - self.x,
          mY - self.y
        }
        return self:MouseCapture(true)
      end
    end,
    OnMouseReleased = function(self)
      self.Dragging = nil
      self.Sizing = nil
      return self:MouseCapture(false)
    end,
    PerformLayout = function(self)
      local titlePush = 0
      if IsValid(self.imgIcon) then
        do
          local _with_0 = self.imgIcon
          _with_0:SetPos(5, 5)
          _with_0:SetSize(16, 16)
          titlePush = 16
        end
      end
      local w = self:GetWide()
      do
        local _with_0 = self.btnClose
        _with_0:SetPos(w - 31 - 4, 0)
        _with_0:SetSize(31, 24)
      end
      do
        local _with_0 = self.lblTitle
        _with_0:SetPos(8 + titlePush, 2)
        _with_0:SetSize(w - 25 - titlePush, 20)
        return _with_0
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      _class_0.__parent.__init(self, x, y)
      self:SetFocusTopLevel(true)
      do
        local _with_0 = LButton()
        self.btnClose = _with_0
        self:Add(self.btnClose)
        _with_0:SetText('')
        _with_0.DoClick = function()
          return self:Close()
        end
        _with_0.Paint = function(panel, w, h)
          return derma.SkinHook('Paint', 'WindowCloseButton', panel, w, h)
        end
      end
      do
        local _with_0 = LLabel()
        self.lblTitle = _with_0
        self:Add(self.lblTitle)
        _with_0:SetMouseInputEnabled(false)
        _with_0.UpdateColours = function(label, skin)
          local color = skin.Colours.Window.TitleInactive
          if self:IsActive() then
            color = skin.Colours.Window.TitleActive
          end
          _with_0.TextStyleColor = color
        end
        _with_0:SetText(self.Title)
      end
      self:SetPaintBackgroundEnabled(false)
      self:SetPaintBorderEnabled(false)
      self.timeBirth = SysTime()
      return self:DockPadding(5, 24 + 5, 5, 5)
    end,
    __base = _base_0,
    __name = "LFrame",
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
  LFrame = _class_0
  return _class_0
end

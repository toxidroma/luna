local SetMaterial, SetDrawColor, DrawTexturedRect
do
  local _obj_0 = surface
  SetMaterial, SetDrawColor, DrawTexturedRect = _obj_0.SetMaterial, _obj_0.SetDrawColor, _obj_0.DrawTexturedRect
end
local LImage
do
  local _class_0
  local _parent_0 = luna.LPanel
  local _base_0 = {
    Color = color_white,
    ImageName = '',
    MatName = '',
    FailsafeMatName = '',
    KeepAspect = false,
    ActualWidth = 10,
    ActualHeight = 10,
    Unloaded = function(self)
      return self.MatName ~= nil
    end,
    LoadMaterial = function(self)
      if not (self:Unloaded()) then
        return 
      end
      self:DoLoadMaterial()
      self.MatName = nil
    end,
    DoLoadMaterial = function(self)
      self:SetMaterial(Material(self.MatName))
      if self.Material:IsError() and self.FailsafeMatName then
        self:SetMaterial(Material(self.FailsafeMatName))
      end
      self:FixVertexLitMaterial()
      return self:InvalidateParent()
    end,
    SetMaterial = function(self, mat, backup)
      if isstring(mat) then
        if backup and not file.Exists("materials/" .. tostring(mat) .. ".vmt", 'GAME') and not file.Exists("materials/" .. tostring(mat), 'GAME') then
          mat = backup
        end
        self.ImageName = mat
        self:SetMaterial(Material(img))
        self:FixVertexLitMaterial()
      end
      self.Material = mat
      if not (self.Material) then
        return 
      end
      local texture = self.Material:GetTexture('$basetexture')
      if texture then
        self.ActualWidth = texture:Width()
        self.ActualHeight = texture:Height()
      else
        self.ActualWidth = self.Material:Width()
        self.ActualHeight = self.Material:Height()
      end
    end,
    FixVertexLitMaterial = function(self)
      local mat = self.Material
      local img = mat:GetName()
      local shader = mat:GetShader()
      if shader:find('VertexLitGeneric') or shader:find('Cable') then
        local t = mat:GetString('$basetexture')
        if t then
          local params = {
            ['$basetexture'] = t,
            ['$vertexcolor'] = 1,
            ['$vertexalpha'] = 1
          }
          mat = CreateMaterial(tostring(img) .. "_LImage", 'UnlitGeneric', params)
        end
      end
      return self:SetMaterial(mat)
    end,
    SizeToContents = function(self)
      return self:SetSize(self.ActualWidth, self.ActualHeight)
    end,
    Paint = function(self)
      return self:PaintAt(0, 0, self:GetWide(), self:GetTall())
    end,
    PaintAt = function(self, x, y, dw, dh)
      if dw == nil then
        dw = self:GetWide()
      end
      if dh == nil then
        dh = self:GetTall()
      end
      self:LoadMaterial()
      if not (self.Material) then
        return true
      end
      SetMaterial(self.Material)
      do
        local _with_0 = self.Color
        SetDrawColor(_with_0.r, _with_0.g, _with_0.b, _with_0.a)
      end
      if self.KeepAspect then
        local w, h = self.ActualWidth, self.ActualHeight
        if w > dw and h > dh then
          do
            local diff = dw / w
            w = w * diff
            h = h * diff
          end
          do
            local diff = dh / h
            w = w * diff
            h = h * diff
          end
        end
        if w < dw then
          do
            local diff = dw / w
            w = w * diff
            h = h * diff
          end
        end
        do
          local _with_0 = h < dh
          do
            local diff = dh / h
            w = w * diff
            h = h * diff
          end
        end
        local offX, offY = (dw - w) * .5, (dh - h) * .5
        DrawTexturedRect(offX + x, offY + y, w, h)
        local _ = true
      end
      DrawTexturedRect(x, y, dw, dh)
      return true
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "LImage",
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
  LImage = _class_0
  return _class_0
end

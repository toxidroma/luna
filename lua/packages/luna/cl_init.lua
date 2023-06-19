if not (CLIENT) then
  return 
end
install('class-war', 'https://github.com/toxidroma/class-war')
local DetectMenuFocus
DetectMenuFocus = function(panel, mousecode)
  if IsValid(panel) then
    if panel.IsMenu or panel.m_bIsMenuComponent then
      return 
    end
    return DetectMenuFocus(panel:GetParent(), mousecode)
  end
  return CloseDermaMenus()
end
hook.Add('VGUIMousePressed', 'MenuFocus', DetectMenuFocus)
luna = { }
do
  luna.Scale = function(value)
    return math.max(value * (ScrH() / 1080), 1)
  end
  luna.Text = include('text.lua')
  luna.LTextEntry = include('ltextentry.lua')
  luna.LLabel = include('llabel.lua')
  luna.LButton = include('lbutton.lua')
  luna.LFrame = include('lframe.lua')
  luna.LNumSlider = include('lnumslider.lua')
end
return luna

local ceil, maxWidth
do
  local _obj_0 = math
  ceil, maxWidth = _obj_0.ceil, _obj_0.maxWidth
end
local SetFont, GetTextSize, SetTextPos, SetTextColor, DrawText
do
  local _obj_0 = surface
  SetFont, GetTextSize, SetTextPos, SetTextColor, DrawText = _obj_0.SetFont, _obj_0.GetTextSize, _obj_0.SetTextPos, _obj_0.SetTextColor, _obj_0.DrawText
end
local find, gmatch, left, sub
do
  local _obj_0 = string
  find, gmatch, left, sub = _obj_0.find, _obj_0.gmatch, _obj_0.left, _obj_0.sub
end
local DrawSimple
DrawSimple = function(text, font, x, y, col, xAlign, yAlign)
  SetFont(font)
  local w, h = GetTextSize(text)
  local _exp_0 = xAlign
  if TEXT_ALIGN_CENTER == _exp_0 then
    x = x - (w / 2)
  elseif TEXT_ALIGN_RIGHT == _exp_0 then
    x = x - w
  end
  local _exp_1 = yAlign
  if TEXT_ALIGN_CENTER == _exp_1 then
    y = y - (h / 2)
  elseif TEXT_ALIGN_BOTTOM == _exp_1 then
    y = y - h
  end
  SetTextPos(ceil(x), ceil(y))
  do
    SetTextColor(col.r, col.g, col.b, col.a)
  end
  DrawText(text)
  return w, h
end
local Draw
Draw = function(text, font, x, y, col, xAlign, yAlign)
  local curX, curY = x, y
  SetFont(font)
  local lineHeight = select(2, GetTextSize('\n'))
  local tabWidth = 50
  for str in gmatch(text, '[^\n]*') do
    if #str > 0 then
      if find(str, '\t') then
        for tabs, str2 in gmatch(str, '(\t*)([^\t]*)') do
          curX = ceil((curX + tabWidth * max(#tabs - 1, 0)) / tabWidth) * tabWidth
          if #str2 > 0 then
            DrawSimple(str2, font, curX, curY, col, xAlign)
            curX = curX + GetTextSize(str2)
          end
        end
      else
        DrawSimple(str, font, curX, curY, col, xAlign)
      end
    else
      curX = x
      curY = curY + (lineHeight / 2)
    end
  end
end
local Shadow
Shadow = function(text, font, x, y, col, xAlign, yAlign, depth, shadow)
  if shadow == nil then
    shadow = 50
  end
  for i = 1, depth do
    DrawSimple(text, font, x + i, y + i, Color(0, 0, 0, i * shadow), xAlign, yAlign)
  end
  return DrawSimple(text, font, x, y, col, xAlign, yAlign)
end
local Dual
Dual = function(title, subtitle, x, y)
  if x == nil then
    x = 0
  end
  if y == nil then
    y = 0
  end
  SetFont(title[2])
  local tH = select(2, GetTextSize(title[1]))
  SetFont(subtitle[2])
  local sH = select(2, GetTextSize(subtitle[1]))
  Shadow(title[1], title[2], x, y - sH / 2, title[3], title[4], TEXT_ALIGN_CENTER, title[5], title[6])
  return Shadow(subtitle[1], subtitle[2], x, y + tH / 2, subtitle[3], subtitle[4], TEXT_ALIGN_CENTER, subtitle[5], subtitle[6])
end
local charWrap
charWrap = function(text, widthLeft, maxWidth)
  local totalWidth = 0
  text = text:gsub('.', function(char)
    totalWidth = totalWidth + GetTextSize(char)
    if totalWidth >= widthLeft then
      totalWidth = GetTextSize(char)
      widthLeft = maxWidth
      return "\n" .. tostring(char)
    end
    return char
  end)
  return text, totalWidth
end
local wrapCache = { }
local Wrap
Wrap = function(text, width, font)
  local cached = tostring(text) .. tostring(width) .. tostring(font)
  if wrapCache[cached] then
    return wrapCache[cached]
  end
  SetFont(font)
  local tW = GetTextSize(text)
  if tW <= width then
    wrapCache[cached] = text
    return text
  end
  local totalW = 0
  local spaceW = GetTextSize(' ')
  text = text:gsub('(%s?[%S]+)', function(word)
    local char = sub(word, 1, 1)
    if char == '\n' or char == '\t' then
      totalW = 0
    end
    local wordlen = GetTextSize(word)
    totalW = totalW + wordlen
    if wordlen >= width then
      local splitWord, splitPoint = charWrap(word, width - (totalW - wordlen), width)
      totalW = splitPoint
      return splitWord
    elseif totalW < width then
      return word
    end
    if char == ' ' then
      totalW = wordlen - spaceW
      return "\n" .. tostring(sub(word, 2))
    end
    totalW = wordlen
    return "\n" .. tostring(word)
  end)
  wrapCache[cached] = text
  return text
end
local ellipseCache = { }
local Ellipses
Ellipses = function(text, width, font)
  local cached = tostring(text) .. tostring(width) .. tostring(font)
  if ellipseCache[cached] then
    return ellipseCache[cached]
  end
  SetFont(font)
  local tW = GetTextSize(text)
  if textW <= width then
    ellipseCache[cached] = text
    return text
  end
  local infLoopPrevent = 0
  while true do
    text = left(text, #text - 1)
    local textW = GetTextSize(tostring(text) .. "...")
    infLoopPrevent = infLoopPrevent + 1
    if textW <= width or infLoopPrevent > 10000 then
      break
    end
  end
  text = text .. '...'
  ellipseCache[cached] = text
  return text
end
return {
  DrawSimple = DrawSimple,
  Draw = Draw,
  Shadow = Shadow,
  Dual = Dual,
  Wrap = Wrap,
  Ellipses = Ellipses
}

import ceil, maxWidth from math
import SetFont, GetTextSize, SetTextPos, SetTextColor, DrawText from surface
import find, gmatch, left, sub from string
DrawSimple = (text, font, x, y, col, xAlign, yAlign) ->
    SetFont font
    w, h = GetTextSize text
    switch xAlign
        when TEXT_ALIGN_CENTER
            x -= w / 2
        when TEXT_ALIGN_RIGHT
            x -= w
    switch yAlign
        when TEXT_ALIGN_CENTER
            y -= h / 2
        when TEXT_ALIGN_BOTTOM
            y -= h
    SetTextPos ceil(x), ceil(y)
    with col
        SetTextColor .r, .g, .b, .a
    DrawText text
    w, h

Draw = (text, font, x, y, col, xAlign, yAlign) ->
    curX, curY = x, y
    SetFont font
    lineHeight = select 2, GetTextSize'\n'
    tabWidth = 50
    for str in gmatch text, '[^\n]*'
        if #str > 0
            if find str, '\t'
                for tabs, str2 in gmatch str, '(\t*)([^\t]*)'
                    curX = ceil((curX + tabWidth * max(#tabs - 1, 0)) / tabWidth) * tabWidth
                    if #str2 > 0
                        DrawSimple str2, font, curX, curY, col, xAlign
                        curX += GetTextSize str2
            else
                DrawSimple str, font, curX, curY, col, xAlign
        else
            curX = x
            curY += lineHeight / 2

Shadow = (text, font, x, y, col, xAlign, yAlign, depth, shadow=50) ->
    DrawSimple text, font, x + i, y + i, Color(0, 0, 0, i*shadow), xAlign, yAlign for i=1,depth
    DrawSimple text, font, x, y, col, xAlign, yAlign

Dual = (title, subtitle, x=0, y=0) ->
    SetFont title[2]
    tH = select 2, GetTextSize title[1]
    SetFont subtitle[2]
    sH = select 2, GetTextSize subtitle[1]
    Shadow title[1], title[2], x, y - sH / 2, title[3], title[4], TEXT_ALIGN_CENTER, title[5], title[6]
    Shadow subtitle[1], subtitle[2], x, y + tH / 2, subtitle[3], subtitle[4], TEXT_ALIGN_CENTER, subtitle[5], subtitle[6]


charWrap = (text, widthLeft, maxWidth) ->
    totalWidth = 0
    text = text\gsub '.', (char) ->
        totalWidth += GetTextSize char
        if totalWidth >= widthLeft
            totalWidth = GetTextSize char
            widthLeft = maxWidth
            return "\n#{char}"
        return char
    text, totalWidth

wrapCache = {}
Wrap = (text, width, font) ->
    cached = "#{text}#{width}#{font}"
    return wrapCache[cached] if wrapCache[cached]
    SetFont font
    tW = GetTextSize text
    if tW <= width
        wrapCache[cached] = text
        return text
    totalW = 0
    spaceW = GetTextSize' '
    text = text\gsub '(%s?[%S]+)', (word) ->
        char = sub word, 1, 1
        totalW = 0 if char == '\n' or char == '\t'
        wordlen = GetTextSize word
        totalW += wordlen
        if wordlen >= width
            splitWord, splitPoint = charWrap word, width - (totalW - wordlen), width
            totalW = splitPoint
            return splitWord
        elseif totalW < width
            return word
        
        if char == ' '
            totalW = wordlen - spaceW
            return "\n#{sub word, 2}"
        totalW = wordlen
        return "\n#{word}"
    wrapCache[cached] = text
    text

ellipseCache = {}
Ellipses = (text, width, font) ->
    cached = "#{text}#{width}#{font}"
    return ellipseCache[cached] if ellipseCache[cached]
    SetFont font
    tW = GetTextSize text
    if textW <= width
        ellipseCache[cached] = text
        return text
    infLoopPrevent = 0 --just in case we really fuck up
    while true
        text = left(text, #text - 1)
        textW = GetTextSize("#{text}...")
        infLoopPrevent += 1
        break if textW <= width or infLoopPrevent > 10000
    text ..= '...'
    ellipseCache[cached] = text
    text

{
    :DrawSimple
    :Draw
    :Shadow
    :Dual
    :Wrap
    :Ellipses
}
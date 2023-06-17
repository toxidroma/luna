import SetFont, GetTextSize from surface
import Ellipses, Wrap, Draw from luna.Text
class LLabel extends VGUI
    Text: 'Label'
    Font: 'ChatFont'
    TextAlign: TEXT_ALIGN_LEFT
    TextColor: color_white
    Ellipses: false
    AutoWidth: false
    AutoHeight: false
    AutoWrap: false
    SetText: (@Text) => @OriginalText = @Text
    CalculateSize: =>
        SetFont @Font
        GetTextSize @Text
    PerformLayout: (w, h) =>
        dW, dH = @CalculateSize!
        @SetWide dW if @AutoWidth
        @SetTall dH if @AutoHeight
        @OriginalText = @Text unless @OriginalText
        @Text = Wrap @OriginalText, w, @Font
    Paint: (w, h) =>
        align = @TextAlign
        text = if @Ellipses
            Ellipses @Text, w, @Font
        else
            @Text
        switch align
            when TEXT_ALIGN_CENTER
                return Draw text, @Font, w/2, 0, @TextColor, align
            when TEXT_ALIGN_RIGHT
                return Draw text, @Font, w, 0, @TextColor, align
            else
                return Draw text, @Font, 0, 0, @TextColor
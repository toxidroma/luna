import SetMaterial, SetDrawColor, DrawTexturedRect from surface
class LImage extends luna.LPanel
    Color: color_white
    ImageName: ''
    MatName: ''
    FailsafeMatName: ''
    KeepAspect: false
    ActualWidth: 10
    ActualHeight: 10
    Unloaded: => @MatName != nil
    LoadMaterial: =>
        return unless @Unloaded!
        @DoLoadMaterial!
        @MatName = nil
    DoLoadMaterial: =>
        @SetMaterial Material @MatName
        @SetMaterial Material @FailsafeMatName if @Material\IsError! and @FailsafeMatName
        @FixVertexLitMaterial!
        @InvalidateParent!
    SetMaterial: (mat, backup) =>
        if isstring mat
            mat = backup if backup and not file.Exists("materials/#{mat}.vmt", 'GAME') and not file.Exists("materials/#{mat}", 'GAME')
            @ImageName = mat
            @SetMaterial Material img
            @FixVertexLitMaterial!
        @Material = mat
        return unless @Material
        texture = @Material\GetTexture'$basetexture'
        if texture
            @ActualWidth = texture\Width!
            @ActualHeight = texture\Height!
        else
            @ActualWidth = @Material\Width!
            @ActualHeight = @Material\Height!
    FixVertexLitMaterial: =>
        mat = @Material
        img = mat\GetName!
        shader = mat\GetShader!
        if shader\find'VertexLitGeneric' or shader\find'Cable'
            t = mat\GetString'$basetexture'
            if t
                params = 
                    '$basetexture': t
                    '$vertexcolor': 1
                    '$vertexalpha': 1
                mat = CreateMaterial "#{img}_LImage", 'UnlitGeneric', params
        @SetMaterial mat
    SizeToContents: => @SetSize @ActualWidth, @ActualHeight
    Paint: => @PaintAt 0, 0, @GetWide!, @GetTall!
    PaintAt: (x, y, dw=@GetWide!, dh=@GetTall!) =>
        @LoadMaterial!
        return true unless @Material
        SetMaterial @Material
        with @Color
            SetDrawColor .r, .g, .b, .a
        if @KeepAspect
            w, h = @ActualWidth, @ActualHeight
            if w > dw and h > dh
                with diff = dw / w
                    w *= diff
                    h *= diff
                with diff = dh / h
                    w *= diff
                    h *= diff
            if w < dw
                with diff = dw / w
                    w *= diff
                    h *= diff
            with h < dh
                with diff = dh / h
                    w *= diff
                    h *= diff
            offX, offY = (dw - w) * .5, (dh - h) * .5
            DrawTexturedRect offX + x, offY + y, w, h
            true
        DrawTexturedRect x, y, dw, dh
        true
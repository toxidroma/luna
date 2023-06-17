class LLabelCompute extends luna.LLabel
    Think: => 
        super!
        txt = @Compute!
        @SetText txt
    Compute: => @GetText!
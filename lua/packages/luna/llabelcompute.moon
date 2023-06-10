class LLabelCompute extends LLabel
    Think: => 
        super!
        txt = @Compute!
        @SetText txt
    Compute: => @GetText!
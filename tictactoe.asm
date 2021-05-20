xno		START	0
        JSUB    setclr
        LDA     #test
        LDT     testln
        JSUB    echostr
        J       halt

setclr  LDA     #27
        WD      #1
        LDA     #color
        LDT     #6
        JSUB    echostr 
        RSUB

. ---------------------------------- OUTPUT STRING -------------------------------------
echostr	STA	out
        LDX #0

cloop	LDCH	@out    . print each character in string one by one upto length in T.
	    
	WD	    #1      . 1 is the device code for STDOUT
        LDA     #1
        ADDR    X, A
        COMPR   A, T
	    JEQ     return
        RMO     A, X
        LDA	    out
	    ADD	    #1
	    STA	    out
        J	    cloop

return	LDA     #10
        WD      #1
        RSUB

out 	RESW	1

. ---------------------------------- OUTPUT STRING END -------------------------------------
state   RESB    9    
test	BYTE	C'Testing 101.'
color   BYTE    C'[31;4m'
testln  WORD    12
halt    J       halt
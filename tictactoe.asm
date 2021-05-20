xno		START	0
        LDA     #test
        LDT     testln
        JSUB    echostr
        J       halt

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
testln  WORD    12
halt    J       halt
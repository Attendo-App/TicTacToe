xno		START	0
        LDA     #test
        LDT     testln
        JSUB    grddisp
        J       halt
.------------------------------------ SET COLOR ---------------------------------------

setclr  STL     scret
        LDA     #27
        WD      #1
        LDA     #color
        LDT     #7
        JSUB    printcd 
        LDL     scret
        RSUB
color   BYTE    C'[0m'
scret   RESW 1


remdec  STL     rmret
        LDA     #27
        WD      #1
        LDA     #nodec
        LDT     #3
        STL     rmret
        JSUB    printcd 
        LDL     rmret
        RSUB
nodec   BYTE    C'[0m'
rmret   RESW    1




. ---------------------------------- GRID DISPLAY -------------------------------------


grddisp RMO     L,B
        JSUB    linep
        
        LDS     #0
        JSUB    disp
        
        JSUB    linep
        
        LDS     #3
        JSUB    disp
       
        JSUB    linep

        LDS     #6
        JSUB    disp
        
        JSUB    linep
        RSUB

linep   LDT     linelen
        LDA     #line
        RMO     L,B
        JSUB    printstr 
        RMO     B,L
        RSUB       

disp    LDT     tlen0
        LDX     #0
        ADDR    S,X
        LDCH    grdst,X
        LDX     #2
        STCH    temp0,X
        
        LDX     #1
        ADDR    S,X
        LDCH    grdst,X
        LDX     #6
        STCH    temp0,X
        
        LDX     #2
        ADDR    S,X
        LDCH    grdst,X
        LDX     #10
        STCH    temp0,X
        LDA     #temp0
        RMO     L,B
        JSUB    printstr
        RMO     B,L
        RSUB                 
. ---------------------------------- OUTPUT STRING -------------------------------------

printstr	STA	out
                LDX #0

cloop	LDCH	@out    . print each character in string one by one upto length in T.
	JSUB    setclr    
	WD	#1      . 1 is the device code for STDOUT
        LDA     #1
        ADDR    X, A
        COMPR   A, T
	JEQ     return
        RMO     A, X
        LDA	out
	ADD	#1
	STA	out
        J	cloop

return	LDA     #10
        WD      #1
        RSUB

out 	RESW	1
. ---------------------------------- OUTPUT STRING END -------------------------------------
. ------------------------------OUTPUT ANSI CODE ---------------------------------------------
printcd	STA	outx
                LDX #0

cdloop	LDCH	@outx   . print each character in string one by one upto length in T.
	    
	WD	#1      . 1 is the device code for STDOUT
        LDA     #1
        ADDR    X, A
        COMPR   A, T
	JEQ     ret
        RMO     A, X
        LDA	outx
	ADD	#1
	STA	outx
        J	cdloop

ret	RSUB

outx 	RESW	1

. ---------------------------------- OUTPUT ANSI END -------------------------------------
state   RESB    9    
test	BYTE	C'\e[1;31m This is red text \e[0m'
line    BYTE    C'-------------'
temp0   BYTE    C'|   |   |   |'
grdst   BYTE    C'XOXXOOOOX'    .hard coded for now.
tlen0   WORD    13
stlen   WORD    9
linelen WORD    13
testln  WORD    31
halt    J       halt

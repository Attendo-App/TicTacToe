xno		START	0
        LDA     #0
        STA     isgrd
        LDA     #test
        LDT     testln
        JSUB    grddisp
        J       halt
.------------------------------------ SET ANSI CODE ---------------------------------------
setclr  LDA     #27
        WD      #1
        LDA     #91
        WD      #1
        LDA     #52
        WD      #1
        LDA     #55
        WD      #1
        LDA     #59
        WD      #1
        LDA     #51
        WD      #1
        LDA     #48
        WD      #1
        LDA     #109
        WD      #1
        RSUB

clrscr  LDA     #10   . not working for now.
        WD      #1
        LDA     #10
        WD      #1
        LDA     #10
        WD      #1
        LDA     #10
        WD      #1
        RSUB

remdec  LDA     #27
        WD      #1
        LDA     #91
        WD      #1
        LDA     #48
        WD      #1
        LDA     #109
        WD      #1
        RSUB
. 091 057 076 059 057 066
. ---------------------------------- GRID DISPLAY -------------------------------------


grddisp LDS     #1
        STS     isgrd
        RMO     L,B
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
        LDS     #0
        STS     isgrd
        RSUB

grdret  RESW    1        

linep   LDT     linelen
        LDA     #line
        RMO     L,B
        JSUB    printstr 
        RMO     B,L
        RSUB       

disp    STL     disret
        LDX     #0
        LDB     clen
        LDA     #48
    
rloop   STCH    coldec,X
        TIXR    B
        JLT     rloop        

        LDB     #1

        LDX     #0
        ADDR    S,X
        LDCH    grdst,X
        LDX     #2
        STCH    temp0,X
        AND     #255
        COMP    #88
        JEQ     ch
        COMP    #79
        JEQ     ch
        J       nch
ch      LDA     #49
        STCH    coldec,X 
        ADDR    B,X 
        STCH    coldec,X
        SUBR    B,X
        SUBR    B,X
        STCH    coldec,X
        
nch     LDX     #1
        ADDR    S,X
        LDCH    grdst,X
        LDX     #6
        STCH    temp0,X
        AND     #255
        COMP    #88
        JEQ     ch1
        COMP    #79
        JEQ     ch1
        J       nch1
ch1     LDA     #49
        STCH    coldec,X 
        ADDR    B,X 
        STCH    coldec,X
        SUBR    B,X
        SUBR    B,X
        STCH    coldec,X
        
nch1    LDX     #2
        ADDR    S,X
        LDCH    grdst,X
        LDX     #10
        STCH    temp0,X
        AND     #255
        COMP    #88
        JEQ     ch2
        COMP    #79
        JEQ     ch2
        J       nch2
ch2     LDA     #49
        STCH    coldec,X 
        ADDR    B,X 
        STCH    coldec,X
        SUBR    B,X
        SUBR    B,X
        STCH    coldec,X
        
nch2    LDA     #grdst
        LDT     tlen0
        JSUB    printstr
        LDL     disret
        RSUB   
disret  RESW    1              
. ---------------------------------- OUTPUT STRING -------------------------------------

printstr	STA	out
                STL     printstrret
                LDX #0

cloop	LDCH	@out    . print each character in string one by one upto length in T.
 AND     #255
        COMP    #88
        JEQ     eq
        COMP    #79
        JEQ     eq
        J       neq
eq      JSUB    setclr
neq     LDCH    @out
	WD	#1      . 1 is the device code for STDOUT
        JSUB    remdec
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
        LDL     printstrret
        RSUB
printstrret RESW 1
out 	RESW	1


. ---------------------------------- OUTPUT STRING END -------------------------------------
state   RESB    9    
test	BYTE	C'\e[1;31m This is red text \e[0m'
line    BYTE    C'-------------'
temp0   BYTE    C'|   |   |   |'
coldec  BYTE    C'0000000000000'
grdst   BYTE    C'X XXO  OX'    .hard coded for now.
tlen0   WORD    13
clen    WORD    13
stlen   WORD    9
linelen WORD    13
testln  WORD    31
isgrd   RESW    1
halt    J       halt

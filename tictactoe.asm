xno		START	0
        LDA     #0
        STA     isgrd
        STA     count
play    LDA     #promptx
        LDT     plen
        JSUB    printstr
        JSUB    rdin
        LDA     #88
        STCH    grdst,X
        LDA     count
        ADD     #1
        STA     count
        COMP    #5
        JLT     grid
        COMP    #9
        JEQ     final
        JSUB    winner
        LDA     #32
        COMPR   A,S
        JEQ     grid
        J       exit
grid    JSUB    clrscr
        JSUB    grddisp
        LDA     #prompto
        LDT     plen
        JSUB    printstr
        JSUB    rdin
        LDA     #79
        STCH    grdst,X
        LDA     count
        ADD     #1
        STA     count
        COMP    #5
        JLT     grid2
        COMP    #9
        JEQ     final
        JSUB    winner
        LDA     #32
        COMPR   A,S
        JEQ     grid2
        J       exit
grid2   JSUB    clrscr
        JSUB    grddisp
        J       play
final   JSUB    clrscr
        JSUB    grddisp
        JSUB    winner
exit    RMO     S,A
        COMP    #88
        JEQ     xwin
        COMP    #79
        JEQ     owin
        LDA     #dstr
        LDT     dlen
        JSUB    printstr
        J       halt
xwin    LDA     #xstr
        LDT     winlen
        JSUB    printstr
        J       halt
owin    LDA     #ostr
        LDT     winlen
        JSUB    printstr
        J       halt
count   RESW    1
xstr    BYTE    C'Player X wins!'
ostr    BYTE    C'Player O wins!'
dstr    BYTE    C'Draw'
winlen  WORD    14
dlen    WORD    4
.------------------------------------ Handle input ---------------------------------------
rdin    RD      #0
        STA     temp
        RD      #0
        LDA     temp
        STL     rdret
        COMP    #56
        JGT     invalid
        COMP    #48
        JLT     invalid
        SUB     #48
        RMO     A,X
        LDCH    grdst,X
        COMP    #32
        JEQ     valid
        J       invalid
valid   LDL     rdret
        RSUB     
invalid LDA     #invstr
        LDT     ilen
        JSUB    printstr
        J       rdin
temp    RESW    1
rdret   RESW    1
invstr  BYTE    C'Invalid input,enter again:'
ilen    WORD    25
.------------------------------------ CHECK FOR WINNER ---------------------------------------
.Winning conditions: 
. 0,1,2
. 0,4,8
. 0,3,6
. 2,5,8
. 2,4,6
. 6,7,8
. 3,4,5
. 1,4,7

winner  LDX     #0         .Check if value in 0 is not blank, and if it is equal to value in 1
        LDCH    grdst,X
        COMP    #32
        JEQ     cond3
        RMO     A,S
        LDX     #1
        LDCH    grdst,X
        COMPR   A,S
        JEQ     check1
cond1   LDX     #0         .Check if value in 0 is equal to value in 4
        LDCH    grdst,X
        RMO     A,S
        LDX     #4
        LDCH    grdst,X
        COMPR   A,S
        JEQ     check2
cond2   LDX     #0         .Check if value in 0 is equal to value in 3
        LDCH    grdst,X
        RMO     A,S
        LDX     #3
        LDCH    grdst,X
        COMPR   A,S
        JEQ     check3
cond3   LDX     #2         .Check if value in 2 is not blank, and if it is equal to value in 5
        LDCH    grdst,X
        COMP    #32
        JEQ     cond5
        RMO     A,S
        LDX     #5
        LDCH    grdst,X
        COMPR   A,S
        JEQ     check4
cond4   LDX     #2         .Check if value in 2 is equal to value in 4
        LDCH    grdst,X
        RMO     A,S
        LDX     #4
        LDCH    grdst,X
        COMPR   A,S
        JEQ     check5
cond5   LDX     #6         .Check if value in 6 is not blank, and if it is equal to value in 7
        LDCH    grdst,X
        COMP    #32
        JEQ     cond6
        RMO     A,S
        LDX     #7
        LDCH    grdst,X
        COMPR   A,S
        JEQ     check6
cond6   LDX     #3         .Check if value in 3 is not blank, and if it is equal to value in 4     
        LDCH    grdst,X
        COMP    #32
        JEQ     cond7
        RMO     A,S
        LDX     #4
        LDCH    grdst,X
        COMPR   A,S
        JEQ     check7
cond7   LDX     #1         .Check if value in 1 is not blank, and if it is equal to value in 4
        LDCH    grdst,X
        COMP    #32
        JEQ     nowin
        RMO     A,S
        LDX     #4
        LDCH    grdst,X
        COMPR   A,S
        JEQ     check8
nowin  LDA      #32       .If there is no winner, return ' '
       J        winret 
check1 LDX      #2         .If value in 0 is equal to value in 1, check if it is equal to value in 2
       LDCH     grdst,X
       COMPR    A,S
       JEQ      winret
       J        cond1
check2 LDX      #8         .If value in 0 is equal to value in 4, check if it is equal to value in 8
       LDCH     grdst,X
       COMPR    A,S
       JEQ      winret
       J        cond2
check3 LDX      #6         .If value in 0 is equal to value in 3, check if it is equal to value in 6
       LDCH     grdst,X
       COMPR    A,S
       JEQ      winret
       J        cond3
check4 LDX      #8         .If value in 2 is equal to value in 5, check if it is equal to value in 8
       LDCH     grdst,X
       COMPR    A,S
       JEQ      winret
       J        cond4
check5 LDX      #6         .If value in 2 is equal to value in 4, check if it is equal to value in 6
       LDCH     grdst,X
       COMPR    A,S
       JEQ      winret
       J        cond5
check6 LDX      #8         .If value in 6 is equal to value in 7, check if it is equal to value in 8
       LDCH     grdst,X
       COMPR    A,S
       JEQ      winret
       J        cond6
check7 LDX      #5         .If value in 3 is equal to value in 4, check if it is equal to value in 5 
       LDCH     grdst,X
       COMPR    A,S
       JEQ      winret
       J        cond7
check8 LDX      #7         .If value in 1 is equal to value in 4, check if it is equal to value in 7 
       LDCH     grdst,X
       COMPR    A,S
       JEQ      winret
       J        nowin

winret RMO      A,S     .Move winner to S and return
       RSUB 
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
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
        WD      #1
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
        STL     grdret
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
        LDL     grdret
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
        
nch2    LDA     #temp0
        LDT     tlen0
        JSUB    printstr
        LDL     disret
        LDX     #0
        LDB     clen
        LDA     #48
    
rloop1   STCH    coldec,X
        TIXR    B
        JLT     rloop1 
        RSUB   
disret  RESW    1              
. ---------------------------------- OUTPUT STRING -------------------------------------

printstr	STA	out
                STL     printstrret
                LDX #0

cloop	LDCH	@out    . print each character in string one by one upto length in T.
        LDA     isgrd
        COMP    #1
        JEQ     eq
        J       neq
eq      LDCH    coldec,X
        AND     #255
        COMP    #49
        JEQ     pr
        J       neq
pr      JSUB    setclr        
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
grdst   BYTE    C'         '    
promptx BYTE    C'Enter input for X:'
prompto BYTE    C'Enter input for O:'
tlen0   WORD    13
clen    WORD    13
plen    WORD    18
stlen   WORD    9
linelen WORD    13
testln  WORD    31
isgrd   RESW    1
halt    J       halt

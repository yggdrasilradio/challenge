1POKE&HFFD9,0:CLEAR3000:X=RND(-TIMER):ONBRKGOTO1000:RGB:WIDTH80:PALETTE0,0:PALETTE8,63:PALETTE9,18:PALETTE10,25:PALETTE11,54
10CLS:ATTR3,0:PRINT"*** DRAGONMAZE ***":PRINT:ATTR0,0:PRINT"by Rick Adams":PRINT:PRINT"O ";:ATTR1,0:PRINT"Player":ATTR0,0:PRINT"& ";:ATTR1,0:PRINT"Dragon":ATTR0,0:PRINT"^ ";:ATTR1,0:PRINT"Sword":ATTR0,0
11PRINT"$ ";:ATTR1,0:PRINT"Gold":PRINT:ATTR2,0:PRINT"* Use arrow keys to move.":PRINT"* Avoid the dragons.":PRINT"* Collect all the gold to win.":PRINT"* Collect swords to fight the dragons.":PRINT"* One sword will kill one dragon."
12PRINT"* Swords magically vanish after use.":PRINT"* Good luck!":ATTR1,0:LOCATE0,23:PRINT"Generating maze:";:MW=19:MH=11:T=MW*MH:DIMA$(MH*2+1):R1$="+":R2$="!":FORI=1TO MW:R1$=R1$+"---+":R2$=R2$+" X !"
13NEXTI:FORI=1TO MH*2+1:IFI AND1 THENA$(I)=R1$ ELSEA$(I)=R2$
14NEXTI:DIMSX(MW*MH+1),SY(MW*MH+1):S=1:N=MW*MH-1:SX(S)=3:SY(S)=2:MID$(A$(2),3,1)=" "
20X=SX(S):Y=SY(S):GOSUB3000:IFLEN(R$)=0 THENS=S-1:GOTO20
21D=VAL(MID$(R$,RND(LEN(R$)),1)):OND GOTO22,24,26,28
22Y=Y-2:MID$(A$(Y+1),X-1,3)="   ":GOTO30
24Y=Y+2:MID$(A$(Y-1),X-1,3)="   ":GOTO30
26X=X-4:MID$(A$(Y),X+2,1)=" ":GOTO30
28X=X+4:MID$(A$(Y),X-2,1)=" "
30S=S+1:SX(S)=X:SY(S)=Y:MID$(A$(Y),X,1)=" ":N=N-1:IFN>0 THENLOCATE16,23:ATTR1,0:PRINTSTR$(INT(100*(T-N)/T));:PRINT"%";:GOTO20
31CLS:ATTR2,0:FORI=1TO MH*2+1:LOCATE0,I-1:PRINTA$(I);:NEXTI:ATTR0,0:FORI=1TO10
40X=RND(MW):Y=RND(MH):IFMID$(A$(Y*2),X*4-1,1)=" " THENLOCATEX*4-2,Y*2-1:PRINT"$";:MID$(A$(Y*2),X*4-1,1)="$" ELSEGOTO40
41NEXTI:ATTR0,0:FORI=1TO4
50X=RND(MW):Y=RND(MH):IFMID$(A$(Y*2),X*4-1,1)=" " THENLOCATEX*4-2,Y*2-1:PRINT"^";:MID$(A$(Y*2),X*4-1,1)="^" ELSEGOTO50
51NEXTI:ATTR1,0:S=0:LOCATE0,23:PRINT"Gold: 0";:I$="":LOCATE34,23:PRINT"Swords: 0";:X=3:Y=2:LOCATEX-1,Y-1:ATTR0,0:PRINT"O";:DIMX(2),Y(2),DX(2),DY(2):FORI=1TO2:READX(I),Y(I),DX(I),DY(I):LOCATEX(I)-1,Y(I)-1
52ATTR0,0:PRINT"&";:NEXTI
100S$=INKEY$:IFS$="" THENGOTO100
101M$="                 ":GOSUB9000:I=ASC(S$):NX=X:NY=Y:IFI=94 THENNY=NY-1
102IFI=10 THENNY=NY+1
103IFI=8 THENNX=NX-2
104IFI=9 THENNX=NX+2
105C$=MID$(A$(NY),NX,1):IFC$="$" THENS=S+10:LOCATE0,23:PRINT"Gold:";S;:MID$(A$(NY),NX,1)=" ":M$="Found gold":GOSUB9000
106IFC$="^" THENI$=I$+"^":LOCATE41,23:ATTR1,0:PRINTLEN(I$);:MID$(A$(NY),NX,1)=" ":M$="Found sword":GOSUB9000
107IFINSTR("!+-",C$)=0 THENLOCATEX-1,Y-1:PRINT" ";:LOCATENX-1,NY-1:ATTR0,0:PRINT"O";:X=NX:Y=NY
108IFS=100 THENGOSUB6000
109GOSUB2000:GOTO100
1000POKE&H71,0:EXEC&H8C1B
2000FORI=1TO2:IFX=X(I)AND Y=Y(I) THENGOSUB7000
2001MX=X(I):MY=Y(I):IFMX>0 THENGOSUB8000
2002IFX=X(I)AND Y=Y(I) THENGOSUB7000
2003NEXTI:RETURN
3000R$=""
3010IFY=2 THENGOTO3030
3011NY=Y-2:IFMID$(A$(NY),X,1)<>" "AND MID$(A$(Y-1),X,1)<>" " THENR$=R$+"1"
3030IFY=MH*2 THENGOTO3040
3031NY=Y+2:IFMID$(A$(NY),X,1)<>" "AND MID$(A$(Y+1),X,1)<>" " THENR$=R$+"2"
3040IFX=3 THENGOTO3050
3041NX=X-4:IFMID$(A$(Y),NX,1)<>" "AND MID$(A$(Y),X-2,1)<>" " THENR$=R$+"3"
3050IFX=4*MW-1 THENGOTO3060
3051NX=X+4:IFMID$(A$(Y),NX,1)<>" "AND MID$(A$(Y),X+2,1)<>" " THENR$=R$+"4"
3060RETURN
4000ONRND(4)GOTO4010,4020,4030,4040
4010DX(I)=0:DY(I)=1:GOTO4050
4020DX(I)=2:DY(I)=0:GOTO4050
4030DX(I)=0:DY(I)=-1:GOTO4050
4040DX(I)=-2:DY(I)=0
4050NX=MX+DX(I):NY=MY+DY(I):C$=MID$(A$(NY),NX,1):IFINSTR("!+-",C$)>0 THENGOTO4000
4051RETURN
5000IFMX<>X AND MY<>Y THENRETURN
5001DX=0:DY=0:IFMX=X AND MY<Y THENDY=1
5002IFMX=X AND MY>Y THENDY=-1
5003IFMY=Y AND MX<X THENDX=2
5004IFMY=Y AND MX>X THENDX=-2
5005NX=MX:NY=MY
5010NX=NX+DX:NY=NY+DY:C$=MID$(A$(NY),NX,1):IFINSTR("!+-",C$)>0 THENRETURN
5011IFNX<>X OR NY<>Y THENGOTO5010
5012DX(I)=DX:DY(I)=DY:RETURN
6000M$="You've conquered the DragonMaze!":GOSUB9000
6010S$=INKEY$:IFS$="" THENGOTO6010
6011C=ASC(S$):IFC<32OR C>93 THENGOTO6010
6012RUN
7000LOCATEX-1,Y-1:IFLEN(I$)>0 THENI$=LEFT$(I$,LEN(I$)-1):LOCATE41,23:ATTR1,0:PRINTLEN(I$);:X(I)=0:M$="Killed dragon":PALETTE0,63:GOSUB9000:LOCATEX-1,Y-1:ATTR0,0:PRINT"O";:RETURN
7001LOCATEX-1,Y-1:ATTR0,0:PRINT"&";:M$="You died":PALETTE0,36:GOSUB9000
7020S$=INKEY$:IFS$="" THENGOTO7020
7021C=ASC(S$):IFC<32OR C>93 THENGOTO7020
7022RUN
8000NX=MX+DX(I):NY=MY+DY(I):C$=MID$(A$(NY),NX,1):IFINSTR("!+-",C$)>0 THENGOSUB4000
8001X(I)=NX:Y(I)=NY:LOCATEMX-1,MY-1:PRINTMID$(A$(MY),MX,1);:IFI$=""OR NX<>X OR NY<>Y THENLOCATENX-1,NY-1:ATTR0,0:PRINT"&";
8002MX=X(I):MY=Y(I):GOSUB5000:RETURN
9000LOCATELEN(A$(1))-LEN(M$),23:ATTR1,0:PRINTM$;:PALETTE0,0:RETURN
9001DATA23,12,2,0,55,12,-2,0

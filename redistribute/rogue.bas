1ONBRKGOTO1000
10CLS:DIMA$(15):FORI=1TO15:READD$:A$(I)=D$:PRINTD$:NEXTI:S=0:P=15*32:PRINT@P,"GOLD: 0";:X=3:Y=2:P=(Y-1)*32+X-1:PRINT@P,"O";:DIMX(2),Y(2),DX(2),DY(2):FORI=1TO2:READX(I),Y(I),DX(I),DY(I):NEXTI:GOSUB3000:I$=""
20S$=INKEY$:IFS$="" THENGOTO20
21I=ASC(S$):NX=X:NY=Y:IFI=94 THENNY=NY-1
22IFI=10 THENNY=NY+1
23IFI=8 THENNX=NX-2
24IFI=9 THENNX=NX+2
25C$=MID$(A$(NY),NX,1):IFC$="$" THENS=S+10:P=15*32:PRINT@P,"GOLD:";S;:MID$(A$(NY),NX,1)=" "
26IFC$="^" THENI$="^":MID$(A$(NY),NX,1)=" "
27IFINSTR("!+-",C$)=0 THENP=(Y-1)*32+X-1:PRINT@P," ";:P=(NY-1)*32+NX-1:PRINT@P,"O";:X=NX:Y=NY
28IFS=50 THENGOSUB6000
29GOSUB2000:GOTO20
1000POKE&H71,0:EXEC&H8C1B
2000FORI=1TO2:MX=X(I):MY=Y(I):IFMX>0 THENGOSUB8000
2001IFX=X(I)AND Y=Y(I) THENGOSUB7000
2002NEXTI:RETURN
3000FORI=1TO2:P=(Y(I)-1)*32+X(I)-1:PRINT@P,"&";:NEXTI:RETURN
4000ONRND(4)GOTO4010,4020,4030,4040
4010DX(I)=0:DY(I)=1:GOTO4050
4020DX(I)=2:DY(I)=0:GOTO4050
4030DX(I)=0:DY(I)=-1:GOTO4050
4040DX(I)=-2:DY(I)=0:GOTO4050
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
6000P=15*32+16:PRINT@P,"YOU HAVE WON!";
6020S$=INKEY$:IFS$="" THENGOTO6020
6021RUN
7000IFI$="^" THENI$="":X(I)=0:RETURN
7001P=15*32+21:PRINT@P,"YOU DIED";
7020S$=INKEY$:IFS$="" THENGOTO7020
7021RUN
8000NX=MX+DX(I):NY=MY+DY(I):C$=MID$(A$(NY),NX,1):IFINSTR("!+-",C$)>0 THENGOSUB4000
8001X(I)=NX:Y(I)=NY:P=(MY-1)*32+MX-1:P2=(NY-1)*32+NX-1:PRINT@P,MID$(A$(MY),MX,1);:PRINT@P2,"&";:MX=X(I):MY=Y(I):GOSUB5000:RETURN
8002DATA"+-------------------+-------+","!                   !       !","+---+   +-------+   +---+   !","!   !         ^ !           !","!   +   +---+---+   +-------+","!           !               !","!   +---+   !   +-----------+"
8003DATA"! $ !       !   !           !","+---+   +---+   +-------+   !","!       !   !               !","+---+   !   +---+   +-------+","! $ !   !     $ !           !","!   +   +   +---+-------+   !","!                 $     ! $ !"
8004DATA"+-----------------------+---+",23,2,2,0,23,14,-2,0

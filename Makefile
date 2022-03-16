all: rogue

rogue: rogue.bas
	decbpp < rogue.bas > /tmp/rogue.bas
ifneq ("$(wildcard /media/share1/COCO/drive3.dsk)", "")
	decb copy -tr /tmp/rogue.bas /media/share1/COCO/drive3.dsk,ROGUE.BAS
endif
	cp /tmp/rogue.bas redistribute
	rm -f redistribute/game.dsk
	decb dskini redistribute/game.dsk
	decb copy -tr /tmp/rogue.bas redistribute/game.dsk,GAME.BAS
	cat /tmp/rogue.bas
	rm -f /tmp/rogue.bas





all: rogue

rogue: rogue.bas
	decbpp < rogue.bas > /tmp/rogue.bas
	decb copy -tr /tmp/rogue.bas /media/share1/COCO/drive0.dsk,ROGUE.BAS
	cat /tmp/rogue.bas
	rm -f /tmp/rogue.bas

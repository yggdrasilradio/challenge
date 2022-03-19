all: dmaze

dmaze: dmaze.bas
	decbpp < dmaze.bas > /tmp/dmaze.bas
ifneq ("$(wildcard /media/share1/COCO/drive3.dsk)", "")
	decb copy -tr /tmp/dmaze.bas /media/share1/COCO/drive3.dsk,DMAZE.BAS
endif
	cp /tmp/dmaze.bas redistribute
	rm -f redistribute/dmaze.dsk
	decb dskini redistribute/dmaze.dsk
	decb copy -tr /tmp/dmaze.bas redistribute/dmaze.dsk,DMAZE.BAS
	cat /tmp/dmaze.bas
	rm -f /tmp/dmaze.bas

all:	msxwood.crt
	openmsx -machine Philips_VG_8020  -ext debugdevice -script startup.tcl -carta msxwood.crt

clean:
	rm msxwood.crt

run:
	openmsx -machine Philips_NMS_8250  -ext debugdevice -script startup.tcl -carta msxwood.crt

msxwood.crt:	bcdlib.asc gridbitmapmanipulators.asc piecelib.asc variablespace.asc bios.asc joystick.asc pieces.asc gameover.asc msxwood.asc testbcdlib.asc routines.asc charanimation.asc boxcopy.asc bigscroller.asc vram-*.txt logo.asc msxwletsprites.asc intro.asc bird.asc
	pasmo --bin --nocase msxwood.asc msxwood.crt msxwood.symbol msxwood.publics

testbcd.bin:	testbcdlib.asc
	pasmo --msx testbcdlib.asc testbcd.bin

testrout.bin:	testroutines.asc
	pasmo --msx testroutines.asc testrout.bin

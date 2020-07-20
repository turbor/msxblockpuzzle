all:	blockpuz.rom
	openmsx -machine Philips_VG_8020  -ext debugdevice -script startup.tcl -carta blockpuz.rom

clean:
	rm blockpuz.rom

run:
	openmsx -machine Philips_NMS_8250  -ext debugdevice -script startup.tcl -carta blockpuz.rom

blockpuz.rom:	vram-*.txt *.asc
	pasmo --bin --nocase blockpuz.asc blockpuz.rom blockpuz.symbol blockpuz.publics

testbcd.bin:	testbcdlib.asc
	pasmo --msx testbcdlib.asc testbcd.bin

testrout.bin:	testroutines.asc
	pasmo --msx testroutines.asc testrout.bin

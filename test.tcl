proc show_combiners {} {
	variable x
	lappend sh
	set x [expr {0xCA4D}]
	while { [peek $x] != 255 } {
			set a [peek $x]
			set b [peek [expr {$x + 1}]]
			puts "$a + $b"
			lappend sh "$a + $b"
			set x [expr {$x + 20}]
	}
	puts [lsort $sh]
	puts [llength $sh]
}

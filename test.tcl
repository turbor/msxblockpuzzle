# scrollpatterncombinedb is cc0d
# zzzz after the call cleanupscrollpatterncombinedb is 5f6b
proc show_combiners {} {
	variable x
	lappend sh
	set x [expr {0xCC0D}]
	while { [peek $x] != 255 } {
			set a [peek $x]
			set b [peek [expr {$x + 1}]]
			set c [peek_s16 [expr {$x + 2}]]
			lappend sh "$a+$b:$c   "
			set x [expr {$x + 20}]
	}
	puts [lsort $sh]
	puts [llength $sh]
	puts " "
}

debug set_bp 0x5F6B {1 == 1} {show_combiners}

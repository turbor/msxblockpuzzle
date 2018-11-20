namespace eval versnel {
proc fasterboot {} {
	after time 0 "toggle throttle "
	after time 5 "toggle throttle "
	#after time 0 "set throttle on"
	#after time 12 "set throttle off"
}

};#namespace

after boot versnel::fasterboot
#after time 2 versnel::fasterboot



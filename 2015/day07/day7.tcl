#!/usr/bin/env tclsh
if {[llength $argv] != 1} {
    puts stderr "Usage: $argv0 input-file"
    exit 1
}

set wires [dict create]
set resolved [dict create]

proc resolve {wire} {
    global resolved wires
    if {![dict exists $resolved $wire]} {
        if {[regexp {^\d+$} $wire]} { 
            set val $wire
        } else { 
            set val [expr [dict get $wires $wire]]
        }
        dict set resolved $wire [expr $val & 65535]
    }
    dict get $resolved $wire
}

proc make-num {num} { return $num }

proc make-alias {wire} { return "\[resolve $wire]" }

proc make-not-num {num} { return "~$num" }

proc make-not-wire {wire} { return "~\[resolve $wire]" }

proc make-binop {left op right} {
    set arg1 "\[resolve $left]"
    set arg2 "\[resolve $right]"
    switch $op {
        "AND"    { return "$arg1 & $arg2" }
        "OR"     { return "$arg1 | $arg2" }
        "LSHIFT" { return "$arg1 << $arg2" }
        "RSHIFT" { return "$arg1 >> $arg2" }
    }
}

set f [open [lindex $argv 0]]
while {[gets $f line] >= 0} {
    regexp {^(.*\S)\s*->\s*(\w+)$} $line _ expression wire 
    if {[regexp {^\d+$} $expression]} {
        dict set wires $wire [make-num $expression]
    } elseif {[regexp {^\w+$} $expression]} {
        dict set wires $wire [make-alias $expression]
    } elseif {[regexp {^NOT\s+(\d+)$} $expression _ number]} {
        dict set wires $wire [make-not-num $number]
    } elseif {[regexp {^NOT\s+(\w+)$} $expression _ alias]} {
        dict set wires $wire [make-not-wire $alias]
    } elseif {[regexp {^(\w+)\s*(AND|OR|LSHIFT|RSHIFT)\s*(\w+)$} $expression _ arg1 op arg2]} {
        dict set wires $wire [make-binop $arg1 $op $arg2]
    }
}
puts [resolve a]

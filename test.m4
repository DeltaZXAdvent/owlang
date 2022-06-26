define(`_d',``$'')
define(`macro',_d`$#')
m4exit(`0')
define(`macro',changequote(`[',`]')`changequote)
macro'`Okay!'dnl
m4exit(`0')
define(`def','define(`macro',
`dnl
ifelse($#,2,`global.arg[decr(decr($#))] = $1;',
`global.arg[decr(decr($#))] = $1;
		macro(shift($@))')')')dnl
macro(tmp,arg,what)
m4exit(`0')
define(`num',``$'`#'')dnl
define(`def',`define(`macro',num)')dnl
def`'dnl
`macro'=>macro
`macro()'=>macro()
`macro(,)'=>macro(,)
define(`def',`define(`macro',``num:''num`` foo'')')dnl
def`'dnl
`macro'=>macro
`macro()'=>macro()
`macro(,)'=>macro(,)


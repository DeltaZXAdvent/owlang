dnl ***************************
dnl Overwatch Workshop Language - OWLang
dnl ***************************
dnl _def (NAME, EXPANSION)
ifdef(`_def',`
errprint(`Macro _def has already be defined.')
m4exit(`1')')dnl
define(`_def',`ifdef(`$1',`
errprint(`Macro $1 has already be defined.')
m4exit(`1')')define(`$1',`$2')')dnl
dnl ***************************
dnl _def_ (NAME, EXPANSION)
ifdef(`_def_',`
errprint(`Macro _def_ has already be defined.')
m4exit(`1')')dnl
define(`_def_',`ifdef(`$1',`
errprint(`Macro $1 has already be defined.')
m4exit(`1')')define(`$1',$2)')dnl
dnl ***************************
dnl _d
_def(`_d',`$')dnl
dnl At least one argument.
dnl Regex: (\n\t\t{varnum}: {varname})+
dnl _varsg (ID1...)
_def(`_varsg',`_def(`$1',``global.$1'')decr(`$#'): `$1'ifelse(`$#',`1',`',` _varsg(shift($@))')')dnl
dnl ***************************
dnl _varsp (ID1...)
_def(`_varsp',`decr(`$#'): `$1'ifelse(`$#',`1',`',` _varsp(shift($@))')')dnl
dnl ***************************
dnl Allocate numbers between `eval(BASE+0)' and `eval(BASE+$#-1)' to IDs.
dnl _allocid (ID1...)
_def(`_allocid',`ifelse(`$#',`2',`_def(`$2',`$1')',`_def(`$2',`eval($1+$#-2)')_allocid(`$1',shift(shift($@)))')')dnl
dnl ***************************
dnl By an interval.
dnl _allocidi (INTERVAL, ID1...)
_def(`_allocidi',`ifelse(`$#',`2',`_def(`$2',`0')',`_def(`$2',`eval($1*($#-2))')_allocidi(`$1',shift(shift($@)))')')dnl
dnl ***************************
dnl At least one argument.
dnl _sub (NAME, ARGS..., ACTIONS)
_def(`_sub',
`dnl
rule("sub - $1") {
	event { subroutine; $1; }
	actions {
__lsargs(shift($@))
	}
}dnl
_def_(`$1',
``ifelse('_d`#'`,decr(decr(`$#')),`_pushargs(''changequote(`[',`]')`changequote`'_d`@'changequote(`[',`]')'changequote``)`call subroutine($1)'''`,
`errprint(`Argument count of call of subroutine $1 is not correct.')m4exit(`1')')'')')dnl
dnl ***************************
dnl __lsargs (ID1..., ACTIONS)
_def(`__lsargs',
`dnl
ifelse(`$#',`1',
`$1',
`dnl
pushdef(`$1',``global.arg['decr(decr(`$#'))`]'')dnl
__lsargs(shift($@))dnl
popdef(`$1')')'dnl
)dnl
dnl ***************************
dnl __pushargs (ID1..., ACTIONS)
_def(`_pushargs',
`dnl
ifelse(`$#',`1',``global.arg['decr(`$#')`] = $1; '',
``global.arg['decr(`$#')`] = $1; '_pushargs(shift($@))')')dnl
dnl ***************************
dnl Test

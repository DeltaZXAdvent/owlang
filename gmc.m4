include(`owlang.m4')dnl
// variables
variables {

	global: _varsg(dnl
tmp,
arg,
menu,
ind)

	player: _varsp(dnl
rulefl,
menuid,
menuitemsel,
menuopen,
menutxt)

}

// subroutines
subroutines { _varsp(dnl
menuctl1,
menuctl2,
menuctl3,
menuupdate,
menuselitem,
docmd)
}

dnl ID_MENU
_allocid(0,
mnMAIN,
mnSTAT)

dnl ID_RULE
_allocid(0,
rlMENU)

define(`CTGROUP',`1000')

dnl CMD_GROUP
_allocidi(`CTGROUP',
cmdgMENU,
cmdgSTAT)

dnl str
define(`str',``custom string($*)'')

dnl ep
define(`ep',``event player'')

_sub(`menuselitem',
	`forward',
	`dnl
		if (forward);
			while (true);
				ep.menuitemsel += 2;
				ep.menuitemsel %= count of(menu[ep.menusel]);
				if (menu[ep.menusel][ep.menuitemsel + 1] != 0);
					break;
				end;
			end;
		else;
			while (true);
				ep.menuitemsel += count of(menu[ep.menusel]) - 2;
				ep.menuitemsel %= count of(menu[ep.menusel]);
				if (menu[ep.menusel][ep.menuitemsel + 1] != 0);
					break;
				end;
			end;
		end;'
)

rule("init-global") {
	event { ongoing-global; }
	actions {
		"init-global-MENU"
		menu[mnMAIN] = array(
			str("【主菜单】"), 0,
			str("状态 >"), cmdgMENU+mnSTAT,
		);
		menu[mnSTAT] = array(
			str("【状态】"), 0,
			str("主菜单 >"), cmdgMENU+mnMAIN
		);
	}
}

rule("init-player") {
	event { ongoing-each player; all; all; }
	actions {
		"init-player-MENU"
		ep.menusel = mnMAIN;
		ep.menuitemsel = 0;
		ep.menuopen = false;
	}
}

rule("main") {
	event { ongoing-each player; all; all; }
	actions {
		while (true);
			wait until(!is button held(ep, button(interact)), 99999);
			wait until(is button held(ep, button(interact)), 99999);
			ep.rulefl[rlMENU] = true;
			disallow button(ep, button(primary fire));
			disallow button(ep, button(secondary fire));
			disallow button(ep, button(melee));
			disallow button(ep, button(reload));
			start rule(menuctl1, restart rule);
			start rule(menuctl2, restart rule);
			start rule(menuctl3, restart rule);
			start rule(menuupdate, do nothing);
			create hud text(ep, null, null, ep.menutxt, top, 1, color(white), color(white),
				color(white),
				visible to and string, default visibility);
			ep.menuid = last text id;
			wait until(!is button held(ep, button(interact)), 99999);
			wait until(is button held(ep, button(interact)), 99999);
			ep.rulefl[rlMENU] = false;
			allow button(ep, button(melee));
			allow button(ep, button(reload));
			allow button(ep, button(primary fire));
			allow button(ep, button(secondary fire));
			destroy hud text(ep.menuid);
		end;
	}
}

rule("rule-menuctl1") {
	event { subroutine; menuctl1; }
	actions {
		wait until(!is button held(ep, button(primary fire)), 99999);
		while (true);
			wait until(is button held(ep, button(primary fire)), 99999);
			if (!ep.rulefl[rlMENU]); abort; end;
			menuselitem(true);
			start rule(menuupdate, do nothing);
			wait until(!is button held(ep, button(primary fire)), 0.32);
			if (is button held(ep, button(primary fire)));
				while (true);
					menuselitem(true);
					start rule(menuupdate, do nothing);
					wait until(!is button held(ep, button(primary fire)), 0.064);
					if (!is button held(ep, button(primary fire)));
						loop;
					end;
				end;
			end;
		end;
	}
}
rule("rule-menuctl2") {
	event { subroutine; menuctl2; }
	actions {
		wait until(!is button held(ep, button(secondary fire)), 99999);
		while (true);
			wait until(is button held(ep, button(secondary fire)), 99999);
			if (!ep.rulefl[rlMENU]); abort; end;
			menuselitem(false);
			start rule(menuupdate, do nothing);
			wait until(!is button held(ep, button(secondary fire)), 0.32);
			if (is button held(ep, button(secondary fire)));
				while (true);
					menuselitem(false);
					start rule(menuupdate, do nothing);
					wait until(!is button held(ep, button(secondary fire)), 0.064);
					if (!is button held(ep, button(secondary fire)));
						loop;
					end;
				end;
			end;
		end;
	}
}
rule("rule-menuctl3") {
	event { subroutine; menuctl3; }
	actions {
		wait until(is button held(ep, button(melee)), 99999);
		if (!ep.rulefl[rlMENU]); abort; end;
		ep.cmd = menu[ep.menusel][ep.menuitemsel + 1];
		start rule(docmd, do nothing);
		"feature-never-used"
		if (ep.cmd == -1);
			ep.cmd = menu[ep.menusel][ep.menuitemsel];
		end;
		wait until(!is button held(ep, button(melee)), 99999);
		loop;
	}
}

rule("once-cmd") {
	event { subroutine; docmd; }
	actions {
		if (ep.cmd == 0); abort; end;
		if (cmdgMENU <= ep.cmd && ep.cmd < cmdgMENU + CTGROUP);
			ep.menusel = ep.cmd - 1000;
			ep.menuitemsel = -2;
			menuselitem(true);
			start rule(menuupdate, do nothing);
		end;
		ep.cmd = 0;
		"for command invocation"
		loop;
	}
}
rule("once-menuupdate") {
	event { subroutine; menuupdate; }
	actions {
		if (!ep.rulefl[rlMENU]); abort; end;
		ep.menutxt =
			str("{0}{1}",
				menu[ep.menusel][1] == 0 ? custom string("") :
					(ep.menuitemsel == 0 ? custom string("●") : custom string("○")),
				menu[ep.menusel][0]
			);
		for global variable(ind, 2, count of(menu[ep.menusel]), 2);
			ep.menutxt =
				str("{2}\r\n{0}{1}",
					menu[ep.menusel][ind + 1] == 0 ? custom string("") :
						(ep.menuitemsel == ind ? custom string("●") : custom string("○")),
					menu[ep.menusel][ind],
					ep.menutxt
				);
		end;
	}
}

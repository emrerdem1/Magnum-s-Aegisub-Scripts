﻿	unicode = require 'aegisub.unicode'

	local mag = {}

	function mag.delay()
	local st = ""
	for i = 0, 50000 do
	st = st .. i
	end
	return st
	end

	function mag.prog(str)
	aegisub.progress.task(mag.format("%s",str))
	aegisub.progress.set(100)
	mag.delay()
	end

	function mag.ascii(str)
	str = mag.gsub(str,"ç",mag.char(231))
	str = mag.gsub(str,"Ç",mag.char(199))
	str = mag.gsub(str,"ü",mag.char(252))
	str = mag.gsub(str,"Ü",mag.char(220))
	str = mag.gsub(str,"ö",mag.char(246))
	str = mag.gsub(str,"Ö",mag.char(214))
	str = mag.gsub(str,"ğ",mag.char(240))
	str = mag.gsub(str,"Ğ",mag.char(208))
	str = mag.gsub(str,"ş",mag.char(254))
	str = mag.gsub(str,"Ş",mag.char(222))
	str = mag.gsub(str,"ı",mag.char(253))
	str = mag.gsub(str,"İ",mag.char(221))
	return str
	end

	function mag.strip(str) return mag.gsub(str,"{[^}]+}", "") end

	function mag.removedot(str) return mag.gsub(str,"['., -/*:;+!)?\"=(]+", "") end

	function mag.wall(mode,loop) return mag.rep(mode,loop) end

	function mag.unstyles(style) return mag.gsub(style,"%(%d+%+?%d-%)%s","") end

	function mag.total(subs,style_name,mode,value)
	local n, m = 0, 0
	for i = 1, #subs do
	if subs[i].class == "dialogue" then
	if mode == "default" then
	if subs[i].style == style_name then n = n + 1 end
	end
	if mode == "comment" then
	if subs[i].style == style_name and subs[i].comment == false then n = n + 1 end
	if subs[i].style == style_name and subs[i].comment == true then m = m + 1 end
	end
	if mode == "effect" then
	if subs[i].style == style_name and subs[i].effect ~= value then n = n + 1 end
	if subs[i].style == style_name and subs[i].effect == value then m = m + 1 end
	end
	end
	end
	return n, m
	end

	function mag.styles(subs,mode,value)
	local n, styles = 0, {}
	for i = 1, #subs do
	if subs[i].class == "style" then
	local total, total2 = mag.total(subs,subs[i].name,mode,value)
	if total > 0 or total2 > 0 then
	if mode == "default" then n = n + 1 styles[n] = mag.format("(%d) %s",total,subs[i].name) end
	if mode == "comment" or mode == "effect" then n = n + 1 styles[n] = mag.format("(%d+%d) %s",total,total2,subs[i].name) end
	end
	end
	end
	return styles
	end

	function mag.styles_insert(subs,var,id,mode,value) for _, style in ipairs(mag.styles(subs,mode,value)) do table.insert(var[id].items,style) end end

	function mag.dlg(var,buttons)
	local ok, config
	for i = 1, table.getn(buttons) do buttons[i] = mag.ascii(buttons[i]) end
	ok, config = aegisub.dialog.display(var,buttons)
	return ok, config
	end

	function mag.register(name,macro)
	if name == false then return aegisub.register_macro(script_name,script_desription,macro) end
	if name ~= false then return aegisub.register_macro(name,script_desription,macro) end
	end

	function mag.log(str) return aegisub.log(mag.s(str).."\n") end

	function mag.splitter(split,str,last)
	local n = 0
	local parts = {}
	if last == true then str = str..split end
	for part in str:gmatch("[^"..split.."]+"..split) do
	n = n + 1
	parts[n] = part
	end
	if last == true then parts[n] = mag.reverse(mag.gsub(mag.reverse(parts[n]),mag.reverse(split),"",1)) end
	return n, parts
	end

	mag.s       = tostring
	mag.n       = tonumber
	mag.floor   = math.floor
	mag.ceil    = math.ceil
	mag.rand    = math.random
	mag.char    = string.char
	mag.find    = string.find
	mag.format  = string.format
	mag.gmatch  = string.gmatch
	mag.gsub    = string.gsub
	mag.length  = string.len
	mag.match   = string.match
	mag.rep     = string.rep
	mag.reverse = string.reverse
	mag.sub     = string.sub
	mag.upper   = string.upper
	mag.lower   = string.lower
	mag.up      = unicode.to_upper_case
	mag.low     = unicode.to_lower_case
	mag.len     = unicode.len

	return mag
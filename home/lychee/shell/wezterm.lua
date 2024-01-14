local wezterm = require 'wezterm'

return {
	use_fancy_tab_bar = false,
	font = wezterm.font_with_fallback {
		{ family = 'Terminus', weight = 'Bold' },
		'Font Awesome 5 Free',
	},
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
}

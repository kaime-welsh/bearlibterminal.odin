package basic_test

import terminal "../src"

Player :: struct {
	x, y: i32,
	ch:   i32,
}

main :: proc() {
	terminal.open()
	terminal.set("window: size=80x30, title='BearLibTerm - Basic', resizeable=true;")
	defer terminal.close()

	player: Player = {
		x  = 10,
		y  = 10,
		ch = '@',
	}

	quit := false
	for !quit {
		terminal.clear()
		terminal.put(player.x, player.y, player.ch)

		terminal.refresh()
		switch ch := terminal.read(); ch {
		case terminal.TK_CLOSE, terminal.TK_ESCAPE:
			quit = true

		case terminal.TK_H, terminal.TK_A:
			player.x -= 1
		case terminal.TK_L, terminal.TK_D:
			player.x += 1
		case terminal.TK_K, terminal.TK_W:
			player.y -= 1
		case terminal.TK_J, terminal.TK_S:
			player.y += 1
		}
	}
}

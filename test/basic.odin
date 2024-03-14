package basic_test

import terminal "../src"

main :: proc() {
	terminal.open()
	defer terminal.close()

	terminal.print(1, 1, "Hello, world!")
	terminal.refresh()

	for terminal.read() != terminal.TK_CLOSE {}
}

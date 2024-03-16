package bearlibterminal

import "core:c"
import "core:c/libc"
import "core:fmt"
import "core:strings"

// NOTE: Need to setup differentiation between target platforms and their libraries
// For now only supports 64-bit windows
when ODIN_OS == .Windows {
    foreign import bearlibterminal "Windows64/BearLibTerminal.lib"
}

dimensions_t_ :: struct {
    width:  c.int,
    height: c.int,
}

color_t :: distinct i32

@(link_prefix = "terminal_")
@(default_calling_convention = "c")
foreign bearlibterminal {
    open :: proc() -> c.int ---
    close :: proc() ---
    refresh :: proc() ---
    clear :: proc() ---
    clear_area :: proc(x, y: c.int, w, h: c.int) ---
    crop :: proc(x, y: c.int, w, h: c.int) ---
    layer :: proc(index: c.int) ---
    color :: proc(color: color_t) ---
    bkcolor :: proc(color: color_t) ---
    composition :: proc(mode: c.int) ---
    put :: proc(x, y: c.int, code: c.int) ---
    put_ext :: proc(x, y: c.int, dx, dy: c.int, code: c.int, corners: ^[4]color_t) ---
    pick :: proc(x, y: c.int, index: c.int) -> c.int ---
    pick_color :: proc(x, y: c.int, index: c.int) -> color_t ---
    pick_bkcolor :: proc(x, y: c.int) -> color_t ---
    has_input :: proc() -> c.int ---
    state :: proc(code: c.int) -> c.int ---
    read :: proc() -> c.int ---
    peek :: proc() -> c.int ---
    delay :: proc(period: c.int) ---
    put_array :: proc(x, y: c.int, w, h: c.int, data: [^]c.uint8_t, row_stride: c.int, column_stride: c.int, layout: rawptr, char_size: c.int) -> c.int ---
}

@private
@(link_prefix = "terminal_")
@(default_calling_convention = "c")
foreign bearlibterminal {
    set8 :: proc(value: cstring) -> c.int ---
    // ! WARN: unimplemented
    set16 :: proc(value: [^]u16) -> c.int ---
    set32 :: proc(value: [^]rune) -> c.int ---

    font8 :: proc(name: cstring) ---
    // ! WARN: unimplemented
    font16 :: proc(name: [^]u16) ---
    font32 :: proc(name: [^]rune) ---

    print_ext8 :: proc(x, y: c.int, w, h: c.int, align: c.int, s: cstring, out_w, out_h: ^c.int) ---
    // ! WARN: unimplemented
    print_ext16 :: proc(x, y: c.int, w, h: c.int, align: c.int, s: [^]u16, out_w, out_h: ^c.int) ---
    print_ext32 :: proc(x, y: c.int, w, h: c.int, align: c.int, s: [^]rune, out_w, out_h: ^c.int) ---

    measure_ext8 :: proc(w, h: c.int, s: cstring, out_w, out_h: ^c.int) ---
    // ! WARN: unimplemented
    measure_ext16 :: proc(w, h: c.int, s: [^]u16, out_w, out_h: ^c.int) ---
    measure_ext32 :: proc(w, h: c.int, s: [^]rune, out_w, out_h: ^c.int) ---

    read_str8 :: proc(x, y: c.int, buffer: [^]byte, max: c.int) -> c.int ---
    // ! WARN: unimplemented
    read_str16 :: proc(x, y: c.int, buffer: [^]u16, max: c.int) -> c.int ---
    read_str32 :: proc(x, y: c.int, buffer: [^]rune, max: c.int) -> c.int ---

    get8 :: proc(key: cstring, default: cstring) -> cstring ---
    // ! WARN: unimplemented
    get16 :: proc(key: [^]u16, default: [^]u16) -> [^]u16 ---
    get32 :: proc(key: [^]rune, default: [^]rune) -> [^]rune ---

    color_from_name8 :: proc(name: cstring) -> color_t ---
    // ! WARN: unimplemented
    color_from_name16 :: proc(name: [^]u16) -> color_t ---
    color_from_name32 :: proc(name: [^]rune) -> color_t ---
}

set :: proc(s: cstring) -> c.int {
    return set8(s)
}

print :: proc(x: c.int, y: c.int, s: string) -> dimensions_t_ {
    ret: dimensions_t_
    print_ext8(x, y, 0, 0, TK_ALIGN_DEFAULT, strings.clone_to_cstring(s), &ret.width, &ret.height)
    return ret
}

measure :: proc(s: cstring) -> dimensions_t_ {
    ret: dimensions_t_
    measure_ext8(0, 0, s, &ret.width, &ret.height)
    return ret
}

// BUG: Still crashing
read_str :: proc(x: c.int, y: c.int, buffer: [dynamic]byte) -> string {
    len := read_str8(x, y, raw_data(buffer), c.int(len(buffer)))
    return string(buffer[:len])
}

get :: proc(key: cstring, default: cstring = "0") -> cstring {
    return get8(key, default)
}

color_from_name :: proc(name: cstring) -> color_t {
    return color_from_name8(name)
}

/*
 * Keyboard scancodes for events/states
 */
TK_A :: 0x04
TK_B :: 0x05
TK_C :: 0x06
TK_D :: 0x07
TK_E :: 0x08
TK_F :: 0x09
TK_G :: 0x0A
TK_H :: 0x0B
TK_I :: 0x0C
TK_J :: 0x0D
TK_K :: 0x0E
TK_L :: 0x0F
TK_M :: 0x10
TK_N :: 0x11
TK_O :: 0x12
TK_P :: 0x13
TK_Q :: 0x14
TK_R :: 0x15
TK_S :: 0x16
TK_T :: 0x17
TK_U :: 0x18
TK_V :: 0x19
TK_W :: 0x1A
TK_X :: 0x1B
TK_Y :: 0x1C
TK_Z :: 0x1D
TK_1 :: 0x1E
TK_2 :: 0x1F
TK_3 :: 0x20
TK_4 :: 0x21
TK_5 :: 0x22
TK_6 :: 0x23
TK_7 :: 0x24
TK_8 :: 0x25
TK_9 :: 0x26
TK_0 :: 0x27
TK_RETURN :: 0x28
TK_ENTER :: 0x28
TK_ESCAPE :: 0x29
TK_BACKSPACE :: 0x2A
TK_TAB :: 0x2B
TK_SPACE :: 0x2C
TK_MINUS :: 0x2D /*  -  */
TK_EQUALS :: 0x2E /*  =  */
TK_LBRACKET :: 0x2F /*  [  */
TK_RBRACKET :: 0x30 /*  ]  */
TK_BACKSLASH :: 0x31 /*  \  */
TK_SEMICOLON :: 0x33 /*  ;  */
TK_APOSTROPHE :: 0x34 /*  '  */
TK_GRAVE :: 0x35 /*  `  */
TK_COMMA :: 0x36 /*  ,  */
TK_PERIOD :: 0x37 /*  .  */
TK_SLASH :: 0x38 /*  /  */
TK_F1 :: 0x3A
TK_F2 :: 0x3B
TK_F3 :: 0x3C
TK_F4 :: 0x3D
TK_F5 :: 0x3E
TK_F6 :: 0x3F
TK_F7 :: 0x40
TK_F8 :: 0x41
TK_F9 :: 0x42
TK_F10 :: 0x43
TK_F11 :: 0x44
TK_F12 :: 0x45
TK_PAUSE :: 0x48 /* Pause/Break */
TK_INSERT :: 0x49
TK_HOME :: 0x4A
TK_PAGEUP :: 0x4B
TK_DELETE :: 0x4C
TK_END :: 0x4D
TK_PAGEDOWN :: 0x4E
TK_RIGHT :: 0x4F /* Right arrow */
TK_LEFT :: 0x50 /* Left arrow */
TK_DOWN :: 0x51 /* Down arrow */
TK_UP :: 0x52 /* Up arrow */
TK_KP_DIVIDE :: 0x54 /* '/' on numpad */
TK_KP_MULTIPLY :: 0x55 /* '*' on numpad */
TK_KP_MINUS :: 0x56 /* '-' on numpad */
TK_KP_PLUS :: 0x57 /* '+' on numpad */
TK_KP_ENTER :: 0x58
TK_KP_1 :: 0x59
TK_KP_2 :: 0x5A
TK_KP_3 :: 0x5B
TK_KP_4 :: 0x5C
TK_KP_5 :: 0x5D
TK_KP_6 :: 0x5E
TK_KP_7 :: 0x5F
TK_KP_8 :: 0x60
TK_KP_9 :: 0x61
TK_KP_0 :: 0x62
TK_KP_PERIOD :: 0x63 /* '.' on numpad */
TK_SHIFT :: 0x70
TK_CONTROL :: 0x71
TK_ALT :: 0x72

/*
    * Mouse events/states
    */
TK_MOUSE_LEFT :: 0x80 /* Buttons */
TK_MOUSE_RIGHT :: 0x81
TK_MOUSE_MIDDLE :: 0x82
TK_MOUSE_X1 :: 0x83
TK_MOUSE_X2 :: 0x84
TK_MOUSE_MOVE :: 0x85 /* Movement event */
TK_MOUSE_SCROLL :: 0x86 /* Mouse scroll event */
TK_MOUSE_X :: 0x87 /* Cusor position in cells */
TK_MOUSE_Y :: 0x88
TK_MOUSE_PIXEL_X :: 0x89 /* Cursor position in pixels */
TK_MOUSE_PIXEL_Y :: 0x8A
TK_MOUSE_WHEEL :: 0x8B /* Scroll direction and amount */
TK_MOUSE_CLICKS :: 0x8C /* Number of consecutive clicks */

/*
    * If key was released instead of pressed, it's code will be OR'ed with TK_KEY_RELEASED:
    * a) pressed 'A': 0x04
    * b) released 'A': 0x04|VK_KEY_RELEASED = 0x104
    */
TK_KEY_RELEASED :: 0x100

/*
    * Virtual key-codes for internal terminal states/variables.
    * These can be accessed via terminal_state function.
    */
TK_WIDTH :: 0xC0 /* Terminal window size in cells */
TK_HEIGHT :: 0xC1
TK_CELL_WIDTH :: 0xC2 /* Character cell size in pixels */
TK_CELL_HEIGHT :: 0xC3
TK_COLOR :: 0xC4 /* Current foregroung color */
TK_BKCOLOR :: 0xC5 /* Current background color */
TK_LAYER :: 0xC6 /* Current layer */
TK_COMPOSITION :: 0xC7 /* Current composition state */
TK_CHAR :: 0xC8 /* Translated ANSI code of last produced character */
TK_WCHAR :: 0xC9 /* Unicode codepoint of last produced character */
TK_EVENT :: 0xCA /* Last dequeued event */
TK_FULLSCREEN :: 0xCB /* Fullscreen state */

/*
    * Other events
    */
TK_CLOSE :: 0xE0
TK_RESIZED :: 0xE1

/*
    * Generic mode enum.
    * Right now it is used for composition option only.
    */
TK_OFF :: 0
TK_ON :: 1

/*
    * Input result codes for terminal_read function.
    */
TK_INPUT_NONE :: 0
TK_INPUT_CANCELLED :: -1

/*
    * Text printing alignment.
    */
TK_ALIGN_DEFAULT :: 0
TK_ALIGN_LEFT :: 1
TK_ALIGN_RIGHT :: 2
TK_ALIGN_CENTER :: 3
TK_ALIGN_TOP :: 4
TK_ALIGN_BOTTOM :: 8
TK_ALIGN_MIDDLE :: 12

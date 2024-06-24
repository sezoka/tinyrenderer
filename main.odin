package tinyrenderer

import "core:fmt"
import "core:math"
import "core:mem"
import rl "vendor:raylib"

SCREEN_WIDTH :: 512
SCREEN_HEIGHT :: 512

swap :: proc(x: ^$T, y: ^T) {
	temp := x^
	x^ = y^
	y^ = temp
}

// void line(int x0, int y0, int x1, int y1, TGAImage &image, TGAColor color) { 
draw_line :: proc(x0, y0, x1, y1: i32, color: rl.Color) {
	x0 := x0
	y0 := y0
	x1 := x1
	y1 := y1

	steep := abs(x0 - x1) < abs(y0 - y1)
	if steep {
		swap(&x0, &y0)
		swap(&x1, &y1)
	}

	if x0 > x1 {
		swap(&x0, &x1)
		swap(&y0, &y1)
	}

	dx := x1 - x0
	dy := y1 - y0

	derror2 := abs(dy) * 2
	error2: i32 = 0
	y := y0
	for x := x0; x <= x1; x += 1 {
		if steep {
			rl.DrawPixel(SCREEN_HEIGHT - y, SCREEN_WIDTH - x, color)
		} else {
			rl.DrawPixel(SCREEN_WIDTH - x, SCREEN_HEIGHT - y, color)
		}
		error2 += derror2
		if dx < error2 {
			y += y1 > y0 ? 1 : -1
			error2 -= dx * 2
		}
	}
}

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "tinyrenderer")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	model, model_ok := load_model("./obj/african_head.obj")
	fmt.println("HER", model)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground(rl.BLACK)

		for face in model.faces {
			for face_idx in 0 ..< len(face) {
				v0 := model.verts[face[face_idx]]
				v1 := model.verts[face[(face_idx + 1) % 3]]
				x0 := (v0.x + 1) * SCREEN_WIDTH / 2
				y0 := (v0.y + 1) * SCREEN_HEIGHT / 2
				x1 := (v1.x + 1) * SCREEN_WIDTH / 2
				y1 := (v1.y + 1) * SCREEN_HEIGHT / 2
        draw_line(i32(x0), i32(y0), i32(x1), i32(y1), rl.WHITE)
			}
		}

		rl.DrawPixel(50, 50, rl.BLACK)
	}
}

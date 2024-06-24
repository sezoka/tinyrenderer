package tinyrenderer

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

Face :: [3]i32

Model :: struct {
	verts: [dynamic]Vec3f,
	faces: [dynamic]Face,
}


load_model :: proc(file_path: string) -> (result: Model, success: bool) {
	text := string(os.read_entire_file_from_filename(file_path) or_return)
	defer delete(text)

	text_iter := text
	for line in strings.split_lines_iterator(&text_iter) {
		if len(line) <= 2 do continue

		if line[0:2] == "v " {
			line := line[2:]

			x_str := strings.split_iterator(&line, " ") or_return
			y_str := strings.split_iterator(&line, " ") or_return
			z_str := strings.split_iterator(&line, " ") or_return

			x := strconv.parse_f32(x_str) or_return
			y := strconv.parse_f32(y_str) or_return
			z := strconv.parse_f32(z_str) or_return

			append(&result.verts, Vec3f{x, y, z})
		} else if line[0:2] == "f " {
			line := line[2:]

			a_str := strings.split_iterator(&line, " ") or_return
			b_str := strings.split_iterator(&line, " ") or_return
			c_str := strings.split_iterator(&line, " ") or_return

			vert_idx_a_str := strings.split_iterator(&a_str, "/") or_return
			vert_idx_b_str := strings.split_iterator(&b_str, "/") or_return
			vert_idx_c_str := strings.split_iterator(&c_str, "/") or_return

			vert_idx_a := i32(strconv.parse_int(vert_idx_a_str, 10) or_return) - 1
			vert_idx_b := i32(strconv.parse_int(vert_idx_b_str, 10) or_return) - 1
			vert_idx_c := i32(strconv.parse_int(vert_idx_c_str, 10) or_return) - 1

			append(&result.faces, Face{vert_idx_a, vert_idx_b, vert_idx_c})
		}
	}


	return result, true
}

// std::ifstream in;
//  in.open (filename, std::ifstream::in);
//  if (in.fail()) return;
//  std::string line;
//  while (!in.eof()) {
//      std::getline(in, line);
//      std::istringstream iss(line.c_str());
//      char trash;
//      if (!line.compare(0, 2, "v ")) {
//          iss >> trash;
//          Vec3f v;
//          for (int i=0;i<3;i++) iss >> v.raw[i];
//          verts_.push_back(v);
//      } else if (!line.compare(0, 2, "f ")) {
//          std::vector<int> f;
//          int itrash, idx;
//          iss >> trash;
//          while (iss >> idx >> trash >> itrash >> trash >> itrash) {
//              idx--; // in wavefront obj all indices start at 1, not zero
//              f.push_back(idx);
//          }
//          faces_.push_back(f);
//      }
//  }
//  std::cerr << "# v# " << verts_.size() << " f# "  << faces_.size() << std::endl;

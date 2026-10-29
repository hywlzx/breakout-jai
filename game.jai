WIDTH  : = 800;
HEIGHT : = 600;

BACKGROUP_COLOR :: Vector4.{0.2, 0.3, 0.4, 1};
PLAYER_COLOR :: Vector4.{1, 0.1, 0.2, 1};

PLAYER_WIDTH := 100.0;
PLAYER_HEIGH := 50.0;

FPS := 60;
BORDER := 20.0;

Player :: struct {
   width     : float;
   height    : float;

   direction : Direction = .INIT;
   position  : *Vector4;
   speed     : float;
}

Direction :: enum u8 {
    INIT  :: 0;
    LEFT  :: 1;
    RIGHT :: 2;
    IDLE  :: 3;
}

main :: () {
    win := create_window(WIDTH, HEIGHT, "Game");
    set_render_target(win);
    w, _ := get_render_dimensions(win);

    player := Player.{width = PLAYER_WIDTH, height = PLAYER_HEIGH, position = *Vector4.{}, speed = xx w / 100};
    quit := false;

    print("game_width: %\n", w);

    using player;
    while !quit {
        update_window_events();

        for event : events_this_frame {
            if event.key_code == {
                case .ESCAPE; quit = true;
                case .ARROW_LEFT {
                    ifx event.key_pressed then direction = .LEFT else direction = .IDLE;
                }
                case .ARROW_RIGHT {
                    ifx event.key_pressed then direction = .RIGHT else direction = .IDLE;
                }
            }
        }

        clear_render_target(vector4_flat(BACKGROUP_COLOR));
        set_shader_for_color(true);

        refresh_player(player, xx w);
        swap_buffers(win);
    }
}

refresh_player :: (using player : Player, game_width : float) {
    using position;
    if direction == {
        case .INIT {
            x = game_width / 2 - width;
            y = BORDER;
            z = game_width / 2 + width;
            w = xx height;
        }
        case .LEFT {
            if x - speed < BORDER {
                x = BORDER;
                z = BORDER + width * 2;
            } else {
                x -= speed;
                z -= speed;
            } 
        }
        case .RIGHT {
            if z + speed > game_width - BORDER {
                z = game_width - BORDER;
                x = z - width * 2;
            } else {
                x += speed;
                z += speed;
            }
        }
    }
    immediate_quad(vector4_flat_x(position, PLAYER_COLOR));
}

vector4_flat :: (using vec : Vector4) -> float, float, float, float {
    return x, y, z, w;
}

vector4_flat_x :: (using vec : Vector4, vec2 : Vector4) -> float, float, float, float, Vector4 {
    return x, y, z, w, vec2;
}

operator + :: (vec : Vector4, num : float) -> Vector4 {
    x := vec.x + num;
    y := vec.y + num;
    z := vec.z + num;
    w := vec.w + num;
    return Vector4.{x, y, z, w};
}

#import "Basic";
#import "Window_Creation";
#import "Simp";
#import "Input";
#import "Math";
#import "ImGui";

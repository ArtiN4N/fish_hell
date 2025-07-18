package src

import rl "vendor:raylib"
import fmt "core:fmt"

INVENTORY_setup_menu_stats :: proc(menu: ^Menu) {
    rw, rh := APP_get_global_render_size()

    menu.color = UI_COLOR
    menu.top_left = FVECTOR_ZERO
    menu.size = FVector{f32(rw), f32(rh)}

    menu.y_margin = 5
    menu.x_margin = 5

    menu.elements = make([dynamic]MENU_Element)
    menu.created = true
    ui_font_ptr := APP_get_global_font(.Dialouge24_reg)
    
    append(&menu.elements, MENU_Element{
        ele = MENU_Button{
            label = "Return",
            text_color = UI_COLOR,
            text_hover_color = UI_COLOR,
            text_clicked_color = DMG_COLOR,
            font = ui_font_ptr,
            fsize = 24,

            size = {160, 30},
            rect_color = WHITE_COLOR,
            rect_hover_color = AMMO_HUD_COLOR,
            rect_clicked_color = AMMO_HUD_COLOR,

            callback = proc() {
                MENU_set_menu(&APP_global_app.menu, .Menu_Inventory)
            },
        },
        offset = {0, 0}
    })

    append(&menu.elements, MENU_Element{
        ele = MENU_Button{
            label = "",
            text_color = WHITE_COLOR,
            text_hover_color = WHITE_COLOR,
            text_clicked_color = DMG_COLOR,
            font = ui_font_ptr,
            fsize = 24,

            size = {2, menu.size.y - menu.y_margin * 2},
            rect_color = WHITE_COLOR,
            rect_hover_color = WHITE_COLOR,
            rect_clicked_color = WHITE_COLOR,

            callback = proc() {},
        },
        offset = {200, -35}
    })

    append(&menu.elements, MENU_Element{
        ele = MENU_Button{
            label = "Spend point on hp",
            text_color = UI_COLOR,
            text_hover_color = UI_COLOR,
            text_clicked_color = DMG_COLOR,
            font = ui_font_ptr,
            fsize = 24,

            size = {270, 30},
            rect_color = WHITE_COLOR,
            rect_hover_color = AMMO_HUD_COLOR,
            rect_clicked_color = AMMO_HUD_COLOR,

            callback = proc() {
                STATS_global_player_level_up_hp()
            },
        },
        offset = {225, -(menu.size.y - menu.y_margin * 2)}
    })

    append(&menu.elements, MENU_Element{
        ele = MENU_Button{
            label = "Spend point on dmg",
            text_color = UI_COLOR,
            text_hover_color = UI_COLOR,
            text_clicked_color = DMG_COLOR,
            font = ui_font_ptr,
            fsize = 24,

            size = {270, 30},
            rect_color = WHITE_COLOR,
            rect_hover_color = AMMO_HUD_COLOR,
            rect_clicked_color = AMMO_HUD_COLOR,

            callback = proc() {
                STATS_global_player_level_up_dmg()
            },
        },
        offset = {225, 0}
    })
    
    append(&menu.elements, MENU_Element{
        ele = MENU_Button{
            label = "Spend point on speed",
            text_color = UI_COLOR,
            text_hover_color = UI_COLOR,
            text_clicked_color = DMG_COLOR,
            font = ui_font_ptr,
            fsize = 24,

            size = {270, 30},
            rect_color = WHITE_COLOR,
            rect_hover_color = AMMO_HUD_COLOR,
            rect_clicked_color = AMMO_HUD_COLOR,

            callback = proc() {
                STATS_global_player_level_up_speed()
            },
        },
        offset = {225, 0}
    })

    append(&menu.elements, MENU_Element{
        ele = MENU_Text{
            text = "Born of",
            color = WHITE_COLOR,
            font = ui_font_ptr,
            fsize = 24,
        },
        offset = {0, -35 * 2}
    })

    append(&menu.elements, MENU_Element{
        ele = MENU_Text{
            text = APP_global_app.game.stats_manager.boon_title,
            color = rl.RED,
            font = ui_font_ptr,
            fsize = 24,
        },
        offset = {96, -24 - 4}
    })

    append(&menu.elements, MENU_Element{
        ele = MENU_Formatted_Text(int){
            text = MENU_Text{
                text = "Level:  %v",
                color = WHITE_COLOR,
                font = ui_font_ptr,
                fsize = 24,
            },
            arg = &APP_global_app.game.stats_manager.level
        },
        offset = {0, 0}
    })

    append(&menu.elements, MENU_Element{
        ele = MENU_Formatted_Text(int){
            text = MENU_Text{
                text = "Points: %v",
                color = WHITE_COLOR,
                font = ui_font_ptr,
                fsize = 24,
            },
            arg = &APP_global_app.game.stats_manager.points
        },
        offset = {0, 0}
    })

    append(&menu.elements, MENU_Element{
        ele = MENU_Formatted_Text(f32){
            text = MENU_Text{
                text = "XP:     %.0f",
                color = WHITE_COLOR,
                font = ui_font_ptr,
                fsize = 24,
            },
            arg = &APP_global_app.game.stats_manager.experience
        },
        offset = {0, 0}
    })

    append(&menu.elements, MENU_Element{
        ele = MENU_Formatted_Text(f32){
            text = MENU_Text{
                text = "Req XP: %.0f",
                color = WHITE_COLOR,
                font = ui_font_ptr,
                fsize = 24,
            },
            arg = &APP_global_app.game.stats_manager.next_xp
        },
        offset = {0, 0}
    })

    

    append(&menu.elements, MENU_Element{
        ele = MENU_Formatted_Text(f32){
            text = MENU_Text{
                text = "Health: %.0f",
                color = WHITE_COLOR,
                font = ui_font_ptr,
                fsize = 24,
            },
            arg = &APP_global_app.game.stats_manager.max_hp
        },
        offset = {0, 0}
    })

    append(&menu.elements, MENU_Element{
        ele = MENU_Formatted_Text(f32){
            text = MENU_Text{
                text = "Damage: %.0f",
                color = WHITE_COLOR,
                font = ui_font_ptr,
                fsize = 24,
            },
            arg = &APP_global_app.game.stats_manager.dmg
        },
        offset = {0, 0}
    })

    append(&menu.elements, MENU_Element{
        ele = MENU_Formatted_Text(f32){
            text = MENU_Text{
                text = "Speed:  %.0f",
                color = WHITE_COLOR,
                font = ui_font_ptr,
                fsize = 24,
            },
            arg = &APP_global_app.game.stats_manager.speed
        },
        offset = {0, 0}
    })
}

INVENTORY_setup_menu :: proc(menu: ^Menu) {
    _rw, _rh := APP_get_global_render_size()
    
    rw, rh := f32(_rw), f32(_rh)
    tlx, tly := rw * 0.25 * 0.5, rh * 0.25 * 0.5
    canvas_rec := rl.Rectangle{ tlx, tly, rw * 0.75, rh * 0.75}

    menu.color = UI_COLOR
    menu.top_left = {tlx, tly + canvas_rec.height - 42}
    menu.size = FVector{canvas_rec.width, 42}

    menu.y_margin = 6
    menu.x_margin = 10

    menu.elements = make([dynamic]MENU_Element)
    menu.created = true
    ui_font_ptr := APP_get_global_font(.Dialouge24_reg)
    
    append(&menu.elements, MENU_Element{
        ele = MENU_Button{
            label = "Map",
            text_color = UI_COLOR,
            text_hover_color = UI_COLOR,
            text_clicked_color = DMG_COLOR,
            font = ui_font_ptr,
            fsize = 24,
            size = FVector{100, 30},
            rect_color = WHITE_COLOR,
            rect_hover_color = AMMO_HUD_COLOR,
            rect_clicked_color = AMMO_HUD_COLOR,
            callback = proc() {
                INVENTORY_global_set_page(.Map)
            }
        },
        offset = FVECTOR_ZERO
    })

    append(&menu.elements, MENU_Element{
        ele = MENU_Button{
            label = "Items",
            text_color = UI_COLOR,
            text_hover_color = UI_COLOR,
            text_clicked_color = DMG_COLOR,
            font = ui_font_ptr,
            fsize = 24,
            size = FVector{100, 30},
            rect_color = WHITE_COLOR,
            rect_hover_color = AMMO_HUD_COLOR,
            rect_clicked_color = AMMO_HUD_COLOR,
            callback = proc() {
                INVENTORY_global_set_page(.Items)
            }
        },
        offset = FVector{120, -36}
    })

    append(&menu.elements, MENU_Element{
        ele = MENU_Button{
            label = "Stats",
            text_color = UI_COLOR,
            text_hover_color = UI_COLOR,
            text_clicked_color = DMG_COLOR,
            font = ui_font_ptr,
            fsize = 24,
            size = FVector{100, 30},
            rect_color = WHITE_COLOR,
            rect_hover_color = AMMO_HUD_COLOR,
            rect_clicked_color = AMMO_HUD_COLOR,
            callback = proc() {
                MENU_set_menu(&APP_global_app.menu, .Menu_Inventory_Stats)
                //INVENTORY_global_set_page(.Stats)
            }
        },
        offset = FVector{240, -36}
    })

    append(&menu.elements, MENU_Element{
        ele = MENU_Button{
            label = "Warp to Spawn",
            text_color = UI_COLOR,
            text_hover_color = UI_COLOR,
            text_clicked_color = DMG_COLOR,
            font = ui_font_ptr,
            fsize = 24,
            size = FVector{195, 30},
            rect_color = WHITE_COLOR,
            rect_hover_color = AMMO_HUD_COLOR,
            rect_clicked_color = AMMO_HUD_COLOR,
            callback = proc() {
                LEVEL_global_warp_to_spawn()
            }
        },
        offset = FVector{360, -36}
    })
}
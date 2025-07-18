package src

import rl "vendor:raylib"
import fmt "core:fmt"
import log "core:log"

TRANSITION_set :: proc(from, to: APP_Functional_State) {
    app := &APP_global_app
    trans_data := &app.static_trans_data
    level_man := &app.game.level_manager

    if to == .Game do APP_lock_cursor()
    if to == .Entry do MENU_set_menu(&app.menu, .Menu_main)

    #partial switch from {
    case .Entry:
        TRANSITION_entry_game()
        return
    case .Intro:
        #partial switch to {
        case .Game:
            TRANSITION_global_draw_intro(trans_data.from_tex)
            TRANSITION_from_intro_to_game()
            TRANSITION_global_draw_game(trans_data.to_tex, level_man.current_level, true, true)
            return
        }
    case .Game:
        #partial switch to {
        case .Game:
            TRANSITION_from_level_to_level(app.game.level_manager.travel_dir)
            TRANSITION_global_draw_game(trans_data.to_tex, level_man.current_level, true, true)
            return
        case .Inventory:
            APP_unlock_cursor()
            MENU_set_menu(&app.menu, .Menu_Inventory)
            TRANSITION_global_draw_game(trans_data.from_tex, level_man.current_level, true, true)
            TRANSITION_from_game_to_inventory()
            TRANSITION_global_draw_inventory(trans_data.to_tex)
            return
        case .Dialouge:
            TRANSITION_from_game_to_dialouge()
            return
        case .Savepoint:
            APP_unlock_cursor()
            MENU_set_menu(&app.menu, .Menu_savepoint)
            TRANSITION_from_game_to_savepoint()
            return
        case .Outro:
            APP_unlock_cursor()
            MENU_set_menu(&app.menu, .Menu_main)
            TRANSITION_from_game_to_outro()
            return
        case .Menu:
            APP_unlock_cursor()
            TRANSITION_from_game_to_menu()
            return
        }

    case .Inventory:
        TRANSITION_global_draw_inventory(trans_data.to_tex)

        #partial switch to {
        case .Game:
            TRANSITION_from_inventory_to_game()
            TRANSITION_global_draw_game(trans_data.from_tex, level_man.current_level)
            return
        }

    case .Menu:
        TRANSITION_global_draw_menu(trans_data.from_tex)
        
        #partial switch to {
        case .Game:
            TRANSITION_from_main_menu_to_game(APP_global_app.game.in_game)
            TRANSITION_global_draw_game(trans_data.to_tex, level_man.current_level)
            return
        case .Intro:
            TRANSITION_from_main_menu_to_intro()
            //TRANSITION_global_draw_menu(trans_data.from_tex)
            TRANSITION_global_draw_intro(trans_data.to_tex)
            //TRANSITION_global_draw_black_menu(trans_data.to_tex)
            return
        }
    
    case .Dialouge:
        #partial switch to {
        case .Game:
            TRANSITION_from_dialouge_to_game()
            return
        }
    case .Savepoint:
        TRANSITION_global_draw_menu(trans_data.from_tex)
        #partial switch to {
        case .Game:
            TRANSITION_from_savepoint_to_game()
            TRANSITION_global_draw_game(trans_data.to_tex, level_man.current_level)
            return
        }
    case .Outro:
        TRANSITION_to_menu_from_outro()
        return
    }
    
    log.fatalf("Invalid transition attempt from %v to %v", from, to)
    panic("check log")
}

TRANSITION_entry_game :: proc() {
    log.infof("State Entering to main menu")

    app := &APP_global_app
    app.state = APP_Menu_State{}
}

TRANSITION_to_menu_from_outro :: proc() {
    log.infof("State transition from outro to menu")

    app := &APP_global_app
    app.state = APP_create_transition_state(.Outro, .Menu, 3)
}


TRANSITION_from_game_to_outro :: proc() {
    log.infof("State transition from game to outro")

    app := &APP_global_app
    app.state = APP_create_transition_state(.Game, .Outro, 3)

    SOUND_global_music_remove_all()
    app.game.player.move_dir = FVECTOR_ZERO
}

TRANSITION_from_game_to_savepoint :: proc() {
    log.infof("State transition from game to savepoint")

    app := &APP_global_app
    app.state = APP_create_transition_state(.Game, .Savepoint, 0)

    SOUND_global_music_remove_all()
    SOUND_global_music_manager_add_tag(SOUND_music_savepoint_tag)
}

TRANSITION_from_savepoint_to_game :: proc() {
    log.infof("State transition from savepoint to game")

    app := &APP_global_app
    app.state = APP_create_transition_state(.Savepoint, .Game, 0.5)

    SOUND_global_music_manager_remove_tag(SOUND_music_savepoint_tag)
    man := &app.game.level_manager
    SOUND_global_music_play_by_room(man.current_room)
}

TRANSITION_from_dialouge_to_game :: proc() {
    log.infof("State transition from dialouge to game")

    app := &APP_global_app
    app.state = APP_create_transition_state(.Dialouge, .Game, 0)

    SOUND_global_music_manager_remove_tag(SOUND_music_npc_tag)

    man := &app.game.level_manager
    SOUND_global_music_play_by_room(man.current_room)
}

TRANSITION_from_game_to_dialouge :: proc() {
    log.infof("State transition from game to dialouge")

    app := &APP_global_app
    app.state = APP_create_transition_state(.Game, .Dialouge, 0)

    SOUND_global_music_manager_add_tag(SOUND_music_npc_tag)
}

TRANSITION_from_main_menu_to_intro :: proc() {
    log.infof("State transition from menu to intro")

    app := &APP_global_app
    app.state = APP_create_transition_state(.Menu, .Intro, 5)

    SOUND_global_music_manager_add_tag(SOUND_music_menu_tag)
    //LEVEL_global_manager_enter_world()
}

TRANSITION_from_intro_to_game :: proc() {
    log.infof("State transition from intro to game")

    app := &APP_global_app
    app.state = APP_create_transition_state(.Intro, .Game, 5)

    SOUND_global_music_manager_remove_tag(SOUND_music_menu_tag)
    LEVEL_global_manager_enter_world()

    app.game.in_game = true
}

TRANSITION_from_game_to_menu :: proc() {
    log.infof("State transition from game to menu")
    app := &APP_global_app
    app.state = APP_create_transition_state(.Game, .Menu, 0)
}

TRANSITION_from_main_menu_to_game :: proc(in_game: bool) {
    log.infof("State transition from menu to game")

    app := &APP_global_app
    app.state = APP_create_transition_state(.Menu, .Game, 2)

    if !in_game {
        SOUND_global_music_manager_remove_tag(SOUND_music_menu_tag)
        LEVEL_global_manager_enter_world()
        app.game.in_game = true
    }
}

TRANSITION_from_level_to_level :: proc(dir: LEVEL_Room_Connection) {
    app := &APP_global_app
    app.static_trans_data.warp_dir = dir

    app.state = APP_create_transition_state(.Game, .Game, 0.5)
    log.infof("State transition from level to level")
}

TRANSITION_from_game_to_inventory :: proc() {
    log.infof("State transition from game to inventory")

    app := &APP_global_app
    app.state = APP_create_transition_state(.Game, .Inventory, 0.5)
}

TRANSITION_from_inventory_to_game :: proc() {
    log.infof("State transition from inventory to game")

    app := &APP_global_app
    app.state = APP_create_transition_state(.Inventory, .Game, 0.5)
}
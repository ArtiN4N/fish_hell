package src

PARRY_RADIUS :: 30.0

CONST_Bullet_Type :: enum {
    None = 0,
    Player,
    Lobber,
    Octo,
    Eel,
}


CONST_Bullet_Stat :: struct {
    bullet_speed: f32,
    bullet_radius: f32,
    bullet_time: f32,
    bullet_dmg: f32,
    bullet_parry: BULLET_parry_signature,
    bullet_on_hit: BULLET_on_hit,
}

@(rodata)
CONST_bullet_stats: [CONST_Bullet_Type]CONST_Bullet_Stat = {
    .None = {
        bullet_speed = 0,
        bullet_radius = 0,
        bullet_time = 0,
        bullet_dmg = 0,
        bullet_parry = BULLET_parry_none,
        bullet_on_hit = BULLET_on_hit_default,
    },
    .Player = {
        bullet_speed = 50,
        bullet_radius = 5,
        bullet_time = 5,
        bullet_dmg = 10,
        bullet_parry = BULLET_parry_none,
        bullet_on_hit = BULLET_on_hit_default,
    },
    .Lobber = {
        bullet_speed = 20,
        bullet_radius = 10,
        bullet_time = 7,
        bullet_dmg = 20,
        bullet_parry = BULLET_parry_default,
        bullet_on_hit = BULLET_on_hit_default,
    },
    .Octo = {
        bullet_speed = 30,
        bullet_radius = 10,
        bullet_time = 7,
        bullet_dmg = 20,
        bullet_parry = BULLET_parry_default,
        bullet_on_hit = BULLET_on_hit_default,
    },
    .Eel = {
        bullet_speed = 20,
        bullet_radius = 8,
        bullet_time = 7,
        bullet_dmg = 10,
        bullet_parry = BULLET_parry_default,
        bullet_on_hit = BULLET_on_hit_default, 
    },
}
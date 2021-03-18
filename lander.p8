pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
function _init()
    game_over = false
    win = false
    g = 0.025
    make_player()
    make_ground()
end
function _update()
    if (not game_over)then
        move_player()
        check_land()
    else
        if (btn(5)) _init()
    end
end
function _draw()
    cls()
    rectfill(0,127,127,0,12) --sky
    draw_stars()
    draw_ground()
    draw_player()
    if (game_over) then
        if (win) then
            print("you win! ", 48,48,14)
        else
            print("so close! ",48,48,13)
        end
        print(" press to play again ",20,70,7)
    end
end
function make_player()
    p={}
    p.x=60 --position
    p.y=8
    p.dx=0 --movement
    p.dy=0
    p.sprite=1
    p.alive=true
    p.thrust=0.075
end
function draw_player()
    spr(p.sprite,p.x,p.y)
    if (game_over and win) then
        spr(4, p.x, p.y - 8) --flag
    elseif (game_over)then
        spr(5,p.x, p.y) --smoke
    end
end

function move_player()
    p.dy += g 

    thrust()
    p.x += p.dx
    p.y += p.dy
    stay_on_screen()
end

function thrust()
    if (btn(0)) p.dx -= p.thrust
    if (btn(1)) p.dx += p.thrust
    if (btn(2)) p.dy -= p.thrust

    if (btn(0) or btn(1) or btn(2)) sfx(0)
end

function stay_on_screen()
    if (p.x < 0) then
        p.x = 0
        p.dx = 0
    end
    if (p.x > 120) then
        p.x = 120
        p.dx = 0
    end
    if (p.y < 0) then
        p.y = 0
        p.dy = 0
    end

end

function rndb(low,high)
    return flr(rnd(high-low+1)+low)
end


function draw_stars()
    srand(1)
    for i=1,50 do 
        pset(rndb(0,127),rndb(0,127),rndb(6,7))
    end
    srand(time())
end

function  make_ground()
    gnd={} --ground
    local top = 96
    local btm = 120

    pad = {} --landing pad
    pad.width =15
    pad.x = rndb(0,126-pad.width)
    pad.y = rndb(top, btm)
    pad.sprite = 2

    for i = pad.x, pad.x+pad.width do --create ground at pad
        gnd[i]=pad.y
    end

    for i = pad.x+pad.width+1,127 do --create right of pad
        local h=rndb(gnd[i-1]-3,gnd[i-1]+3)
        gnd[i]=mid(top,h,btm)
    end

    for i = pad.x-1,0,-1 do --create left of pad
        local h=rndb(gnd[i+1]-3,gnd[i+1]+3)
        gnd[i]=mid(top,h,btm)
    end
end

function draw_ground()
    for i=0, 127 do
        line(i,gnd[i],i,127,3)
    end
    spr(pad.sprite,pad.x,pad.y,2,1)
end

function check_land()
    l_x = flr(p.x) --left
    r_x = flr(p.x+7) --right
    b_y = flr(p.y+7) --bottom

    over_pad = l_x >= pad.x and r_x <= pad.x +pad.width
    on_pad = b_y>= pad.y-1
    slow=p.dy< 1
    
    if (over_pad and on_pad and slow) then
        end_game(true)
    elseif (over_pad and on_pad)then
        end_game(false)
    else
        for i=l_x,r_x do
            if(gnd[i] <= b_y) end_game(false)
        end
    end
end
function end_game(won)
    game_over = true
    win = won
    if (win) then
        sfx(1)
    else
        sfx(2)
    end
end
__gfx__
000000000eeeefe0eeffffffffffff7e000000007007700700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000eeeeeefe0edddddddddddde0000000000766667000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700eeeeeefe0eeeeeeeeeeeeee0000000000667766000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000eeeefe00000000000000000000e70007676676700000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000eeee00000000000000000000ee70007676676700000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000000000000000000000000000eee70000667766000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d66d000000000000000000000070000766667000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dddd000000000000000000000070007007700700000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000600001164000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c00001d0701d02017070170200f0700f0201d0701d0200002000000190701b0701b02000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00040000316702c66027650226401f6401c630196301563013620106200d6200b6200961007610046100261001610000000000000000000000000000000000000000000000000000000000000000000000000000

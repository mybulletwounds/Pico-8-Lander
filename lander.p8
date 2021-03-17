pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
function _init()
    g = 0.025
    make_player()
    make_ground()
end
function _update()
    move_player()
end
function _draw()
    cls()
    draw_stars()
    draw_ground()
    draw_player()
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
        pset(rndb(0,127),rndb(0,127),rndb(5,7))
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
        line(i,gnd[i],i,127,5)
    end
end

__gfx__
00000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000005c75000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000006c76000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700006cc6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000065555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000660660660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000600001164000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

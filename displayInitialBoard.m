% At this moment, this code is NOT for any practical use.

background_rgb = [255 255 255];
zoom_factor = 3;

game = simpleGameEngine('checkers_Sprites.png', 32, 32, zoom_factor, background_rgb);

b = 13; % Black empty tile sprite index
r = 14; % Red empty tile sprite index

bp = 1; % Black regular piece on board sprite index
rp = 2; % Red regular piece on board sprite index

boardDisplay = [
    rp r  rp r  rp r  rp r;
    r rp  r rp  r rp  r rp;
    rp r  rp r  rp r  rp r;
    r  b  r  b  r  b  r  b;
    b  r  b  r  b  r  b  r;
    r bp  r bp  r bp  r bp;
    bp r  bp r  bp r  bp r;
    r bp  r bp  r bp  r bp;
    ];

drawScene(game, boardDisplay);

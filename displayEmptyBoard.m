% At this moment, this code is NOT for any practical use.

background_rgb = [255 255 255];
zoom_factor = 3;

game = simpleGameEngine('checkers_Sprites.png', 32, 32, zoom_factor, background_rgb);

r = 14; % Red empty tile sprite index
b = 13; % Black empty tile sprite index

board = [
    b  r  b  r  b  r  b  r;
    r  b  r  b  r  b  r  b;
    b  r  b  r  b  r  b  r;
    r  b  r  b  r  b  r  b;
    b  r  b  r  b  r  b  r;
    r  b  r  b  r  b  r  b;
    b  r  b  r  b  r  b  r;
    r  b  r  b  r  b  r  b;
    ];

drawScene(game, board);

clc
clear
close all
% This code is for demonstrating how the game would look like during the
% play.
% THERE IS NO MECHANISM FOR TAKING INPUTS, CHECKING MOVES, ETC.
% All the moves and changes made here are hard-coded by hand.

delay = 0.5; % Delay between "frames" in seconds

background_rgb = [255 255 255]; % This doesn't really matter
zoom_factor = 3;

game = simpleGameEngine('Checkers_Sprites_Temp.png', 32, 32, zoom_factor, background_rgb);

b = 13; % Black empty tile sprite index
r = 14; % Red empty tile sprite index

br = 1; % Black regular piece on board sprite index
rr = 2; % Red regular piece on board sprite index

bk = 3; % Black king piece on board sprite index
rk = 4; % Red king piece on board sprite index

bs = 5; % Black selected regular piece on board sprite index
rs = 6; % Red selected regular piece on board sprite index

bS = 11; % Black selected king piece on board sprite index
rS = 12; % Red selected king piece on board sprite index

bp = 7; % Black possible position sprite index
rp = 8; % Red possible position sprite index

% Initial board formation
boardDisplay = [
    rr r  rr r  rr r  rr r;
    r rr  r rr  r rr  r rr;
    rr r  rr r  rr r  rr r;
    r  b  r  b  r  b  r  b;
    b  r  b  r  b  r  b  r;
    r br  r br  r br  r br;
    br r  br r  br r  br r;
    r br  r br  r br  r br;
    ];

%%%%%
% Additional Stuff
black = 9;  % Black regular piece NOT on board sprite index
red   = 10; % Red regular piece NOT on board sprite index

w  = 30; % White space sprite index
et = 23; % Board top edge sprite index
el = 25; % Board left edge sprite index
er = 26; % Board right edge sprite index
eb = 28; % Board bottom edge sprite index
ul = 22; % Board upper left corner sprite index
ur = 24; % Board upper right corner sprite index
ll = 27; % Board lower left corner sprite index
lr = 29; % Board lower right corner sprite index

top    = [ul et et et et et et et et ur w w];
left   = [
    el;
    el;
    el;
    el;
    el;
    el;
    el;
    el
    ];
right  = [
    er  w      w;
    er  w      w;
    er  w      w;
    er  black  w;
    er  w      w;
    er  w      w;
    er  w      w;
    er  w      w;
    ];
bottom = [ll eb eb eb eb eb eb eb eb lr w w];
%%%%%

% Cell array with each row representing the changes in the board display at
% corresponding "frame". First column contains coordinates of the changes
% and the second column contains the sprite indices that will
% replace the old sprites in the corresponding coordinates. Each value in
% the third column is the index of the sprite representing currently playing
% player's piece.
changes = {
    [6 4; 5 3; 5 5] [bs bp bp] black;
    [6 4; 5 3; 5 5] [b  b  br] red;
    [3 3; 4 2; 4 4] [rs rp rp] red;
    [3 3; 4 2; 4 4] [b  b  rr] black;
    [5 5; 3 3; 4 6] [bs bp bp] black;
    [5 5; 3 3; 4 6; 4 4] [b  br b  b ] red;
    [2 2; 4 4] [rs rp] red;
    [2 2; 4 4; 3 3] [b  rr b ] black;
    [6 2; 5 1; 5 3] [bs bp bp] black;
    [6 2; 5 1; 5 3] [b  b  br] red;
    [4 4; 6 2; 5 5] [rs rp rp] red;
    [4 4; 6 2; 5 5; 5 3] [b  rr b b ] black;
    [7 3; 5 1; 6 4] [bs bp bp] black;
    [7 3; 5 1; 6 4; 6 2] [b  br b  b ] red;
    [3 1; 4 2] [rs rp] red;
    [3 1; 4 2] [b  rr] black;
    [7 1; 6 2] [bs bp] black;
    [7 1; 6 2] [b  br] red;
    [4 2; 5 3] [rs rp] red;
    [4 2; 5 3] [b  rr] black;
    [8 2; 7 1; 7 3] [bs bp bp] black;
    [8 2; 7 1; 7 3] [b  b  br] red;
    [5 3; 7 1; 6 4] [rs rp rp] red;
    [5 3; 7 1; 6 4; 6 2] [b  rr b  b ] black;
    [5 1; 4 2] [bs bp] black;
    [5 1; 4 2] [b  br] red;
    [7 1; 8 2] [rs rp] red;
    [7 1; 8 2] [b  rk] black;
    [4 2; 3 1; 3 3] [bs bp bp] black;
    [4 2; 3 1; 3 3] [b  br b ] red;
    [1 3; 2 2] [rs rp] red;
    [1 3; 2 2] [b  rr] black;
    [3 1; 1 3] [bs bp] black;
    [3 1; 1 3; 2 2] [b  bk b ] red;
    [8 2; 6 4] [rS rp] red;
    [8 2; 6 4; 7 3] [b  rk b ] black;
};

drawScene(game, [top; left boardDisplay right; bottom]);
hold on

for i = 1:size(changes, 1) % size(changes, 1) give the number of rows in 'changes'

    pause(delay)

    nextChange = changes(i, :);

    coords           = nextChange{1};
    newSpriteIndices = nextChange{2};
    turn             = nextChange{3};

    for j = 1:size(coords, 1)
        row          = coords(j, 1);
        col          = coords(j, 2);
        newSpriteIdx = newSpriteIndices(j);

        boardDisplay(row, col) = newSpriteIdx;
    end
    
    right(4, 2) = turn;

    drawScene(game, [top; left boardDisplay right; bottom]);

end

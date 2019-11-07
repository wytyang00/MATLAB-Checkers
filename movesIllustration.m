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

game = simpleGameEngine('checkers_Sprites.png', 32, 32, zoom_factor, background_rgb);

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

% Cell array with each row representing the changes in the board display at
% corresponding "frame". First column contains coordinates of the changes
% and the second column contains the sprite indices that will
% replace the old sprites in the corresponding coordinates.
changes = {
    [6 4; 5 3; 5 5] [bs bp bp];
    [6 4; 5 3; 5 5] [b  b  br];
    [3 3; 4 2; 4 4] [rs rp rp];
    [3 3; 4 2; 4 4] [b  b  rr];
    [5 5; 3 3; 4 6] [bs bp bp];
    [5 5; 3 3; 4 6; 4 4] [b  br b  b ];
    [2 2; 4 4] [rs rp];
    [2 2; 4 4; 3 3] [b  rr b ];
    [6 2; 5 1; 5 3] [bs bp bp];
    [6 2; 5 1; 5 3] [b  b  br];
    [4 4; 6 2; 5 5] [rs rp rp];
    [4 4; 6 2; 5 5; 5 3] [b  rr b b ];
    [7 3; 5 1; 6 4] [bs bp bp];
    [7 3; 5 1; 6 4; 6 2] [b  br b  b ];
    [3 1; 4 2] [rs rp];
    [3 1; 4 2] [b  rr];
    [7 1; 6 2] [bs bp];
    [7 1; 6 2] [b  br];
    [4 2; 5 3] [rs rp];
    [4 2; 5 3] [b  rr];
    [8 2; 7 1; 7 3] [bs bp bp];
    [8 2; 7 1; 7 3] [b  b  br];
    [5 3; 7 1; 6 4] [rs rp rp];
    [5 3; 7 1; 6 4; 6 2] [b  rr b  b ];
    [5 1; 4 2] [bs bp];
    [5 1; 4 2] [b  br];
    [7 1; 8 2] [rs rp];
    [7 1; 8 2] [b  rk];
    [4 2; 3 1; 3 3] [bs bp bp];
    [4 2; 3 1; 3 3] [b  br b ];
    [1 3; 2 2] [rs rp];
    [1 3; 2 2] [b  rr];
    [3 1; 1 3] [bs bp];
    [3 1; 1 3; 2 2] [b  bk b ];
    [8 2; 6 4] [rS rp];
    [8 2; 6 4; 7 3] [b  rk b ];
};

drawScene(game, boardDisplay);
hold on

for i = 1:size(changes, 1) % size(changes, 1) give the number of rows in 'changes'

    pause(delay)

    nextChange = changes(i, :);

    coords           = nextChange{1};
    newSpriteIndices = nextChange{2};

    for j = 1:size(coords, 1)
        row          = coords(j, 1);
        col          = coords(j, 2);
        newSpriteIdx = newSpriteIndices(j);

        boardDisplay(row, col) = newSpriteIdx;
    end

    drawScene(game, boardDisplay);

end

clc
clear
close all

background_rgb = [255 255 255]; % This doesn't really matter
zoom_factor = 3;

%game = simpleGameEngine('checkers_Sprites.png', 32, 32, zoom_factor, background_rgb);
game = simpleGameEngine('Checkers_Sprites_Temp.png', 32, 32, zoom_factor, background_rgb);

bt = 1;
rt = 2;

br = 3;
rr = 4;

bk = 5; 
rk = 6;

bs = 7;
rs = 8;

bS = 9;
rS = 10;

bp = 11;
rp = 12;

board = [
    rr rt rr rt rr rt rr rt;
    rt rr rt rr rt rr rt rr;
    rr rt rr rt rr rt rr rt;
    rt bt rt bt rt bt rt bt;
    bt rt bt rt bt rt bt rt;
    rt br rt br rt br rt br;
    br rt br rt br rt br rt;
    rt br rt br rt br rt br;
];

board2disp = [13 14 1 2 3 4 5 6 11 12 7 8];

%%%%%
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

display = [top; left, board2disp(board), right; bottom];

% Variable initialization before loop
black_turn = true;
previous_row = 0;
previous_col = 0;
piece_selected = false;
next_positions = [];
is_black = true;
is_king = true;

while true
    
    %drawScene(game, board2disp(board))
    display(2:9, 2:9) = board2disp(board);
    display(5, 11) = red - black_turn;
    drawScene(game, display)
    
    % Get mouse input
    [selected_row, selected_col] = getMouseInput(game);
    selected_row = selected_row - 1;
    selected_col = selected_col - 1;
    if selected_row == previous_row && selected_col == previous_col
        continue % Go back to the top of the loop
    elseif piece_selected
        move_made = false;
        for i = 1:size(next_positions, 1)
            row = next_positions(i, 1);
            col = next_positions(i, 2);
            if row == selected_row && col == selected_col
                if (is_black && row == 1) || (~is_black == row == 8)
                    board(row, col) = rk - is_black;
                else
                    board(row, col) = rr - is_black;
                end
                if abs(row - previous_row) == 2
                    board(mean([row, previous_row]), mean([col, previous_col])) = bt;
                end
                move_made = true;
            else
                board(row, col) = bt;
            end
        end
        if move_made
            board(previous_row, previous_col) = bt;
            black_turn = ~black_turn;
            previous_row = selected_row;
            previous_col = selected_col;
            next_positions = [];
            piece_selected = false;
            continue
        else
            if is_king
                board(previous_row, previous_col) = rr - is_black;
            else
                board(previous_row, previous_col) = rk - is_black;
            end
        end
    end
    
    if withinBoard(selected_row, selected_col)
        selected = board(selected_row, selected_col);
    else
        selected = -1;
    end
    
    if (selected ~= rr - black_turn) && (selected ~= rk - black_turn)
        previous_row = selected_row;
        previous_col = selected_col;
        next_positions = [];
        piece_selected = false;
        continue % Go back to the top of the loop
    else
        piece_selected = true;
    end
    
    % ---Only new, valid piece clicks are processed after here---

    % Selection info
    is_black = (selected == br);
    is_king = (selected == bk) || (selected == rk);

    % Possible moves (next positions)
    next_positions = zeros(4, 2);
    idx = 0;
    for row_dir = [-1, 1]
        if is_king || (is_black && row_dir == -1) || (~is_black && row_dir == 1)
            for col_dir = [-1, 1]
                row = selected_row + row_dir;
                col = selected_col + col_dir;
                if withinBoard(row, col)
                    if board(row, col) == bt
                        idx = idx + 1;
                        next_positions(idx, :) = [row, col];
                    elseif (is_black && board(row, col) == rr) || (is_black && board(row, col) == rk) || (~is_black && board(row, col) == br) || (~is_black && board(row, col) == br)
                        row = row + row_dir;
                        col = col + col_dir;
                        if withinBoard(row, col) && board(row, col) == bt
                            idx = idx + 1;
                            next_positions(idx, :) = [row, col];
                        end
                    end
                end
            end
        end
    end
    next_positions = next_positions(1:idx, :);

    if is_king
        board(selected_row, selected_col) = rS - is_black;
    else
        board(selected_row, selected_col) = rs - is_black;
    end
    
    if ~isempty(next_positions)
        for i = 1:size(next_positions, 1)
            row = next_positions(i, 1);
            col = next_positions(i, 2);
            board(row, col) = rp - is_black;
        end
    end
    
    previous_row = selected_row;
    previous_col = selected_col;
end

clc
clear
close all

background_rgb = [255 255 255]; % This doesn't really matter
zoom_factor = 3;

%game = simpleGameEngine('checkers_Sprites.png', 32, 32, zoom_factor, background_rgb);
game = simpleGameEngine('Checkers_Sprites_Three_Pieces.png', 32, 32, zoom_factor, background_rgb);

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
rcap1 = 30;
rcap2 = 30;
rcap3 = 30;
rcap4 = 30;
bcap1 = 30;
bcap2 = 30;
bcap3 = 30;
bcap4 = 30;

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
    er  bcap1    bcap2;
    er  bcap3    bcap4;
    er  w      w;
    er  black  w;
    er  w      w;
    er  w      w;
    er  rcap1    rcap2;
    er  rcap3    rcap4;
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

n_blacks = 12;
n_reds = 12;

while true
    
    %drawScene(game, board2disp(board))

    display(2:9, 2:9) = board2disp(board);
    display(5, 11) = red - black_turn;
    if n_reds == 11
        bcap1 = 33;
    elseif n_reds == 10
        bcap1 = 32;
    elseif n_reds == 9
        bcap1 = 31;
    elseif n_reds == 8 
        bcap2 = 33;
    elseif n_reds == 7 
        bcap2 = 32;
    elseif n_reds == 6
        bcap2 = 31;
    elseif n_reds == 5
        bcap3 = 33;
    elseif n_reds == 4 
        bcap3 = 32;
    elseif n_reds == 3 
        bcap3 = 31;
    elseif n_reds == 2 
        bcap4 = 33;
    elseif n_reds == 1
        bcap4 = 32;
    end
    if n_blacks == 11
        rcap1 = 36;
    elseif n_blacks == 10
        rcap1 = 35;
    elseif n_blacks == 9
        rcap1 = 34;
    elseif n_blacks == 8 
        rcap2 = 36;
    elseif n_blacks == 7 
        rcap2 = 35;
    elseif n_blacks == 6
        rcap2 = 34;
    elseif n_blacks == 5
        rcap3 = 36;
    elseif n_blacks == 4 
        rcap3 = 35;
    elseif n_blacks == 3 
        rcap3 = 34;
    elseif n_blacks == 2 
        rcap4 = 36;
    elseif n_blacks == 1
        rcap4 = 35;
    end
    display(2,11) = bcap1;
    display(2,12) = bcap2;
    display(9,11) = rcap1;
    display(9,12) = rcap2;
    drawScene(game, display)
    if n_reds == 0
        drawScene(game, [19,15,16;13,14,13;14,13,14;20,17,18])
        break
    elseif n_blacks == 0
        drawScene(game, [20,15,16;13,14,13;14,13,14;19,17,18])
        break
    end
    
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
                if is_king || (is_black && row == 1) || (~is_black && row == 8)
                    board(row, col) = rk - is_black;
                else
                    board(row, col) = rr - is_black;
                end
                if abs(row - previous_row) == 2
                    board(mean([row, previous_row]), mean([col, previous_col])) = bt;
                    if is_black
                        n_reds = n_reds - 1;
                    else
                        n_blacks = n_blacks - 1;
                    end
                    
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
                board(previous_row, previous_col) = rk - is_black;
            else
                board(previous_row, previous_col) = rr - is_black;
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
    is_black = (selected == br) || (selected == bk);
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
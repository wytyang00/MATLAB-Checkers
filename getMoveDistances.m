function [moveDist] = getMoveDistances(empty, blackKing, black, redKing, red)
    % `empty, `blackKing`, `black`, `redKing`, and `red` are all 8 by 8 boolean matrices.

    % `moveDist` is a 3D array with the first 2 dimensions representing
    % corresponding positions on the board and the last dimension
    % representing how far the piece can move in each of 4 directions
    % [Up-Left, Up-Right, Down-Left, Down-Right].
    
    moveDist = zeros(8, 8, 4);
    blackOrRedKing = (black | redKing);
    redOrBlackKing = (red | blackKing);
    
    % Pre-allocating shared indices
    f  = 1:7;
    fs = 1:6;
    l  = 2:8;
    ls = 3:8;
    
    middleBlack = black(2:7, 2:7);
    middleRed   = red(2:7, 2:7);

    % Upper-Left Move
    moveDist(l, l, 1) = blackOrRedKing(l, l) & empty(f, f);
    % Upper-Left Capture
    moveDist(ls, ls, 1) = moveDist(ls, ls, 1) + 2 * (((black(ls, ls) & middleRed) | (redKing(ls, ls) & middleBlack)) & empty(fs, fs));

    % Upper-Right Move
    moveDist(l, f, 2) = blackOrRedKing(l, f) & empty(f, l);
    % Upper-Right Capture
    moveDist(ls, fs, 2) = moveDist(ls, fs, 2) + 2 * (((black(ls, fs) & middleRed) | (redKing(ls, fs) & middleBlack)) & empty(fs, ls));

    % Lower-Left Move
    moveDist(f, l, 3) = redOrBlackKing(f, l) & empty(l, f);
    % Lower-Left Capture
    moveDist(fs, ls, 3) = moveDist(fs, ls, 3) + 2 * (((red(fs, ls) & middleBlack) | (blackKing(fs, ls) & middleRed)) & empty(ls, fs));

    % Lower-Right Move
    moveDist(f, f, 4) = redOrBlackKing(f, f) & empty(l, l);
    % Lower-Right Capture
    moveDist(fs, fs, 4) = moveDist(fs, fs, 4) + 2 * (((red(fs, fs) & middleBlack) | (blackKing(fs, fs) & middleRed)) & empty(ls, ls));
    
end
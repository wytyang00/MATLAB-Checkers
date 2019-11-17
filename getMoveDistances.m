function [moveDist] = getMoveDistances(empty, blackKing, black, redKing, red)
    % `empty, `blackKing`, `black`, `redKing`, and `red` are all 8 by 8 boolean matrices.

    % `moveDist` is a 3D array with the first 2 dimensions representing
    % corresponding positions on the board and the last dimension
    % representing how far the piece can move in each of 4 directions
    % [Up-Left, Up-Right, Down-Left, Down-Right].
    
    %%
%     moveDist = zeros(8, 8, 4);

%     upLeft = zeros(8, 8);
%     upLeft(2:8, 2:8) = (black(2:8, 2:8) | redKing(2:8, 2:8)) & empty(1:7, 1:7);
%     upLeft(3:8, 3:8) = upLeft(3:8, 3:8) + 2 * (((black(3:8, 3:8) & red(2:7, 2:7)) | (redKing(3:8, 3:8) & black(2:7, 2:7))) & empty(1:6, 1:6));
%     
%     upRight = zeros(8, 8);
%     upRight(2:8, 1:7) = (black(2:8, 1:7) | redKing(2:8, 1:7)) & empty(1:7, 2:8);
%     upRight(3:8, 1:6) = upRight(3:8, 1:6) + 2 * (((black(3:8, 1:6) & red(2:7, 2:7)) | (redKing(3:8, 1:6) & black(2:7, 2:7))) & empty(1:6, 3:8));
%     
%     downLeft = zeros(8, 8);
%     downLeft(1:7, 2:8) = (red(1:7, 2:8) | blackKing(1:7, 2:8)) & empty(2:8, 1:7);
%     downLeft(1:6, 3:8) = downLeft(1:6, 3:8) + 2 * (((red(1:6, 3:8) & black(2:7, 2:7)) | (blackKing(1:6, 3:8) & red(2:7, 2:7))) & empty(3:8, 1:6));
%     
%     downRight = zeros(8, 8);
%     downRight(1:7, 1:7) = (red(1:7, 1:7) | blackKing(1:7, 1:7)) & empty(2:8, 2:8);
%     downRight(1:6, 1:6) = downRight(1:6, 1:6) + 2 * (((red(1:6, 1:6) & black(2:7, 2:7)) | (blackKing(1:6, 1:6) & red(2:7, 2:7))) & empty(3:8, 3:8));
%     
%     moveDist(:, :, 1) = upLeft;
%     moveDist(:, :, 2) = upRight;
%     moveDist(:, :, 3) = downLeft;
%     moveDist(:, :, 4) = downRight;
    %%
    moveDist = zeros(8, 8, 4);
    blackOrRedKing = (black | redKing);
    redOrBlackKing = (red | blackKing);

    moveDist(2:8, 2:8, 1) = blackOrRedKing(2:8, 2:8) & empty(1:7, 1:7);
    moveDist(3:8, 3:8, 1) = moveDist(3:8, 3:8, 1) + 2 * (((black(3:8, 3:8) & red(2:7, 2:7)) | (redKing(3:8, 3:8) & black(2:7, 2:7))) & empty(1:6, 1:6));

    moveDist(2:8, 1:7, 2) = blackOrRedKing(2:8, 1:7) & empty(1:7, 2:8);
    moveDist(3:8, 1:6, 2) = moveDist(3:8, 1:6, 2) + 2 * (((black(3:8, 1:6) & red(2:7, 2:7)) | (redKing(3:8, 1:6) & black(2:7, 2:7))) & empty(1:6, 3:8));

    moveDist(1:7, 2:8, 3) = redOrBlackKing(1:7, 2:8) & empty(2:8, 1:7);
    moveDist(1:6, 3:8, 3) = moveDist(1:6, 3:8, 3) + 2 * (((red(1:6, 3:8) & black(2:7, 2:7)) | (blackKing(1:6, 3:8) & red(2:7, 2:7))) & empty(3:8, 1:6));

    moveDist(1:7, 1:7, 4) = redOrBlackKing(1:7, 1:7) & empty(2:8, 2:8);
    moveDist(1:6, 1:6, 4) = moveDist(1:6, 1:6, 4) + 2 * (((red(1:6, 1:6) & black(2:7, 2:7)) | (blackKing(1:6, 1:6) & red(2:7, 2:7))) & empty(3:8, 3:8));
    
end
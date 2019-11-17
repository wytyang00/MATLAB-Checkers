%% Initialization (Preparation)
% Clean up everything and close all figures if there's any.
clc
clear
close all

% Initialize the game engine.
scaleFactor = 3;
bgColor = [255, 255, 255]; % Background color RGB values (0-255)

game = simpleGameEngine('checkers_Sprites_Three_Pieces.png', 32, 32, scaleFactor, bgColor);

% Assign values to pieces and tiles.
bt = 1; rt = 2;   % Black empty Tile;            Red empty Tile
bn = 3; rn = 4;   % Black Normal piece;          Red Normal piece
bk = 5; rk = 6;   % Black King piece;            Red King piece
bs = 7; rs = 8;   % Black normal Selected piece; Red normal Selected piece
bS = 9; rS = 10;  % Black king Selected piece;   Red king Selected piece
bp = 11; rp = 12; % Black Possible position;     Red Possible position

% Create an array for converting board values above into sprite indices for
% display. (e.g. board2disp(bt) == board2disp(1) == 13)
board2disp = [13, 14, 1, 2, 3, 4, 5, 6, 11, 12, 7, 8];

% Additional display elements:
% board edges and corners, white margins, turn indicator, etc.
bw = 9;  % Black normal piece on White background sprite index
rw = 10; % Red normal piece on White background sprite index

wt = 30; % White Tile sprite index
te = 23; % board Top Edge sprite index
le = 25; % board Left Edge sprite index
re = 26; % board Right Edge sprite index
be = 28; % board Bottom Edge sprite index
ul = 22; % board Upper Left corner sprite index
ur = 24; % board Upper Right corner sprite index
ll = 27; % board Lower Left corner sprite index
lr = 29; % board Lower Right corner sprite index

% Capture count indicator sprite indices
oneBlackPiece = 33;
twoBlackPiece = 32;
thrBlackPiece = 31;
blackPieces = [oneBlackPiece, twoBlackPiece];
oneRedPiece   = 36;
twoRedPiece   = 35;
thrRedPiece   = 34;
redPieces   = [oneRedPiece,   twoRedPiece];

top    = [ul te te te te te te te te ur wt wt];
left   = [le;
          le;
          le;
          le;
          le;
          le;
          le;
          le];
right  = [re wt wt;
          re wt wt;
          re wt wt;
          re bk wt;
          re wt wt;
          re wt wt;
          re wt wt;
          re wt wt;];
bottom = [ll be be be be be be be be lr wt wt];

% Initialize the board.
board = [rn rt rn rt rn rt rn rt;
         rt rn rt rn rt rn rt rn;
         rn rt rn rt rn rt rn rt;
         rt bt rt bt rt bt rt bt;
         bt rt bt rt bt rt bt rt;
         rt bn rt bn rt bn rt bn;
         bn rt bn rt bn rt bn rt;
         rt bn rt bn rt bn rt bn;];

% Initialize the board display matrix (matrix of sprite indices)
boardDisplay = [             top;
                left, board2disp(board), right;
                            bottom             ];

% Initialize some variables before the main game loop.
% Some of the values here are arbitrary as they will be assigned new values
% before being used.
againstCpu = true; % TODO: This should be something the player can choose.
blackTurn = true; % Whether it is black's turn or not (TODO: try random)
cpuTurn = true;

featureWeights = [1, 2, 0.9, 1.8, -0.2, -0.4, 0.5, 0.2]; % Feature weights used for board evaluation for AI
depth = 6; % Minimax tree search depth for AI (deeper depth requires longer time)
tolerance = 0; % Tolerance value for alpha-beta window in alphabeta algorithm (higher tolerance costs more time)

empty       = (board == bt) | (board == rt); % Empty tiles are 1 and non-empty tiles are 0
blackNormal = (board == bn);                 % Normal black pieces are 1 and others are 0
blackKing   = (board == bk);                 % King black pieces are 1 and others are 0
black       = (blackNormal | blackKing);     % All black pieces are 1 and others are 0
redNormal   = (board == rn);                 % Normal red pieces are 1 and others are 0
redKing     = (board == rk);                 % King red pieces are 1 and others are 0
red         = (redNormal | redKing);         % All red pieces are 1 and others are 0

moveDistances = getMoveDistances(empty, blackKing, black, redKing, red); % Possible travel distances in each of 4 directions for all pieces on the board

moveDirections = [-1 -1;
                  -1  1;
                   1 -1;
                   1  1 ];

clickRow = 0; % Currently clicked row
clickCol = 0; % Currently clicked column
prevRow = 0; % Previously clicked row
prevCol = 0; % Previously clicked column
pcSelected = false; % Whether there was a selected piece before the current click or not
isKing = false; % Whether the selected piece is a king or not
posPos = []; % Array of possible positions if the selected piece can make a move

numBlkCaptured = 0; % Number of Black pieces Captured
numRedCaptured = 0; % Number of Red pieces Captured

%% Main Game Loop
while true
    
    %% Update Display
    % Update the board part of the display
    boardDisplay(2:9, 2:9) = board2disp(board);

    % Update the turn indicator
    if blackTurn
        boardDisplay(5, 11) = bw;
    else
        boardDisplay(5, 11) = rw;
    end
    
    % Update capture count display
    blackCaptures = [wt, wt; wt, wt];
    quotient  = floor(numBlkCaptured / 3);
    blackCaptures(1:quotient) = thrBlackPiece;
    remainder = mod(numBlkCaptured, 3);
    if remainder
        blackCaptures(quotient+1) = blackPieces(remainder);
    end
    
    redCaptures   = [wt, wt; wt, wt];
    quotient  = floor(numRedCaptured / 3);
    redCaptures(1:quotient) = thrRedPiece;
    remainder = mod(numRedCaptured, 3);
    if remainder
        redCaptures(quotient+1) = redPieces(remainder);
    end
    
    boardDisplay(2:3, 11:12) = blackCaptures;
    boardDisplay(8:9, 11:12) = redCaptures;
    
    % Display/Update the board
    drawScene(game, boardDisplay)
    
    %% Terminal State Check (Win/Draw)
    % If the current player cannot make a move, that player loses the game.
    if blackTurn && ~any(black & moveDistances, 'all')
        blackWin = false;
        break
    elseif ~blackTurn && ~any(red & moveDistances, 'all')
        blackWin = true;
        break
    end
    
    %% CPU Play
    if cpuTurn
        pause(0.1)
        [v, rowColMove] = checkersAlphabeta(board, bt, rt, bn, rn, bk, rk, ...
                                            empty, blackNormal, blackKing, black, ...
                                            redNormal, redKing, red, moveDistances, blackTurn, ...
                                            depth, -inf, inf, tolerance, true, featureWeights);
        
        row = rowColMove(1); % Row location for the piece to move
        col = rowColMove(2); % Column location for the piece to move
        pieceVal = board(row, col); % Value of the piece to move
        distances = moveDistances(row, col, :); % Available move distances for the piece to move in each direction
        distance = distances(rowColMove(3)); % Number of tiles to move
        direction = moveDirections(rowColMove(3), :); % [rowDirection, colDirection]
        displacement = direction * distance; % Changes in row and column location
        newRow = row + displacement(1); % New row location of the piece after the move
        newCol = col + displacement(2); % New column location of the piece after the move
        
        % Make appropriate changes to the board according to the move
        if blackTurn && newRow == 1
            board(newRow, newCol) = bk;
        elseif ~blackTurn && newRow == 8
            board(newRow, newCol) = rk;
        else
            board(newRow, newCol) = board(row, col);
        end
        
        board(row, col) = bt;
        
        if distance == 2
            board(row+direction(1), col+direction(2)) = bt;
            if blackTurn
                numRedCaptured = numRedCaptured + 1;
            else
                numBlkCaptured = numBlkCaptured + 1;
            end
        end
        
        % Instead of showing the move instantly, make it noticeable by first
        % showing the piece selection and then the actual move (with a
        % short pause between them)
        if pieceVal == bn
            boardDisplay(1+row, 1+col) = board2disp(bs);
        elseif pieceVal == bk
            boardDisplay(1+row, 1+col) = board2disp(bS);
        elseif pieceVal == rn
            boardDisplay(1+row, 1+col) = board2disp(rs);
        else
            boardDisplay(1+row, 1+col) = board2disp(rS);
        end
        for i = 1:4
            distance = distances(i);
            if distance > 0
                displacement = moveDirections(i, :) * distance;
                if blackTurn
                    boardDisplay(1+row+displacement(1), 1+col+displacement(2)) = board2disp(bp);
                else
                    boardDisplay(1+row+displacement(1), 1+col+displacement(2)) = board2disp(rp);
                end
            end
        end
        drawScene(game, boardDisplay)
        
        pause(1)
        
        % Switch turn
        blackTurn = ~blackTurn;
        cpuTurn = ~cpuTurn;
        % Reset some variables to prepare for the next user input
        clickRow = 0;
        clickCol = 0;
        prevRow = 0;
        prevCol = 0;
        posPos = [];
        pcSelected = false;
        % Recalculate the new board states and possible moves
        empty       = (board == bt) | (board == rt);
        blackNormal = (board == bn);
        blackKing   = (board == bk);
        black       = (blackNormal | blackKing);
        redNormal   = (board == rn);
        redKing     = (board == rk);
        red         = (redNormal | redKing);
        moveDistances = getMoveDistances(empty, blackKing, black, redKing, red);
        % Go back to the top of the loop
        continue
    else
    %% User Input
        % Get a "meaningful" mouse click from the player
        % That is, get a click that is different from the previous click.
        while clickRow == prevRow && clickCol == prevCol
            % Get a mouse click input from the player
            [clickRow, clickCol] = getMouseInput(game);
            % Adjust the row and column values according to the margins at the top
            % and the left of the board
            clickRow = clickRow - 1;
            clickCol = clickCol - 1;
        end

        % !!! The following situations are NOT mutually exclusive; they may occur together !!!
        %% Situation: There was a previously selected piece
        % ---Possible Outcome---
        % 1. Makes a move
        % 2. De-select the selected piece by clicking somewhere else 

        % If the previous click selected a piece (which means that the player
        % might be making a move with the current click)
        if pcSelected
            mvMade = false; % Flag variable indicating whether a move was made in the following for-loop

            % Loop through the available moves for the selected piece
            % (This array of moves can be empty if the selected piece cannot move)
            for i = 1:size(posPos, 1)
                row = posPos(i, 1); % Row component of the i'th possible move
                col = posPos(i, 2); % Column component of the i'th possible move

                % If the player clicked this position, the player is making a move.
                if row == clickRow && col == clickCol
                    % A move is made.
                    mvMade = true;

                    % If the selected piece is a king or the piece has reached
                    % the end row, place a corresponding king piece there.
                    if isKing || (blackTurn && row == 1) || (~blackTurn && row == 8)
                        if blackTurn
                            board(row, col) = bk;
                        else
                            board(row, col) = rk;
                        end
                    % Otherwise, it's a normal piece.
                    else
                        if blackTurn
                            board(row, col) = bn;
                        else
                            board(row, col) = rn;
                        end
                    end

                    % If the piece more than 2 blocks, it has jumped over an
                    % opponent's piece.
                    if abs(row - prevRow) == 2
                        % Take the captured piece out by replacing its position
                        % with an empty black tile.
                        board(mean([row, prevRow]), mean([col, prevCol])) = bt;
                        % Adjust the number of remaining pieces accordingly.
                        if blackTurn
                            numRedCaptured = numRedCaptured + 1;
                        else
                            numBlkCaptured = numBlkCaptured + 1;
                        end
                    end
                % If the player did not click this position, remove the
                % possible move indication. (Replace it with an empty black tile.)
                else
                    board(row, col) = bt;
                end
            end
            % If a move was made, there are several things to do.
            if mvMade
                % Replace the selected piece's original position with an empty black tile
                board(prevRow, prevCol) = bt;
                % Switch turn
                blackTurn = ~blackTurn;
                if againstCpu
                    cpuTurn = ~cpuTurn;
                end
                % Reset some variables to prepare for the next input
                clickRow = 0;
                clickCol = 0;
                prevRow = 0;
                prevCol = 0;
                posPos = [];
                pcSelected = false;
                % Recalculate the new board states and possible moves
                empty       = (board == bt) | (board == rt);
                blackNormal = (board == bn);
                blackKing   = (board == bk);
                black       = (blackNormal | blackKing);
                redNormal   = (board == rn);
                redKing     = (board == rk);
                red         = (redNormal | redKing);
                moveDistances = getMoveDistances(empty, blackKing, black, redKing, red);
                % Go back to the top of the loop
                continue
            % If no move was made, revert the 'selected' piece back to its
            % original 'unselected' state.
            else
                if isKing
                    if blackTurn
                        board(prevRow, prevCol) = bk;
                    else
                        board(prevRow, prevCol) = rk;
                    end
                else
                    if blackTurn
                        board(prevRow, prevCol) = bn;
                    else
                        board(prevRow, prevCol) = rn;
                    end
                end
            end
        end

        %% Situation: No move was made with the current click
        % ---Possible Outcome---
        % 1. Select a piece (not opponent's piece)
        % 2. Nothing happens

        % Get the value of the clicked position. If the position is not on the
        % board, assign it with -1.
        if withinBoard(clickRow, clickCol)
            clickVal = board(clickRow, clickCol);
        else
            clickVal = -1;
        end

        % If the player has not clicked their own piece, nothing happens.
        if (blackTurn && clickVal ~= bn && clickVal ~= bk)...
                || (~blackTurn && clickVal ~= rn && clickVal ~= rk)
            prevRow = clickRow;
            prevCol = clickCol;
            posPos = [];
            pcSelected = false;
            % Go back to the top of the loop
            continue
        % Otherwise, the player did click a valid piece.
        else
            pcSelected = true;
            isKing = (clickVal == bk) || (clickVal == rk); % Whether the clicked piece is a king piece or not
            % "Select" the selected piece.
            if isKing
                if blackTurn
                    board(clickRow, clickCol) = bS;
                else
                    board(clickRow, clickCol) = rS;
                end
            else
                if blackTurn
                    board(clickRow, clickCol) = bs;
                else
                    board(clickRow, clickCol) = rs;
                end
            end
        end

        %% Valid Piece Processing (Find possible next positions)

        posDistances = reshape(moveDistances(clickRow, clickCol, :), [], 1); % Possible travel distances in each of 4 directions
        posDirectionIdx = find(posDistances); % Indices for directions the selected piece can travel

        if isempty(posDirectionIdx)
            posPos = [];
        else
            posDisplacements = moveDirections(posDirectionIdx, :) .* posDistances(posDirectionIdx); % [Row, Column] displacements
            posPos = [clickRow clickCol] + posDisplacements;
        end

        % If any possible move is found, mark those possible positions
        if ~isempty(posPos)
            for i = 1:size(posPos, 1)
                row = posPos(i, 1);
                col = posPos(i, 2);
                if blackTurn
                    board(row, col) = bp;
                else
                    board(row, col) = rp;
                end
            end
        end

        % Current click now becomes the previous click for the next loop.
        prevRow = clickRow;
        prevCol = clickCol;
    end
end

%% Winner & Loser Display

win  = [15, 16]; % Win sprite indices
lose = [17, 18]; % Lose sprite indices
if blackWin
    if againstCpu
        if cpuTurn == blackTurn
            winner = [9, 21]; % Winner color and name sprite indices
            loser  = [10, 19]; % Loser color and name sprite indices
        else
            winner = [9, 19];
            loser  = [10, 21];
        end
    else
        winner = [9, 19];
        loser  = [10, 20];
    end
else
    if againstCpu
        if cpuTurn == blackTurn
            winner = [10, 19];
            loser = [9, 21];
        else
            winner = [10, 21];
            loser = [9, 19];
        end
    else
        winner = [10, 20];
        loser  = [9, 19];
    end
end

% Convert black & white tile values into corresponding sprite indices
bt = board2disp(bt);
rt = board2disp(rt);

winDisplay = [bt, rt, bt, rt, bt, rt;
              rt, winner, win,    bt;
              bt, rt, bt, rt, bt, rt;
              rt, loser,  lose,   bt;
              bt, rt, bt, rt, bt, rt ];
          
% Display winner & loser after 1 second pause
pause(1)
drawScene(game, winDisplay)

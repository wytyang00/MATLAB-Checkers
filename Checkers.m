%% Initialization (Preparation)
% Clean up everything and close all figures if there's any.
clc
clear
close all

% Initialize the game engine.
scaleFactor = 3;
bgColor = [255, 255, 255]; % Background color RGB values (0-255)

game = simpleGameEngine('checkers_Sprites_Temp.png', 32, 32, scaleFactor, bgColor);

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
blackTurn = true; % Whether it is black's turn or not (TODO: try random)

clickRow = 0; % Currently clicked row
clickCol = 0; % Currently clicked column
prevRow = 0; % Previously clicked row
prevCol = 0; % Previously clicked column
pcSelected = false; % Whether there was a selected piece before the current click or not
isKing = false; % Whether the selected piece is a king or not
posPos = []; % Array of possible positions if the selected piece can make a move

numBlk = 12; % Number of Black pieces on the board
numRed = 12; % Number of Red pieces on the board

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
    
    % Display/Update the board
    drawScene(game, boardDisplay)
    
    %% Terminal State Check (Win/Draw)
    % TEMPORARY: check win state and break out of the loop
    if numBlk == 0
        fprintf('Red Win!\n')
        break
    elseif numRed == 0
        fprintf('Black Win!\n')
        break
    end
    
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
                        numRed = numRed - 1;
                    else
                        numBlk = numBlk - 1;
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
            % Reset some variables to prepare for the next input
            clickRow = 0;
            clickCol = 0;
            prevRow = 0;
            prevCol = 0;
            posPos = [];
            pcSelected = false;
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
    posPos = zeros(4, 2); % There are at most 4 possible next position [row, column] pairs.
    idx = 0; % This is used below to index posPos and count the number of possible moves.
    
    % For each row direction [-1(up), +1(down)]
    for rowDir = [-1, 1]
        % Check only if this direction is valid for the selected piece
        if isKing || (blackTurn && rowDir == -1) || (~blackTurn && rowDir == 1)
            % For each column direction [-1(left), +1(right)]
            for colDir = [-1, 1]
                row = clickRow + rowDir;
                col = clickCol + colDir;
                % Check only if this position is on the board
                if withinBoard(row, col)
                    % If this position is empty, this is indeed a possible position.
                    if board(row, col) == bt
                        idx = idx + 1;
                        posPos(idx, :) = [row, col];
                    % If this position is obstructed by an opponent's piece, check one tile further.
                    elseif (blackTurn && (board(row, col) == rn || board(row, col) == rk))...
                            || (~blackTurn && (board(row, col) == bn || board(row, col) == bk))
                        row = row + rowDir;
                        col = col + colDir;
                        % If this position is empty, the selected piece can
                        % jump over the opponent's piece and get here.
                        if withinBoard(row, col) && board(row, col) == bt
                            idx = idx + 1;
                            posPos(idx, :) = [row, col];
                        end
                    end
                end
            end
        end
    end
    % Take only the discovered moves.
    posPos = posPos(1:idx, :);
    
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

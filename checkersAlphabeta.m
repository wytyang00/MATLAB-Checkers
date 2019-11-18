% Alphabeta algorithm based on the pseudocode from Wikipedia
% (https://en.wikipedia.org/wiki/Alpha%E2%80%93beta_pruning)
function [value, rowColMove] = checkersAlphabeta(board, bt, rt, bn, rn, bk, rk, ...
                                                empty, blackNormal, blackKing, black, ...
                                                redNormal, redKing, red, moveDistances, blackTurn, ...
                                                depth, alpha, beta, tolerance, maximize, featureWeights)%, transposTable, transposDepths)
    rowColMove = [];
    if blackTurn && ~any(black & moveDistances, 'all')
        if maximize
            value = -inf;
        else
            value = inf;
        end
    elseif ~blackTurn && ~any(red & moveDistances, 'all')
        if maximize
            value = -inf;
        else
            value = inf;
        end
    elseif depth == 0
        value = evaluateBoard(empty, blackNormal, blackKing, black, ...
                              redNormal, redKing, red, moveDistances, blackTurn == maximize, featureWeights);
    else
        if blackTurn
            moveDistances = moveDistances & black;
        else
            moveDistances = moveDistances & red;
        end
        [rows, cols, distances] = find(moveDistances);
        directions = [-1 -1; -1 1; 1 -1; 1 1];
        directionIdx = ceil(cols ./ 8);
        cols = mod(cols - 1, 8) + 1;
        
        if maximize
            value = -inf;
        else
            value = inf;
        end
        for i = 1:length(rows)
            row = rows(i);
            col = cols(i);
            distance = distances(i);
            displacement = directions(directionIdx(i), :);
            newRow = row + distance * displacement(1);
            newCol = col + distance * displacement(2);
            
            newBoard = board;
            if blackTurn && newRow == 1
                newBoard(newRow, newCol) = bk;
            elseif ~blackTurn && newRow == 8
                newBoard(newRow, newCol) = rk;
            else
                newBoard(newRow, newCol) = newBoard(row, col);
            end
            newBoard(row, col) = bt;
            if distance == 2
                newBoard(row + displacement(1), col + displacement(2)) = bt;
            end
            
            empty       = (newBoard == bt) | (newBoard == rt);
            blackNormal = (newBoard == bn);
            blackKing   = (newBoard == bk);
            black       = (blackNormal | blackKing);
            redNormal   = (newBoard == rn);
            redKing     = (newBoard == rk);
            red         = (redNormal | redKing);
            newMoveDistances = getMoveDistances(empty, blackKing, black, redKing, red);
            
            alphabetaValue = checkersAlphabeta(newBoard, bt, rt, bn, rn, bk, rk, ...
                                               empty, blackNormal, blackKing, black, ...
                                               redNormal, redKing, red, newMoveDistances, ~blackTurn, ...
                                               depth-1, alpha, beta, tolerance, ~maximize, featureWeights);
            if maximize
                if (alphabetaValue > value) || (alphabetaValue == value && (randi([0, 1]) || isempty(rowColMove)))
                    value = alphabetaValue;
                    rowColMove = [row, col, directionIdx(i)];
                end
                alpha = max(alpha, value);
            else
                if (alphabetaValue < value) || (alphabetaValue == value && (randi([0, 1]) || isempty(rowColMove)))
                    value = alphabetaValue;
                    rowColMove = [row, col, directionIdx(i)];
                end
                beta = min(beta, value);
            end
            
            if alpha - beta >= tolerance
                break
            end
            
        end
    end
end

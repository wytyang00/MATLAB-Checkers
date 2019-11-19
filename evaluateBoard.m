% Features below are based on the analysis done by Kebin Gregor and Marcus
% Boeck-Chenevier.
% (https://github.com/kevingregor/Checkers/blob/master/Final%20Project%20Report.pdf)
function [heuristicBoardValue] = evaluateBoard(empty, blackNormal, blackKing, black, redNormal, redKing, red, moveDistances, maximizingBlack, blackTurn, weights)
    
    captureMoves = (moveDistances == 2);
    
    middleBlack = black(2:7, 2:7);
    middleRed   = red(2:7, 2:7);

    captureRisk = (captureMoves(3:8, 3:8, 1) | captureMoves(3:8, 1:6, 2) | captureMoves(1:6, 3:8, 3) | captureMoves(1:6, 1:6, 4));
    
    numBlackNormal = sum(blackNormal, 'all');
    numBlackKing = sum(blackKing, 'all');
    numBlackInBackRow = sum(black(8, :), 'all');
    numBlackInMiddle2by4 = sum(black(4:5, 3:6), 'all');
    numBlackInMiddle2Sides = sum(black(4:5, [1 2 7 8]), 'all');
    numBlackRisk = sum(middleBlack & captureRisk, 'all');
    numBlackProtected = sum(black(1:8, [1 8]), 'all') + sum(black([1 8], 2:7), 'all') + sum(middleBlack & (black(1:6, 1:6) | black(3:8, 3:8)) & (black(1:6, 3:8) | black(3:8, 1:6)), 'all');
    
    numRedNormal = sum(redNormal, 'all');
    numRedKing = sum(redKing, 'all');
    numRedInBackRow = sum(red(1, :), 'all');
    numRedInMiddle2by4 = sum(red(4:5, 3:6), 'all');
    numRedInMiddle2Sides = sum(red(4:5, [1 2 7 8]), 'all');
    numRedRisk = sum(middleRed & captureRisk, 'all');
    numRedProtected = sum(red(1:8, [1 8]), 'all') + sum(red([1 8], 2:7), 'all') + sum(middleRed & (red(1:6, 1:6) | red(3:8, 3:8)) & (red(1:6, 3:8) | red(3:8, 1:6)), 'all');
    
    features = [numBlackNormal, numBlackKing, ...
                numBlackInBackRow, numBlackInMiddle2by4, ...
                numBlackInMiddle2Sides, numBlackRisk, ...
                numBlackProtected, blackTurn, ...
                numRedNormal, numRedKing, ...
                numRedInBackRow, numRedInMiddle2by4, ...
                numRedInMiddle2Sides, numRedRisk, ...
                numRedProtected, ~blackTurn];
    
    if maximizingBlack
        heuristicBoardValue = features * [weights, -weights]';
    else
        heuristicBoardValue = features * [-weights, weights]';
    end
end
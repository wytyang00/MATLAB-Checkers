function [heuristicBoardValue] = evaluateBoard(empty, blackNormal, blackKing, black, redNormal, redKing, red, moveDistances, maximizingBlack, weights)
    
    captureMoves = (moveDistances == 2);
    noAvailableMoves = ~any(moveDistances, 3);

    captureMoves6by6 = reshape([captureMoves(3:8, 3:8, 1), captureMoves(3:8, 1:6, 2), captureMoves(1:6, 3:8, 3), captureMoves(1:6, 1:6, 4)], [6 6 4]);
    
    numBlackNormal = sum(blackNormal, 'all');
    numBlackKing = sum(blackKing, 'all');
    numBlackNormalCaptureMoves = sum(captureMoves6by6 & redNormal(2:7, 2:7), 'all');
    numBlackKingCaptureMoves = sum(captureMoves6by6 & redKing(2:7, 2:7), 'all');
    numTrappedBlackNormal = sum(noAvailableMoves & blackNormal, 'all');
    numTrappedBlackKing = sum(noAvailableMoves & blackKing, 'all');
    numRunawayBlack = sum(any(blackNormal(2, :) & moveDistances(2, :, 1:2), 3), 'all');
    numEdgeBlack = sum(black(1, :)) + sum(black(2:8, 1))+ sum(black(2:8, 8)) + sum(black(8, 2:7));
    blackFeatures = [numBlackNormal, numBlackKing, ...
                     numBlackNormalCaptureMoves, numBlackKingCaptureMoves, ...
                     numTrappedBlackNormal, numTrappedBlackKing, ...
                     numRunawayBlack, numEdgeBlack];
    blackScore = blackFeatures * weights';
    
    numRedNormal = sum(redNormal, 'all');
    numRedKing = sum(redKing, 'all');
    numRedNormalCaptureMoves = sum(captureMoves6by6 & blackNormal(2:7, 2:7), 'all');
    numRedKingCaptureMoves = sum(captureMoves6by6 & blackKing(2:7, 2:7), 'all');
    numTrappedRedNormal = sum(noAvailableMoves & redNormal, 'all');
    numTrappedRedKing = sum(noAvailableMoves & redKing, 'all');
    numRunawayRed = sum(any(redNormal(7, :) & moveDistances(7, :, 3:4), 3), 'all');
    numEdgeRed = sum(red(1, :)) + sum(red(2:8, 1))+ sum(red(2:8, 8)) + sum(red(8, 2:7));
    redFeatures = [numRedNormal, numRedKing, ...
                   numRedNormalCaptureMoves, numRedKingCaptureMoves, ...
                   numTrappedRedNormal, numTrappedRedKing, ...
                   numRunawayRed, numEdgeRed];
    redScore = redFeatures * weights';
    
    if maximizingBlack
        heuristicBoardValue = blackScore - redScore;
    else
        heuristicBoardValue = redScore - blackScore;
    end
end
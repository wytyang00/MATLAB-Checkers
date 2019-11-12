% Checks whether the given [row, column] position is within the board.
function [valid] = withinBoard(row, col)
    valid = row > 0 && row < 9 && col > 0 && col < 9;
end
% precision = gemDisplayPrecision(precision)
% 
% Getting and setting the display precision for all gem objects.
%
% To get the current precision used when displaying gem objects, use
%   precision = gemDisplayPrecision
% To display all gem objects with 30 digits, use
%   gemDisplayPrecision(30)
function precision = gemDisplayPrecision(precision)
    if nargin < 1
        precision = gem.displayPrecision;
    else
        gem.displayPrecision(precision);
        % We also set the precision for the sparse objects
        sgem.displayPrecision(precision);
    end
end

% display function, without printing of name
%
% possible usages:
%   disp(a)                  prints a with default precision
%   disp(a, precision)       prints a with given precision
%
% Note: Here, the precision is the number of significant digits printed
function disp(this, arg2)
    % The default display precision
    displayPrecision = sgem.displayPrecision;

    % Some versions of matlab provide the name as a second argument
    if (nargin >= 2)
        displayPrecision = double(arg2);
    end

    objId = this.objectIdentifier;
    sgem_mex('display', objId, displayPrecision);
    disp(' ');
end

% display function
%
% possible usages:
%   display(a)                  prints a with default precision
%   display(a, precision)       prints a with given precision
%   display(a, name)            prints a and name the result with the string 'name'
%   display(a, name, precision) prints a with given name and precision
%
% Note: Here, the precision is the number of printed digits (including leading zeros)
function display(this, arg2, arg3)
    % The default display precision
    displayPrecision = gem.displayPrecision;

    % Some versions of matlab provide the name as a second argument
    if (nargin >= 2) && ischar(arg2)
        name = arg2;
        if nargin >= 3
            displayPrecision = double(arg3);
        end
    else
        name = inputname(1);
        if (nargin >= 2)
            displayPrecision = double(arg2);
        end
    end


    if ~isempty(name)
        disp(' ');
        disp([name, ' = ']);
%        objId = this.objectIdentifier;
%        disp([name, ' (id: ', num2str(objId), ') = ']);
        disp(' ');
    end

    objId = this.objectIdentifier;
    gem_mex('display', objId, displayPrecision);
    disp(' ');
end

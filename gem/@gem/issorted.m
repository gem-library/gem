% issorted - checks if a matrix is sorted
%
% supported formats:
%   issorted(vector)
%   issorted(matrix, 'rows')
function result = issorted(this, option)
    if nargin < 2
        if min(size(this)) > 1
            error('Input must be a vector, or option ''rows'' must be used');
        end
        result = isequal(this, sort(this));
    else
        error('matrix sorting currently not supported');
%         if ~isequal(option, 'rows')
%             error('Unknown option');
%         end
%         result = isequal(this, sortrows(this));
    end
end

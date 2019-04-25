function result = gemRunTests
% function result = gemRunTests
%
% launches automatic tests for the GEM Library


% First, we make sure we are in the good folder
initialPath = pwd;
[pathStr, name, extension] = fileparts(which(mfilename));
cd(pathStr)

% We make sure gem is in the path
addpath([pathStr '/gem']);

% We make sure MOxUnit is in the path
MOxUnitInPath = false;
try
    moxunit_set_path;
    MOxUnitInPath = true;
catch
end
if ~MOxUnitInPath
    if exist([pathStr '/external/MOxUnit/MOxUnit/moxunit_set_path.m']) ~= 2
        error(['The MOxUnit library was not found in the folder ', pathStr, '/external/MOxUnit', char(10), ...
            'Did you run ''git submodule init'' and ''git submodule update''?', char(10), ...
            'The tests cannot be run.']);
    else
        addpath([pathStr '/external/MOxUnit/MOxUnit']);
        moxunit_set_path;
    end
end

% We make sure MOcov is in the path
addpath([pathStr '/external/MOcov/MOcov']);

% We also add the test folder to the path
addpath([pathStr '/tests']);

% Run the tests
result = moxunit_runtests('tests', '-verbose', '-recursive', '-junit_xml_file', 'testresults.xml', ...
                          '-with_coverage', '-cover', 'gem', '-cover_xml_file', 'coverage.xml', '-cover_html_dir', 'coverage_html');

% Go back to the initial folder    
cd(initialPath);

end

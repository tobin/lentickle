% sets up environment for lentickle

% How to do package management in Matlab?
%
% In general we depend on some other packages in order for lentickle to
% work (i.e. optickle, nicmatlabscripts).  A couple ideas:
%
%  * have standard locations to find them (~/ligo/foo)
%  * have standard variable names for their paths (OPTICKLE_PATH)
%  * have environment variables (getenv('OPTICKLE_PATH'))
%  * make symlinks under the lentickle tree <-- I like this option
%
% In the meantime:

% set up path
if ~exist('Optickle.m', 'file'),
    if ~exist('OPTICKLE_PATH','var'),
        switch getenv('USERNAME')  % do you know a better way?
            case 'tobin',
                OPTICKLE_PATH = '~/home/tobin/iscmodeling/Optickle';
            case 'nicolas',
                OPTICKLE_PATH = '~/ligo/sim/Optickle';
            otherwise                
                OPTICKLE_PATH = 'Optickle';  % Look in a subdirectory?
        end
    end
    addpath(genpath(OPTICKLE_PATH));
    if ~exist('Optickle.m', 'file'),
            error('Couldn''t find Optickle');
    end
end


% Add subdirectories to the path
addpath('OptickleEligo');
addpath(genpath('mattlib'));
addpath(genpath('pickleCode'));

% also my useful matlab scripts, available here:
% git clone git://github.com/nicolassmith/nicmatlabscripts.git
% or
% https://github.com/nicolassmith/nicmatlabscripts/zipball/master
%

% Try to find the nicmatlabscripts
if ~exist('SRSbode.m', 'file'),
    % Look for a subdirectory or symlink
    if exist('nicmatlabscripts/SRSbode.m', 'file'),
        addpath('nicmatlabscripts');
    else
        error('Couldn''t find nicmatlabscripts');
    end
end
%addpath('pathto/nicmatlabscripts')

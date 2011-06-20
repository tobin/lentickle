% sets up environment for lentickle

LENTICKLE_PATH = pwd();

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
                OPTICKLE_PATH = '/home/tobin/iscmodeling/Optickle';
            case 'nicolas',
                OPTICKLE_PATH = '~/ligo/sim/Optickle';
            otherwise                
                OPTICKLE_PATH = ...
                    [LENTICKLE_PATH '/Optickle'];  % Look in a subdir?
        end
    end
    addpath(genpath(OPTICKLE_PATH));
    if ~exist('Optickle.m', 'file'),
            error('Couldn''t find Optickle');
    end
end

% Add subdirectories to the path
if ~exist('paramEligo.m','file'),
    addpath([LENTICKLE_PATH '/OptickleEligo']);
end
if ~exist('paramEligo.m', 'file'),
    error('Couldn''t find OptickleEligo');
end

addpath(genpath([LENTICKLE_PATH '/mattlib']));

if ~exist('pickleEngine.m', 'file'),
    if ~exist('PICKLE_PATH', 'var'),
        PICKLE_PATH = [LENTICKLE_PATH '/pickleCode'];
    end
    if exist([PICKLE_PATH '/pickleEngine.m']),
        addpath(genpath(PICKLE_PATH));
    else
        error('Can''t find pickle');
    end
end

% also my useful matlab scripts, available here:
% git clone git://github.com/nicolassmith/nicmatlabscripts.git
% or
% https://github.com/nicolassmith/nicmatlabscripts/zipball/master
%

% Try to find the nicmatlabscripts
if ~exist('SRSbode.m', 'file'),
    % Look for a subdirectory or symlink
    if exist([LENTICKLE_PATH '/nicmatlabscripts/SRSbode.m'], 'file'),
        addpath([LENTICKLE_PATH '/nicmatlabscripts']);
    else
        error('Couldn''t find nicmatlabscripts');
    end
end
%addpath('pathto/nicmatlabscripts')

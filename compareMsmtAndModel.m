function compareMsmtAndModel(msmts, rslts, ifo, doUseSubfigures)
% compareMsmtAndModel(msmt, lentickle_rslt, ifo)
%
%  ifo = 'L1';
%  msmt_root = '/home/tobin/projects/eligomeasurements/';
%  msmts = load_msmts(msmt_root, ifo);
%  lentickulate;
%  compareMsmtAndModel(msmts, rslts, ifo);

% convenience function to put together a 'coupling' struct
mk_coupling = @(name, title, drive, drive_calib, unit, loop) ...
    struct('name', name, 'title', title, 'drive', drive, ...
           'drive_calib', drive_calib, 'unit', unit, 'loop', loop);

% pull the modulation depth out of the optickle model:
gamma = imag(get(getOptic(rslts(1).opt, 'Mod1'), 'aMod'));

% functions to calibrate Lentickle drives into what we want       
AM_to_RIN = @(f) 2*ones(size(f));  % AM * 2     = RIN
PM_to_HZ  = @(f) - 1i * f;         % PM * (f/i) = FM

% SB RIN = 2 Γ₀ J₁'(Γ₀) / J₁(Γ₀) * OSC AM  [ http://goo.gl/QlAJ2 ]
OSCAM_to_SBRIN = @(f)  2 * gamma * ...
    (1/2)*(besselj(0,gamma) - besselj(2,gamma)) / besselj(1,gamma);
clear gamma;

no_calib  = @(f) ones(size(f));

% nice structure describing the couplings:
couplings = [...
    mk_coupling('laserAM', 'Laser Amplitude Noise',      'AM',          AM_to_RIN, 'RIN',     []), ...
    mk_coupling('laserFM', 'Laser Frequency Noise',      'PM',          PM_to_HZ,  'HZ',     'CM'), ...
    mk_coupling('oscAM',   'Oscillator Amplitude Noise', 'Mod1.amp',    OSCAM_to_SBRIN,  'SB RIN',  []), ...
    mk_coupling('oscPM',   'Oscillator Phase Noise',     'Mod1.phase',  no_calib,  'radian',  [])];

clf;

if nargin < 4,
    doUseSubfigures = false;
end

for ii=1:length(couplings),
    if doUseSubfigures
        subplot(2, 2, ii);
    else 
        figure(ii)
        clf;
    end
    coupling = couplings(ii);
    
    if isfield(msmts, coupling.name)
        plot_msmt(msmts.(coupling.name), 1, '.-');
    end
    plot_models(rslts, coupling);
    
    title(coupling.title);
    ylabel(['meters per ' coupling.unit]);  
    xlabel('frequency [Hz]');
    caxis([-20 20]);
   % colorbar;
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function color = choosecolor(offset)
  color = interp1(linspace(-20, 20, 64), jet, offset);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_msmt(msmt, linewidth, style)

for ii=1:length(msmt)
    loglog(msmt(ii).f, abs(msmt(ii).H), ...
        style, 'LineWidth', linewidth, 'color', choosecolor(msmt(ii).x0));
    hold all
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_models(rslts, coupling)
for ii = 1:length(rslts)
    plot_model(rslts(ii), coupling);
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_model(rslt, coupling)

DARM_to_OMC_CL = pickleTF(rslt, 'EX', 'OMC_PD', 'CL') ...
                -pickleTF(rslt, 'EY', 'OMC_PD', 'CL');

if isfield(coupling, 'loop') && ~isempty(coupling.loop)
    CLG = pickleTF(rslt, coupling.loop, coupling.loop, 'CL');
else
    % no loop correction needed
    CLG = 1; 
end

% (OMC / drive) / (drive units / drive) =  OMC / drive units
Noise_to_OMC_CL = pickleTF(rslt, coupling.drive, 'OMC_PD', 'CL') ./ ...
                  coupling.drive_calib(rslt.f);              

offset = rslt.metadata.x0 * 1e12;
color = choosecolor(offset);

%loglog(rslt.f, abs(Noise_to_OMC_OL ./ DARM_to_OMC_OL), ...
loglog(rslt.f, abs(Noise_to_OMC_CL ./ DARM_to_OMC_CL ./ CLG), 'color', color);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function multihold(ax, str)
arrayfun(@(ax) hold(ax, str), ax);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ax = simplebode(f, H, varargin)
ax = subplot(2,1,1);
semilogx(f, db(H), varargin{:});
ylabel('dB');

ax(2) = subplot(2,1,2);
semilogx(f, angle(H)*180/pi, varargin{:});
set(ax(2), 'ytick', 45*(-4:4));
xlabel('frequency [Hz]');
ylabel('phase [degrees]');
end
function compareOLCL(rslt, ifo)
%% Compare Open-Loop and Closed-Loop couplings
% See the effect of cross-couplings.

couplings = [...
    struct('drive', 'AM',         'name', 'Laser Amplitude Noise',      'loop',  []), ...
    struct('drive', 'PM',         'name', 'Laser Phase Noise',          'loop', 'CM'), ...
    struct('drive', 'Mod1.amp',   'name', 'Oscillator Amplitude Noise', 'loop',  []),...
    struct('drive', 'Mod1.phase', 'name', 'Oscillator Phase Noise',     'loop',  [])];

DARM_to_OMC_OL = pickleTF(rslt, 'EX', 'OMC_PD', 'OL') ...
                -pickleTF(rslt, 'EY', 'OMC_PD', 'OL');
             
DARM_to_OMC_CL = pickleTF(rslt, 'EX', 'OMC_PD', 'CL') ...
                -pickleTF(rslt, 'EY', 'OMC_PD', 'CL');

clf;
set(gcf, 'DefaultLineLineWidth', 2)
            
for ii=1:length(couplings),
    subplot(2,2,ii);
    coupling = couplings(ii);
    
    if isempty(coupling.loop)
        CLG = 1;
    else
        CLG = pickleTF(rslt, coupling.loop, coupling.loop, 'CL');
    end
    
    Noise_to_OMC_OL = pickleTF(rslt, coupling.drive, 'OMC_PD', 'OL');
    Noise_to_OMC_CL = pickleTF(rslt, coupling.drive, 'OMC_PD', 'CL');

    loglog(rslt.f, abs(Noise_to_OMC_OL ./ DARM_to_OMC_OL), ...
           rslt.f, abs(Noise_to_OMC_CL ./ DARM_to_OMC_CL ./ CLG));
    
    title(coupling.name);
    ylabel(['meters per ' coupling.drive]);
    legend('open loop', 'closed loop', 'Location', 'Best');
end

orient landscape;
print('-dpdf', ['figures/compareOLCL-' ifo '.pdf']);

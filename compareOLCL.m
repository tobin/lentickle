function compareOLCL(ifo)
%% Compare Open-Loop and Closed-Loop couplings
% See the effect of cross-couplings.

inPower = 10;
offset  = 10e-12;

f = logspace(log10(1), log10(8000), 301);
rslt = getEligoResults(f, inPower, offset, 'OMC', ifo);

%%
couplings = [...
    struct('drive', 'AM',         'name', 'Laser Amplitude Noise'), ...
    struct('drive', 'PM',         'name', 'Laser Phase Noise'), ...
    struct('drive', 'Mod1.amp',   'name', 'Oscillator Amplitude Noise'),...
    struct('drive', 'Mod1.phase', 'name', 'Oscillator Phase Noise') ];

DARM_to_OMC_OL = pickleTF(rslt, 'EX', 'OMC_PD', 'OL') ...
                -pickleTF(rslt, 'EY', 'OMC_PD', 'OL');
             
DARM_to_OMC_CL = pickleTF(rslt, 'EX', 'OMC_PD', 'CL') ...
                -pickleTF(rslt, 'EY', 'OMC_PD', 'CL');

clf;
set(gcf, 'DefaultLineLineWidth', 2)
            
for ii=1:length(couplings),
    subplot(2,2,ii);
    coupling = couplings(ii);
    
    Noise_to_OMC_OL = pickleTF(rslt, coupling.drive, 'OMC_PD', 'OL');
    Noise_to_OMC_CL = pickleTF(rslt, coupling.drive, 'OMC_PD', 'CL');

    loglog(f, abs(Noise_to_OMC_OL ./ DARM_to_OMC_OL), ...
           f, abs(Noise_to_OMC_CL ./ DARM_to_OMC_CL));
    
    title(coupling.name);
    ylabel(['meters per ' coupling.drive]);
    legend('open loop', 'closed loop', 'Location', 'Best');
end

orient landscape;
print('-dpdf', ['figures/compareOLCL-' ifo '.pdf']);

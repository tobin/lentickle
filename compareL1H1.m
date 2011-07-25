function compareL1H1(msmt_root)
% Compare L1 and H1 noise coupling measurements
% 
% compareL1H1('/home/tobin/projects/eligomeasurements/');

if nargin<1
    msmt_root = '/home/tobin/projects/eligomeasurements/';
end

msmts.L1 = load_msmts(msmt_root, 'L1');
msmts.H1 = load_msmts(msmt_root, 'H1');

msmt_titles = ... 
        struct('laserAM', 'laser amplitude noise coupling', ...
               'laserFM', 'laser frequency noise coupling', ...
               'oscAM',   'oscillator amplitude noise coupling', ...
               'oscPM',   'oscillator phase noise coupling');
           
msmt_names = fields(msmt_titles);

for ii=1:length(msmt_names);
    name = msmt_names{ii};
    subplot(2,2,ii);
    compare_couplings(msmts, name);   
    title(msmt_titles.(name));    
    %orient landscape
    %print('-dpdf', ['compareL1H1-' name '.pdf']);
end
orient landscape
print('-dpdf', 'figures/compareL1H1.pdf');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function compare_couplings(msmts, name)
plot_msmt(msmts.L1.(name), 1, '.-');
plot_msmt(msmts.H1.(name), 1, '-');
hold off
caxis([-20 20]);
%colorbar
xlabel('frequency [Hz]');
ylabel(msmts.L1.(name)(1).units);
grid on          
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_msmt(msmt, linewidth, style)
choosecolor = @(offset) interp1(linspace(-20, 20, 64), jet, offset);
for ii=1:length(msmt)
    loglog(msmt(ii).f, abs(msmt(ii).H), ...
        style, 'LineWidth', linewidth, 'color', choosecolor(msmt(ii).x0));
    hold all
end
end


%  ifo = 'L1';
%  msmt_root = '/home/tobin/projects/eligomeasurements/';
%  msmts = load_msmts(msmt_root, ifo);
%  lentickulate;
%  compareMsmtAndModel(msmts, rslts, ifo);

ifos = {'L1', 'H1'};
msmt_root = '/home/tobin/projects/eligomeasurements/';

for ii=1:length(ifos)
    ifo = ifos{ii};
    msmts.(ifo) = load_msmts(msmt_root, ifo);
    rslts.(ifo) = lentickulate(ifo);
end

%%

ifos = {'H1'};
for ii=1:length(ifos)
    ifo = ifos{ii};
    clf
    compareMsmtAndModel(msmts.(ifo), rslts.(ifo), ifo, true);
    orient landscape
  %  arrayfun(@(ax) ylim(ax, [1e-16 1e-10]), get(gcf, 'Children'));
    h = annotation('textbox', [0 0 0.1 0.1]);
    set(h,'String', ['measurements and models (' ifo ')']);
    set(h,'Position',  [0.0056    0.9581    0.4968    0.0332], ...
        'LineStyle', 'none', 'FontSize', 16);
    print('-dpdf',['figures/compareMsmtAndModel-' ifo '.pdf']);
end

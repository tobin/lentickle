%% Compare measured and modeled DARM open loop gain (OLG)

ifo = 'L1';

%% Run Lentickle
setupLentickle;

f = logspace(log10(20),log10(8000), 201).';

inPower = 10;
darmoffset = 10e-12;

[rslt, opt, lent] = getEligoResults(f, inPower, darmoffset, 'OMC', ifo);

%% Read a measurement

switch ifo
    case 'H1'
        data = dlmread('eligomeasurements/OMCbackscatter/H1/07-07/darmolg.txt');
        
        msmt = struct('f', [], 'H', []);
        msmt.f = data(:,1);
        msmt.H = data(:,2) + 1i*data(:,3);
    case 'L1'
        error('I don''t have a measurement of the L1 DARM OLG.');
end

%% Plot them together

clg = pickleTF(rslt, 'DARM', 'DARM', 'cl');
olg = 1 - 1./clg;

subplot(2,1,1);
semilogx(f, db(olg), '-', msmt.f, db(msmt.H), '.-');  
legend('model', 'measurement');
title([ifo 'DARM OLG']);
ylabel('dB');
subplot(2,1,2);
semilogx(f, angle(olg)*180/pi, '-', msmt.f, angle(msmt.H)*180/pi, '.-');
set(gca,'YTick', 45*(-4:4));
ylabel('degrees');
xlabel('Hz');

print(gcf, '-dpdf', ['compareDarmLoop' ifo '.pdf']);

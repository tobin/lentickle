%% Compare measured and modeled MICH open loop gain (OLG)

%% Run Lentickle
setupLentickle;

f = logspace(log10(20),log10(8000), 201).';

inPower = 10;
darmoffset = 10e-12;

rslt = getEligoResults(f,inPower,darmoffset, 'OMC', 'L1');

%% Read a measurement

switch ifo
    case 'H1',
        error('No H1 MICH measurement');
    case 'L1',
        data = dlmread('eligomeasurements/loops/L1/mich_loop_gain_lownoise_Aug07.txt');
        
        msmt = struct('f', [], 'H', []);
        msmt.f = data(:,1);
        msmt.H = data(:,2) + 1i*data(:,3);
end

%% Plot them together

clg = pickleTF(rslt, 'MICH', 'MICH', 'cl');
olg = 1 - 1./clg;

subplot(2,1,1);
semilogx(f, db(olg), '-', msmt.f, db(msmt.H), '.-');  
legend('model', 'measurement');
title([ifo 'MICH OLG']);
ylabel('dB');
subplot(2,1,2);
semilogx(f, angle(olg)*180/pi, '-', msmt.f, angle(msmt.H)*180/pi, '.-');
set(gca,'YTick', 45*(-4:4));
ylabel('degrees');
xlabel('Hz');

print(gcf, '-dpdf', ['compareMichLoop' ifo '.pdf']);
%% Compare measured and modeled PRC open loop gain (OLG)

%% Run Lentickle
setupLentickle;

f = logspace(log10(20),log10(8000), 201).';

inPower = 10;
darmoffset = 10e-12;

rslt = getEligoResults(f,inPower,darmoffset, 'OMC', ifo);

%% Read a measurement

switch ifo
    case 'L1'
        data = dlmread('eligomeasurements/loops/L1/prc_loop_gain_lownoiseAug07.txt');
        
        msmt = struct('f', [], 'H', []);
        msmt.f = data(:,1);
        msmt.H = data(:,2) + 1i*data(:,3);
    otherwise
        error('No PRC OLG measurement');
end

%% Plot them together

clg = pickleTF(rslt, 'PRC', 'PRC', 'cl');
olg = 1 - 1./clg;

subplot(2,1,1);
semilogx(f, db(olg), '-', msmt.f, db(msmt.H), '.-');  
legend('model', 'measurement');
title([ifo 'PRC OLG']);
ylabel('dB');
subplot(2,1,2);
semilogx(f, angle(olg)*180/pi, '-', msmt.f, angle(msmt.H)*180/pi, '.-');
set(gca,'YTick', 45*(-4:4));
ylabel('degrees');
xlabel('Hz');

print(gcf, '-dpdf', ['comparePrcLoop' ifo '.pdf']);
%% Compare measured and modeled DARM open loop gain (OLG)

%% Run Lentickle
setupLentickle;

f = logspace(log10(20),log10(8000), 201).';

inPower = 10;
darmoffset = 10e-12;

rslt = getEligoResults(f,inPower,darmoffset);

%% Read a measurement

data = dlmread('eligomeasurements/OMCbackscatter/H1/07-07/darmolg.txt');

msmt = struct('f', [], 'H', []);
msmt.f = data(:,1);
msmt.H = data(:,2) + 1i*data(:,3);

%% Plot them together

clg = pickleTF(rslt, 'DARM', 'DARM', 'cl');
olg = 1 - 1./clg;

subplot(2,1,1);
semilogx(f, db(olg), '-', msmt.f, db(msmt.H), '.-');  
legend('model', 'measurement');
title('H1 DARM OLG');
ylabel('dB');
subplot(2,1,2);
semilogx(f, angle(olg)*180/pi, '-', msmt.f, angle(msmt.H)*180/pi, '.-');
ylabel('degrees');
xlabel('Hz');
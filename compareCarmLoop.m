%% Compare measured and modeled DARM open loop gain (OLG)

%% Run Lentickle
setupLentickle;

f = logspace(log10(20),log10(100e3), 201).';

inPower = 10;
darmoffset = 10e-12;

rslt = getEligoResults(f,inPower,darmoffset);

%% Read a measurement

fn = 'eligomeasurements/DCnoisecouplings/freq/L1/2010-06-02/CM000.ASC';
data = textread(fn, '', 'headerlines', 17);

msmt.f = data(:,1);
msmt.H = (10.^(data(:,2)/20)) .* exp(1i*data(:,3)*pi/180);

%% Plot them together

clg = pickleTF(rslt, 'CM', 'CM', 'cl');
olg = 1 - 1./clg;

subplot(2,1,1);
semilogx(f, db(olg), '-', msmt.f, db(msmt.H), '.-');  
legend('model', 'measurement');
title('L1 CARM OLG');
ylabel('dB');
subplot(2,1,2);
semilogx(f, angle(olg)*180/pi, '-', msmt.f, angle(msmt.H)*180/pi, '.-');
set(gca,'YTick', 45*(-4:4));
ylabel('degrees');
xlabel('Hz');

print -dpdf compareCarmLoopL1.pdf
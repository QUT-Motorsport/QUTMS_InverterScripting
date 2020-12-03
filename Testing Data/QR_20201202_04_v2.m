run = 'QR_20201202_04';

fileL = [run, '_L.txt'];
fileR = [run, '_R.txt'];

delta = 20e-3;

wr = 9*25.4;                    %wheel radius (mm)
vf = (2*pi*wr)/(60*4.5*1000);   %rpm to m/s
kf = (3600)/(1000);

df = (2*pi*wr)/(21*6*4.5*1000);

fL = fopen(fileL);
fR = fopen(fileR);

tLR = 1.43;

dump = true;
while (dump) 
   line = fgetl(fL);
   data = sscanf(line, '%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d');
   if (length(data) == 14)
       dump = false;
   end
end

t = 0;
dataL = [];
while (feof(fL) == 0)
    line = fgetl(fL);
    ele = split(line,':');
    if (length(ele) == 14)
        data = sscanf(line, '%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d');
        if (length(data) == 14)
            dataL = [dataL; t, data'];
        end
    end
    t = t+delta;
end

startIdx = min(find(dataL(:,15)>100));
dataL = dataL(startIdx:end,:);
dataL(:,1) = dataL(:,1)-dataL(1,1);

dump = true;
while (dump) 
   line = fgetl(fR);
   data = sscanf(line, '%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d');
   if (length(data) == 14)
       dump = false;
   end
end

t = 0;
dataR = [];
while (feof(fR) == 0)
    line = fgetl(fR);
    ele = split(line,':');
    if (length(ele) == 14)
        data = sscanf(line, '%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d');
        if (length(data) == 14)
            dataR = [dataR; t, data'];
        end
    end
    t = t+delta;
end

startIdx = min(find(dataR(:,15)>100));
dataR = dataR(startIdx:end,:);
dataR(:,1) = dataR(:,1)-dataR(1,1);

deltaL = dataL(2:end,:)-dataL(1:(end-1),:);
deltaR = dataR(2:end,:)-dataR(1:(end-1),:);

toDeleteL = [];
toDeleteR = [];

[L,~]=find(abs(deltaL(:,2:3))>500);
[R,~]=find(abs(deltaR(:,2:3))>500);
toDeleteL = [toDeleteL; L];
toDeleteR = [toDeleteR; R];

[L,~]=find(dataL(:,6:7)>5000);
[R,~]=find(dataR(:,6:7)>5000);
toDeleteL = [toDeleteL; L];
toDeleteR = [toDeleteR; R];

[L,~]=find(abs(deltaL(:,8:9))>2500);
[R,~]=find(abs(deltaR(:,8:9))>2500);
toDeleteL = [toDeleteL; L];
toDeleteR = [toDeleteR; R];

dataL(toDeleteL,:) = [];
dataR(toDeleteR,:) = [];

dataL(:,[2:5,15]) = 0.1*dataL(:,[2:5,15]);
dataR(:,[2:5,15]) = 0.1*dataR(:,[2:5,15]);

dataL = [dataL, dataL(:,6:7)*vf*kf, dataL(:,8:9)*df];
dataR = [dataR, dataR(:,6:7)*vf*kf, dataR(:,8:9)*df];

dataR(:,1) = dataR(:,1)+tLR;

figure;

subplot(2,1,1);
plot(dataL(:,1),dataL(:,2:3),dataR(:,1),dataR(:,2:3));
ylabel('Motor current (Arms)');

subplot(2,1,2);
plot(dataL(:,1),dataL(:,16:17),dataR(:,1),dataR(:,16:17));
ylabel('Speed (km/h)');

figure;

subplot(2,1,1);
plot(dataL(:,1),dataL(:,15),dataR(:,1),dataR(:,15));
ylabel('Volts (V)');

subplot(2,1,2);
plot(dataL(:,1),dataL(:,4:5),dataR(:,1),dataR(:,4:5));
ylabel('Battery amps (A)');
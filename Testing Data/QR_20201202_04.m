run = 'QR_20201202_04';

fileL = [run, '_L.txt'];
fileR = [run, '_R.txt'];

delta = 20e-3;

fL = fopen(fileL);
fR = fopen(fileR);

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

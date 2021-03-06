warning('off','all')

%datafile='Messdaten_Smokey/csi3x3_2min.dat';
datafile='Messdaten_Smokey/csi_measurement_smoking2.dat';
calibfile='Messdaten_Smokey/csi_background4.dat';
%datafile='Messdaten_Smokey/csi3x3_2min.dat';

doShortenData=0;
shortenData=6;
useSpatialPaths=[2 2];

global deviation;
deviation=1.5;
global learningrate
learningrate=0.2;    



csiTrace = read_bf_file(datafile);
csiTraceCalib=read_bf_file(calibfile);
%csiTrace=csiTrace(6:length(csiTrace)); %erste Messwerte haben falsche Zeitstempel



csiValues=get_csi_Values(csiTrace);
csiValuesCalib=get_csi_Values(csiTraceCalib);
csiTimestamps=get_csi_Timestamps(csiTrace);
traceCount=size(csiValues,2);

if doShortenData
    csiValues=filter_Array(csiValues,shortenData);
    csiTimestamps=filter_Array(csiTimestamps,shortenData);
    traceCount=size(csiValues,2);
end


csiValues=csiValues((useSpatialPaths(1)-1)*30+1:useSpatialPaths(2)*30,:);
csiValuesCalib=csiValuesCalib((useSpatialPaths(1)-1)*30+1:useSpatialPaths(2)*30,:);
display_csi(csiValues,csiTimestamps,'Rohdaten');
%return;
%calibData=csiValues(:,200:300);

calibration=get_Mean_and_Std(csiValuesCalib);
%calibration=get_Mean_and_Std(csiValues(:,200:300);
csiForeground=extract_Foreground(csiValues,calibration);
csiForeground2=extract_Foreground2(csiValues,calibration,csiTimestamps);



display_csi(csiForeground,csiTimestamps,'Foreground ohne Adaption');
display_csi(csiForeground2,csiTimestamps,'Foreground mit Adaption');

filtered=filter_Foreground(csiForeground2,csiTimestamps,3);
filtered2=filter_Foreground(filtered,csiTimestamps,1);
display_csi(filtered2,csiTimestamps,'Foreground gefiltert');



csiSum=sum(filtered2);
figure;
plot(csiTimestamps,csiSum);
title('Summe der gefilterten Werte');
return;


%Methode filter_small_Events ist noch leer
csiFiltered=filter_small_Events(csiForeground,csiTimestamps);
display_csi(csiFiltered,csiTimestamps);

%Methode filter_single_Motion ist noch leer
csiFiltered2=filter_single_Motion(csiFiltered,csiTimestamps);
cisplay_csi(csiFiltered2,csiTimestamps);

%ToDo: Periodizitäts-Analyse.......









url='http://ustb.no/datasets/';                  %Download and read dataset
local_path = [ustb_path(),'/data/']; 
filename='Verasonics_P2-4_parasternal_long_small.uff';
tools.download(filename, url, local_path);
channel_data = uff.read_object([local_path, filename],'/channel_data');

depth_axis=linspace(0e-3,110e-3,1024).';  % Define image scan
azimuth_axis=linspace(channel_data.sequence(1).source.azimuth,...
    channel_data.sequence(end).source.azimuth,channel_data.N_waves)';
scan=uff.sector_scan('azimuth_axis',azimuth_axis,'depth_axis',depth_axis);

mid=midprocess.das();tic();  % Beamform image
mid.code = "matlab";
mid.channel_data=channel_data;
mid.dimension = dimension.both();
mid.scan=scan;
mid.transmit_apodization.window=uff.window.scanline;
mid.receive_apodization.window=uff.window.none;
b_data = mid.go();toc();               

%%
% Exercise Module 1: Add your name to the title above so that it says
% "Human Heart by Your Name" and add the image your report.
b_data.plot([],['Human Heart by Edvart'],[],[],[],[],[],'dark');    % Display 


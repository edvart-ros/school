% Sonar imaging : Exercise for Module 4
%
%   See the sonar_exercise.pdf in the current folder for the exercise text.
%
% Author: Ole Marius Hoel Rindal <21.09.2021> adapted from code and data
%         from Roy Edgar Hansen and Fabrice Prieur

clear all;
close all;

%% Read the data channel data
channel_data = uff.channel_data();
channel_data.read('./sonar_ping.uff','/channel_data');
channel_data.plot()

%% Read a beamformed image of the raw uncompressed signal
% This is an example of how the image beamformed from the raw uncompressed
% signal might look like in part c) of the exercise
b_data_raw= uff.beamformed_data();
b_data_raw.read('./sonar_ping.uff','/b_data_raw');
b_data_raw.plot([],['SONAR uncompressed'],[],[],[],[],'m','dark')
colormap default
clim([-65 -10])

%% Parameters for the transmit signal a Linear Frequency Modulated (LFM) upchirp pulse
bw = 30000;     % Bandwidth in Hertz
t_p = 0.0080;   % Pulse Length in seconds

%% Define the theoretical transmit pulse, a Linear Frequency Modulated (LFM) pulse

alpha = (bw)/t_p;
n_transmit_samples = floor(t_p*channel_data.sampling_frequency);
t_transmit = linspace(-t_p/2, t_p/2, n_transmit_samples)';
s_Tx = exp(1i*2*pi*alpha*t_transmit.^2/2);

receive_period = 1/(channel_data.sampling_frequency);
n_receive_samples = length(channel_data.data);
t_receive = linspace(0, receive_period*n_receive_samples, n_receive_samples)';

%% Create a copy of the channel data object to hold the pulse compressed data
channel_data_compressed = uff.channel_data(channel_data);
% Change the initial time to half of the pulse length to "center" the compressed data
channel_data_compressed.initial_time = t_p/2;

%% Do Pulse Compression
% Create an empty buffer to hold the resulting data 
% notice that we make it twice as long as the original signal? Why and how
% should you handle this??
% Create an empty buffer to hold the resulting data
match_filtered_data = zeros(2 * n_receive_samples - 1, channel_data.N_elements);

for elem = 1:channel_data.N_elements
    s_Rx = channel_data.data(:, elem);

    % Do FFT compression
    S_Rx = fft(s_Rx, 2 * n_receive_samples - 1);
    S_Tx = fft(s_Tx, 2 * n_receive_samples - 1);
    s_m = ifft(S_Rx .* conj(S_Tx));

    match_filtered_data(:, elem) = s_m;
end

% replace the copied data in the uff.channel_data object with the
% pulse compressed data
% NB! Look at the hints in the exercise text regarding which part of the
% data you should write back to the channel_data_compressed.data... ;)
channel_data_compressed.data = match_filtered_data(1:n_receive_samples, :);


%% Plot and compare channel data compressed and not compressed
% You need to write this code to make plots simiar to the ones shown in the
% exercise text.
chan = 28;
raw_data = channel_data.data(:, chan);
pulse_compressed_data = channel_data_compressed.data(:, chan);

figure;
subplot(2, 2, 1);
plot(t_receive*1000, abs(hilbert(real(raw_data))));
title('Raw Data');
xlabel('time [ms]');
ylabel('Magnitude');

subplot(2, 2, 2);
plot(t_receive(4000:4400)*1000, abs(hilbert(real(raw_data(4000:4400)))));
title('Raw Data');
xlabel('time [ms]');
ylabel('Magnitude');

subplot(2, 2, 3);
plot(t_receive*1000, abs(hilbert(real(pulse_compressed_data))), 'r');
title('Pulse Compressed Data ');
xlabel('time [ms]');
ylabel('Magnitude');

subplot(2, 2, 4);
plot(t_receive(4000:4400)*1000, abs(hilbert(real(pulse_compressed_data(4000:4400)))), 'r');
title('Pulse Compressed Data');
xlabel('time [ms]');
ylabel('Magnitude');
print -deps epsFig

%% Define a sector scan based on the theoretical angular resolution calculated in a)
az_res = 0.0124;
range_res = 0.02566;
scan = uff.sector_scan();
scan.depth_axis = [0:range_res:160];
scan.azimuth_axis = [-0.2:0.0124:0.2];
%% Set up the DAS beamformer in USTB
% Look back at previous examples and the previous exercise on how to set up
% beamforming with the USTB. Make sure that you for this setups use "no"
% apodization for the transmit wave apodization and the receive
% apodization. Thus, you should use the "uff.window.none" for both.
%
% Also make sure that you create the image for both the raw uncompressed
% channel data and the channel data where you have ran pulse compression

mid = midprocess.das();
mid.scan = scan;
mid.transmit_apodization.window=uff.window.none;
mid.receive_apodization.window=uff.window.none;
mid.code = 'matlab';
mid.channel_data = channel_data;
% beamform raw data
b_data = mid.go();
% beamform pulse compressed data
mid.channel_data = channel_data_compressed;
b_data_compressed = mid.go();

%%
channel_data.plot();
%%
channel_data_compressed.plot();

%% To have a nice interactive way of comparing the images you can use the
% following code given that your resulting beamformed data objects are
% called b_data and b_data_compressed. This code also shows how it can be
% suitable to display the images with a default colormap and suitable caxis
b_data_compare = uff.beamformed_data(b_data);
b_data_compare.data(:,1) = b_data.data./mean(b_data.data(:));
b_data_compare.data(:,2) = b_data_compressed.data./mean(b_data_compressed.data(:));


b_data_compare.plot([],['SONAR 1 = raw, 2 = compressed'],[],[],[],[],'m','dark')
caxis([-65 -10])
colormap default

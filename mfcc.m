%% References
%% [1] http://practicalcryptography.com/miscellaneous/machine-learning/guide-mel-frequency-cepstral-coefficients-mfccs/
%% [2] http://arxiv.org/pdf/1003.4083.pdf
%% [3] http://ijirae.com/volumes/vol1/issue10/27.NVEC10086.pdf
%% [4] An efficient mfcc extraction method in speech recognition
%% [5] http://in.mathworks.com/matlabcentral/answers/24455-divide-audio-signal-into-frames

%% Para escuchar una señal con sound(), instalar octave-sound 
%% y mirar http://notesofaprogrammer.blogspot.com.ar/2014/09/audio-playing-and-recording-with-octave.html

function mfcc(signal, fm)

	frame_step = 0.010;
	M = fm * frame_step; % 80 frames total	
	N = floor(length(signal)/M); % frame length (different for every signal)

	% Pre–emphasis filter. Reference [2]
	for n=2:length(signal)
		signal_emph(n)=signal(n)-0.95*signal(n-1);
	end
	signal_emph(1)=signal(1);

	% Framing
	frames = framing(signal_emph,N, M);

	% Windowing (from [2])
	hamming_window = 0.54 - 0.46 * cos(2 * pi * [0 : N - 1].'/(N - 1));
	frames_hamming = frame.*hamming_window;

	% FFT for every frame
	for i=1:length(frames)
		frames_fft(:,i) = fft(frames_hamming(:,i));
	end

	% Mel-frequency Wrapping [1]

	% % Convert the upper and lower freq to Mels
	lower_freq = 300;
	upper_freq = fm/2; % 8000/2

	lower_freq = hz2mel(lower_freq);
	upper_freq = hz2mel(upper_freq);
	
	% % get X points between those mels
	nfilterbanks = 26;
	filter_rand_points = randperm(upper_freq-lower_freq, nfilterbanks).+ (lower_freq - 1);
	filter_points_mel = [lower_freq, filter_rand_points, upper_freq];
	
	% % Convert points back to Hz
	filter_points_hz = arrayfun(@mel2hz, filter_ponts_mel);		

	% % Round frecuencys to the nearest FFT bin (we need nfft y sample rate = fm)
	nfft = 512; 
	fft_bin = floor((nfft+1)*filter_points_hz/fm);

	% % Create the filterbanks. The first filterbank will start at first point, peak at second, return to zero at 3rd.
	% % Second one, start at 2nd, reach max at 3rd, zero at 4th. And so on
	filterbank = zeros(nfilterbanks, nfft/2 + 1);	
	for i = 1:nfilterbanks
		start_filter = fft_bin(i);
		end_filter = fft_bin(i+1);
		for k=start_filter:end_filter
			filterbank(i,k) = (k - fft_bin(i))/(fft_bin(j+1)-fft_bin(j));
		end
		start_filter = fft_bin(i+1);
		end_filter = fft_bin(i+2);
		for k=start_filter:end_filter
			filterbank(i,k) = (fft_bin(i+2)-k)/(fft_bin(j+2)-fft_bin(j+1));
		end
	end
	
	frames_filtered = filterbank * frames_fft(1:(N/2+1),:);

	% Cepstrum. Converting back to time con DCT

end


% Devuelve M frames, con N samples por frame
% En la matriz frames, 1 frame por columna.
% See [5]
function frames=framing(signal, N, M)
	frames = zeros(N,M); 
	disp(N*M)
	disp(length(signal))
	for k=0:M-1
	    frames(:,k+1) = signal(1+N*k:N*(k+1));
	end
end

% Frecuency to mel scale [1]
function mel = hz2mel(f)
	return 1125*ln(1+f/700);
end

% Mel scale to frecuency [1]
function hz = mel2hz(mel)
	return 700*(exp(mel/1125));
end
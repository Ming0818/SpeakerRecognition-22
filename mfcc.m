%% References
%% [1] http://practicalcryptography.com/miscellaneous/machine-learning/guide-mel-frequency-cepstral-coefficients-mfccs/
%% [2] http://arxiv.org/pdf/1003.4083.pdf
%% [3] http://ijirae.com/volumes/vol1/issue10/27.NVEC10086.pdf
%% [4] An efficient mfcc extraction method in speech recognition - Han, Chan, Choy, Pun
%% [5] http://in.mathworks.com/matlabcentral/answers/24455-divide-audio-signal-into-frames

%% Para escuchar una señal con sound(), instalar octave-sound 
%% y mirar http://notesofaprogrammer.blogspot.com.ar/2014/09/audio-playing-and-recording-with-octave.html

function mfcc = mfcc(signal, fm)
	frame_step = 0.020;
	M = fm * frame_step; % 160 frames total	
	%overlap_cant = 0.5;
	%overlap = M*overlap_cant;
	%N = floor(length(signal)/overlap); % frame length (different for every signal)

	% Pre–emphasis filter. Reference [2]
	signal_emph(1)=signal(1);
	for n=2:length(signal)
		signal_emph(n)=signal(n)-0.97*signal(n-1);
	end
	
	% Framing. Reference [5]
	frames = framing(signal_emph,fm, frame_step, 0.01);
	
	% Windowing. Reference [2]
	%hamming_window = 0.54 - 0.46 * cos(2 * pi * [0 : N - 1].'/(N - 1));
	hamming_window = hamming(M); %Octave function
	frames_hamming=frames.*hamming_window;

	% FFT 
	for i = 1:size(frames_hamming)(2)
		frames_fft(:,i) = fft(frames_hamming(:, i));
	endfor
	
	for i = 1:size(frames_hamming)(2)
		abs_frames(:,i) = (abs(frames_fft(:,i)).^2);
	endfor

	% Mel-frequency Wrapping [1]

	% % Convert the upper and lower freq to Mels
	lower_freq = 300;
	upper_freq = fm/2; % 8000/2

	lower_freq = hz2mel(lower_freq);
	upper_freq = hz2mel(upper_freq);
	
	% % get X points between those mels
	nfilterbanks = 26;
	step = (upper_freq-lower_freq)/(nfilterbanks + 1);
	filter_points_mel =  lower_freq:step:upper_freq;
	%filter_rand_points = randperm(round(upper_freq-lower_freq), nfilterbanks).+ (lower_freq - 1);
	%filter_rand_points = sort(filter_rand_points);
	%filter_points_mel = [lower_freq, filter_rand_points, upper_freq];
	%disp(filter_points_mel)

	% % Convert points back to Hz
	filter_points_hz = arrayfun(@mel2hz, filter_points_mel);		

	% % Round frecuencys to the nearest FFT bin (we need nfft and sample rate = fm)
	nfft = M;
	fft_bin = floor((nfft+1)*filter_points_hz/fm);

	% % Create the filterbanks. The first filterbank will start at first point, peak at second, return to zero at 3rd.
	% % Second one, start at 2nd, reach max at 3rd, zero at 4th. And so on.
	filterbank = zeros(nfilterbanks, nfft/2+1); %nfft/2 +1 = 81 	

	for i = 1:nfilterbanks
		for k=fft_bin(i):fft_bin(i+1)
			filterbank(i,k) = (k - fft_bin(i))/(fft_bin(i+1)-fft_bin(i));
		end
		for k=fft_bin(i+1):fft_bin(i+2)
			filterbank(i,k) = (fft_bin(i+2)-k)/(fft_bin(i+2)-fft_bin(i+1));
		end
	end

	%filterbank=filterbanks(300,fm/2,33,256);
	frames_filtered = filterbank(:,1:(nfft/2+1)) * abs_frames(1:(nfft/2+1),:); %nfft/2 +1
	

	% Mel Frequency cepstrum [4]
	ncoef = 13; 
	for r=1:size(frames_hamming)(2)
		mfcc_aux(:,r)=melcoefs(frames_filtered(:,r),nfilterbanks, ncoef);
	end

	for k=1:size(frames_hamming)(2)
		mfcc_aux(ncoef,k) = logen(frames(:,k), M);
	end

	mfcc = mfcc_aux(:,:);

	mfcc = calculateDeltas(size(mfcc)(2), mfcc, 13);
	disp(size(mfcc))
end


function frames = framing(signal, fm, fd, fi)
	N = fd * fm;									% cantidad de muestras
	fstep = fi * fm;								% step entre cada una
	M = floor((length(signal) - N) / fstep + 1);
	
	indf = fstep * [ 0:(M-1) ];						% indices por frames      
    inds = [ 1:N ].';								% indices por muestra
    ind = indf(ones(N,1),:) + inds(:,ones(1,M));
	
	frames = signal(ind);
endfunction

% Devuelve M frames, con N samples por frame
% En la matriz frames, 1 frame por columna.
% Hay un overlap del 50%
function frames=fram(signal, N, M)
	%disp('framing')
	%disp(M)
	%disp(N)
	%disp(length(signal))
	frames = zeros(N,M); 
	overlap = floor(N/2);
	frame(:,1)=signal(1:N);
	%disp(1)
	%disp(N)
	strt = 1;
	final = N;
	for k=1:M-2
		aux1 = final-overlap;
		aux2 = aux1+N-1;
		if(k>M-10)
			%disp(' ')
			%disp(aux1)
			%disp(aux2)
			%disp(k)
			%disp(size(signal(aux1:aux2)))
			%disp(size(frames))
	    end
	    frames(:,k+1) = signal(aux1:aux2);
	    strt = aux1;
		final = aux2;
	end
end

% Frecuency to mel scale [4]
function mel = hz2mel(f)
	mel = 1127*log(1+f/700);
end

% Mel scale to frecuency 
function h = mel2hz(mel)
	h = 700*(10^(mel/2595.0)-1);
end
function speaker_recognition
	audio_files = readdir(strcat(pwd,'/resources/audio'));
	audio_cant = size(audio_files); 
	audio_speakers = audio_cant/3; % 3 audios per speaker

	disp('training');
	for i=3:audio_cant(1) % . and .. not included
		if mod(i,3)==0 % first audios for training
			audio = strcat('resources/audio/',char(audio_files(i)));
			[signal, fm] = wavread(audio);
			mfcc(signal,fm);
			%TODO: coeficientes mel-cepstrales estáticos y dinámicos
			%TODO: algoritmo de quantización vectorial, como vq(data, nvector)
		end
	end


	disp('testing');
	for i=3:audio_cant(1) % . and .. not included
		if mod(i,3)~=0 % all audios except training ones
			audio = strcat('resources/audio/',char(audio_files(i)));
			[y, s] = wavread(audio);
			%TODO: coeficientes mel-cepstrales estáticos y dinámicos
			%TODO: Buscar vectores que minimizen la distorción media, como con meandist(data,code)
		end
	end

	%TODO: efectividad del algoritmo
end
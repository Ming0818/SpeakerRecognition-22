function speaker_recognition
	audio_files = readdir(strcat(pwd,'/resources/audio'));
	audio_cant = size(audio_files); 
	audio_speakers = floor(audio_cant(1)/4); % 4 audios per speaker
	names = ['Eliana'; 'Esteban'; 'Juan Ignacio'; 'Juan Pablo'; 'Lautaro'; 'Maria';'Matias'; 'Mercedes'; 'Nicolas';'Pablo';'Paula'; 'Ricardo';'Sofia'];
	disp(['Total Speakers ',  num2str(audio_speakers)]);
	disp('training');
	fflush(stdout);
	for i=3:audio_cant(1) % . and .. not included
		if mod(i,4)==0 % first audios for training
			audio = strcat('resources/audio/',char(audio_files(i)));
			disp(audio)
			[signal, fm] = wavread(audio);
			coef = mfcc(signal,fm);
			coefvq(:, :, i-2) = vq(coef, 16);
			fflush(stdout);
		end
	end
	fflush(stdout);

	disp('testing');
	rights=0;
	for i=3:audio_cant(1) % . and .. not included
		if mod(i,4)~=0 % all audios except training ones
			file_name = char(audio_files(i));
			audio = strcat('resources/audio/',file_name);
			name = strtok(file_name, " ");
			disp(strcat('Analizing: ',audio));
			[s, f] = wavread(audio);
			coef = mfcc(s,fm);	

			for k=1:audio_speakers
				aux(k) = meandist(coef,coefvq(:,:,k));
			end
			[min_value,index] = min(aux);
			disp('min')
			disp(aux)
			fflush(stdout);
			disp(['Recognition: ',names(index,:)]);
			cmp = strcmp(name, names(index));
			if cmp==1
				rights+=1;
			end
		end
	end
	efectiv = rights / audio_speakers;
	disp(['Efectividad (entre 0 y 1):', num2str(efectiv)]);
end

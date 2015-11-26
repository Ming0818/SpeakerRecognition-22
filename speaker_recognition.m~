function speaker_recognition
	audio_files = readdir(strcat(pwd,'/resources/audio'));
	audio_cant = size(audio_files); 
	audio_speakers = audio_cant/4; % 4 audios per speaker
	names = ["Eliana", "Esteban", "Juan Ignacio","Juan Pablo", "Lautaro", "María","Matías", "Mercedez", "Nicolás","Pablo","Paula", "Ricardo","Sofía"];

	disp('training');
	for i=3:audio_cant(1) % . and .. not included
		if mod(i,4)==0 % first audios for training
			audio = strcat('resources/audio/',char(audio_files(i)));
			[signal, fm] = wavread(audio);
			coef = mfcc(signal,fm);
			%coefvq(:, :, i-2) = vq(coef, 16);
		end
	end


	disp('testing');
	rights=0;
	for i=3:audio_cant(1) % . and .. not included
		if mod(i,4)~=0 % all audios except training ones
			file_name = char(audio_files(i));
			audio = strcat('resources/audio/',file_name);
			name = strtok(file_name, " ");
			disp(strcat('Analizing: ',audio));
			[y, s] = wavread(audio);
			coef = mfcc(signal,fm);		
			%for k=1:audio_speakers
			%	aux(k) = meandist(coef,coefvq(k));
			%end
			%[min,index] = min(aux);
			%disp(strcat('Recognition: ',names[index]));
			%cmp = strcmp(name, names[index]);
			%if cmp==1
			%	rights+=1;
			%end
		end
	end
	
	%efectiv = rights / audio_speakers;
	%disp("Efectividad (entre 0 y 1):" + efectiv);
end

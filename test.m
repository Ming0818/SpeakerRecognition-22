
[s,fs] = wavread('./resources/audio/Eliana 1.wav');
coef = mfcc(s,fs);
disp('coef')
disp(coef)
%vecCode(:,:,i-2) = vq(coef, 16);
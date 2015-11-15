%% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%Parámetros de entrada:
%* fr = un frame en particular de la señal
%* frsize = tamaño del frame
%
%Parámetros de salida:
%* en = coeficiente número 13 del mfcc

function en = logen(fr, frsize)
	en = 0;
	for n = 1 : frsize
		en += fr(n) ** 2;
	endfor
	en = log(en);
endfunction



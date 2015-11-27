% Returns 13 mel-ceps coeficients for a particular frame.
% Reference:
% An efficient mfcc extraction method in speech recognition - Han, Chan, Choy, Pun
function mfcc = melcoefs(frame,nfilterbanks, ncoef)
	for n=1:(ncoef-1)
		c = 0;
		for j = 1: nfilterbanks
			if(frame(j,1)!=0)
				c+=log(frame(j,1))*cos(n*(j-0.5)*pi/nfilterbanks);		
			end
		end	
		mfcc(n) = c;
	end
	mfcc=mfcc';
end
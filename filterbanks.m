function fb = filterbanks(min,max,amount,fftsize)

  mmax = hz2mel(max);

  mmin = hz2mel(min);

  step = (mmax-mmin)/(amount+1);

  for k=1:amount+2
    num = (k-1)*step + mmin;
    f(k) = num;
    fm(k) = mel2hz(num);
    fb(k) = floor((fftsize+1)*fm(k)/(max*2));
  end

  fbank = zeros(amount,fftsize/2+1);

  for j=1:amount
      for i=fb(j):fb(j+1)
          fbank(j,i) = (i - fb(j))/(fb(j+1)-fb(j));
      end

      for i=fb(j+1):fb(j+2)
          fbank(j,i) = (fb(j+2)-i)/(fb(j+2)-fb(j+1));
      end
  end

  fb = fbank;
  fb;

end

function mel = hz2mel(f)
  mel = 1127*log(1+f/700);
end


% Mel scale to frecuency 
function h = mel2hz(mel)
  h = 700*(10^(mel/2595.0)-1);
end
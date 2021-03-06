% sNew = rebinAmpSpec(f, s, fNew)
%   rebin an amplitude spectrum s
%
% The same as rebinSpec, but for amplitude spectrum insetad
% of power spectrum. Take the square of the spectrum before doing the
% rebin, and then take the sqayre root after.



function sNew = resampleTF(f, s, fNew)
  
  s = s.^2; 
  sNew = sqrt(rebinSpec(f, s, fNew));
end
  
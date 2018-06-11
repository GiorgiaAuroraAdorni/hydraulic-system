%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                      T I M E  C O N S T A N T                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function RC = TimeConstant(F)
%
% F     square matrix F / poles vector p
%
% RC    return code
%       time constant
%
% by F. M. Marchese (2016)
%
% Tested under MatLab R2013b
%


function RC = TimeConstantLTI(F)
  RC = NaN;
  
  if nargin ~= 1 || isempty(F)
    fprintf('TimeConstantLTI: wrong parameter(s) number!\n');
    fprintf('Use: TimeConstantLTI(F)/TimeConstantLTI(p)\n');    
    return;
  end
  
  % Determinazione dei poli
  [rF, cF] = size(F);
  if rF == cF
    p = eig(F);
  elseif cf == 1
    p = F;
  else
    return;
  end
  if size(p, 1) < 1, return, end
  
  % Calcolo della costante di tempo dominante/pseudo-periodo massimo
  t   = 2 * pi ./ abs(imag(p));
  T   = max(t);               % (pseudo-) periodo di oscillazione

  absp = abs(real(p));
  if any(absp == 0)
    % si scartano i poli nulli
    for i = 1 : numel(absp)
      if absp(i) == 0, absp(i) = inf; end
    end
  end
  % costante di tempo dominante
  if isinf(min(absp)), Tau = inf; else Tau = 1 / min(absp); end 
  
  % Scelta della piu' appropriata costante
  if isinf(Tau) || isinf(T)
    T = min(Tau, T);
  else
    T = Tau;    % oppure T = max(Tau, T);
  end
  if isinf(T), T = 0.1; end   % clausola di salvaguardia contro l'infinito

  RC = T;
end
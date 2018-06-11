%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                            S T A B I L I T Y                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function RC = StabilityLTI(F)
%
% F     square matrix F / poles vector p
%
% RC    return code
%       -1.2  asymp. stable (osc.)
%       -1.1  asymp. stable
%        0.1  simply stable
%        0.2  simply stable (osc.)
%       +1.1  weakly unstable
%       +1.2  weakly unstable (osc.)
%       +2.1  strongly unstable
%       +2.2  strongly unstable (osc.)
%
% by F. M. Marchese (2016)
%
% Tested under MatLab R2013b
%


function RC = StabilityLTI(F)
  RC = NaN;
  
  if nargin ~= 1 || isempty(F)
    fprintf('StabilityLTI: wrong parameter(s) number!\n');
    fprintf('Use: StabilityLTI(F)/StabilityLTI(p)\n');    
    return;
  end
  
  % Determinazione degli Autovalori
  [rF, cF] = size(F);
  if rF == cF
    autoval = eig(F);
  elseif rF == 1 && cF > 1
    autoval = F';  
    F = diag(autoval);
  elseif cF == 1 && rF > 1
    autoval = F;
    F = diag(autoval);
  else
    return;
  end
  
  if any(isnan(autoval)), return, end

  % Calcolo degli Autovalori e delle molteplicita'
  autovalsz = size(autoval, 1);
  if autovalsz < 1, return, end

  k = 1;
  for i = 1 : autovalsz
    lambda = autoval(i);
    if isnan(lambda), continue, end

    % Ricerca piu' ripetizioni dell'autovalore
    idx1 = find(autoval == lambda);
    idx1sz = size(idx1, 1);

    % Ricerca eventuali coniugati
    idx2 = find(autoval == conj(lambda));
    idx2sz = size(idx2, 1);

    % Memorizza info sull'autovalore
    EIG.autoval(k) = lambda;  % autovalore
    EIG.ma(k)      = idx1sz;   % molteplicita' algebrica
    mg = autovalsz - rank(lambda * eye(autovalsz) - F);
    EIG.mg(k)      = mg;       % molteplicita' geometrica
    k = k + 1;

    % Marca come analizzati l'autovalore e il suo coniugato (if any)
    for j = 1 : idx1sz
      autoval(idx1(j)) = NaN;
    end
    for j = 1 : idx2sz
      autoval(idx2(j)) = NaN;
    end
  end


  % Valutazione del tipo di stabilita'

  % Se tutti gli autovalori hanno parte reale < 0 -> asint. stabile
  if all(real(EIG.autoval) <  0),     RC = -1.1;

  % Se almeno un autovalore ha parte reale > 0 -> instabilita' forte
  elseif any(real(EIG.autoval) >  0), RC = +2.1;

  % Se almeno un autovalore ha parte reale = 0 e molteplicita' geom. < alg., 
  % allora instabilita' debole;
  % in qualunque altro caso rimanente -> semplice stabilita'
  else % all(real(EIG.lambda) <= 0)
    RC = 0.1; % semplice stabilita' o ...
    for k = 1 : size(EIG.autoval, 2)
      if real(EIG.autoval(k)) == 0 
        if EIG.mg(k) < EIG.ma(k), RC = +1.1; end % ...instabilita' debole
      end
    end
  end

  % Se esistono delle coppie di autovalori complessi coniugati
  if any(imag(EIG.autoval) ~= 0), RC = RC + sign(RC) * 0.1; end
  
  RC = round(RC*10)/10;
end

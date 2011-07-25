function [results,opt,lentickle]...
                        = getEligoResults(f,inPower,DARMoffset,DARMsens, ifo)
    % produces an eLIGO lentickle results structure
    %
    % results = getEligoResults(inPower,DARMoffset,DARMsens)

    if nargin < 4 % default DARMsens value
        DARMsens = 'omc';
    end
    if DARMoffset == 0
        DARMsens = 'asq';
        warning('zero DARM offset --> using RF detection');
        DARMoffset = 0.1e-12; % RMS
    end
    
    if nargin < 5
        ifo = 'H1';
        warning('getEligoResults: defaulting to H1 interferometer');
    end    
    
    switch ifo
        case 'H1'
            par = paramH1;
        case 'L1'
            par = paramL1;
        otherwise
            error('unknown ifo');
    end
    
    par = setPower(par,inPower);
    par = paramEligo_00(par);
    opt = optEligo(par);
    opt = probesEligo_00(opt, par);

    posOffset = sparse(zeros(opt.Ndrive,1));
    posOffset(getDriveIndex(opt,'EX')) =  DARMoffset/2;
    posOffset(getDriveIndex(opt,'EY')) = -DARMoffset/2;
    
    % phase eligo
    
    opt = phaseEligo(opt,posOffset);
    
    lentickle = lentickleEligo(opt, DARMsens, ifo);
    
    % get loop calculations
    results = lentickleEngine(lentickle,posOffset,f);
    results.f = f;
    
    % decorate the result so we know where it came from
    metadata = struct();
    metadata.x0 = DARMoffset;
    metadata.DARMsense = DARMsens;
    metadata.ifo = ifo;
    
    results.metadata = metadata;
    results.lentickle = lentickle;
    results.opt = opt;
    results.ifo = ifo;    
end
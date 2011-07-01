function [results,opt,lentickle]...
                        = getEligoResults(f,inPower,DARMoffset,DARMsens, ifo)
    % produces an eLIGO lentickle results structure
    %
    % results = getEligoResults(inPower,DARMoffset,DARMsens)

    if nargin < 4 % default DARMsens value
        DARMsens = 'omc';
    end
    
    if nargin < 5
        ifo = 'H1';
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
    % tickle
    %[fDC,sigDC,sigAC,mMech] = tickle(lentickle.opt,posOffset,f);     
    
    % get loop calculations
    results = lentickleEngine(lentickle,posOffset,f);%,sigAC,mMech);
    
end
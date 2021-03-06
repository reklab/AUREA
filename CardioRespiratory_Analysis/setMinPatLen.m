function [seqOut] = setMinPatLen (seqIn, minPatternLen)
% set minimum pattern length for a sequence
%   Detailed explanation goes here
%Input:
% seqIn - input categorical sequence
% minPAtternLen - minimumpatternlength in samples
%
% seqOut - sequence with minimumn patter length
% Change type of patterns with length <  MinPattLength based on preceeding
% and following sequences
% input must be a vcategorical vector of a cell  array of categorical
% vetors. 
% If input is cell array returns a cell array of cateogrical variables; 
if iscell(seqIn),
    nCase=length(seqIn);
    for iCase=1:nCase,
        seqOut{iCase,1}=setMinPatLen (seqIn{iCase}, minPatternLen);
    end
else
    
    if isnumeric(seqIn),
        tmpScores=pseq2cseq(seqIn);
    else
        tmp_scores=seqIn;
    end
    tmp_scores=addcats(tmp_scores,'SHORT');
    E=cseq2eseq(seqIn, 1);
    iShort=find([E.length]<minPatternLen); % Point to events shorter than min PatternLen
    for i=1:length(iShort),
        E(iShort(i)).type='SHORT';
    end
    T=eseq2cseq(E);  % Convert to signal
    E =cseq2eseq(T);  % Convert back to events concatonting SHORT events
    AuxZeros=find([E.type]=='SHORT');
    eShort=E(AuxZeros); % pointer to short events
    T=eseq2cseq(E);
    ; % Pointer to type 
    % Convert to  a signal
    ixSt=1;
    ixEn=length(eShort);
    if ixEn>0
        % First event is "SHORT"
        if eShort(1).start==1
            T(eShort(1).start:eShort(1).end)=T(eShort(1).end+1);
            ixSt=ixSt+1;
        end
        if eShort(end).end==length(seqIn) % do nothing if the last short sefment is at the end.
             T(eShort(end).start:eShort(end).end)=T(eShort(end).start-1);
            ixEn=ixEn-1;
        end
        for jndex=ixSt:ixEn
            prev=eShort(jndex).start-1; % index of preceeding event
            next=eShort(jndex).end+1;  % index of folllowing event
            midp=floor((prev+next)/2); % Midpoint of short index
            T(prev+1:midp)=T(prev);
            T(midp+1:next)=T(next);            
        end
    end
seqOut=removecats(T,'SHORT');
end
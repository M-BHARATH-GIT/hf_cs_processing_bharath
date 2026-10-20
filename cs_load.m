function CSL = cs_load(flist,ftimes,rtime,tau,CSL)
% CS LOAD - load CS data into a buffer for DOA processing
%
% CSL = cs_load(flist,ftimes,rtime,tau,CSL)
%
% Loads the CS files falling within +/- tau/2 of rtime.
% The function maintains CSL as a rolling collection of CS structures.
%
% Modified to safely initialize an empty CSL using the structure returned
% by cs_read/load_by_type. Original toolbox behavior is otherwise retained.
%
% Copyright(C) 2017 Brian Emery
%

if tau == 0, keyboard, end


%% Get list of files already in the struct

if isempty(CSL)
    inlist = {}; 
else
    inlist = {CSL.FileName}';
end


%% Find files that should be in the average

cx = find( ftimes >= ( rtime - tau/(2*1440) ) & ...
           ftimes <= ( rtime + tau/(2*1440) ) );


%% Get list of files to remove from CSL

rmlist = setdiff(inlist,flist(cx));


%% Find files to add

addlist = setdiff(flist(cx),inlist);


%% Load new data

if ~isempty(addlist)

    % CSL must have the same fields as a loaded CS structure.
    % If CSL is empty, load the first required file as a template,
    % then create a zero-length struct with identical fields.
    if isempty(CSL)
        CS0 = load_by_type(addlist{1});
        CSL = repmat(CS0,0,1);
    end

    for i = 1:numel(addlist)
        CSL(end+1) = load_by_type(addlist{i});
    end

end


%% Remove data not needed for the current averaging window

if isempty(CSL)
    % Nothing was loaded for this time window.
    CSL = CSL([]);
else
    CSL = CSL( ~ismember({CSL.FileName}',rmlist) );
end


end


function CS = load_by_type(fname)

[~,~,ext] = fileparts(fname);

if strcmp('.cs',ext)

    CS = cs_read(fname);

elseif strcmp('.mat',ext)

    CS = load(fname,'CS');
    CS = CS.CS;

end

end


function CS = cs_mv_average(CS,CSn,CSrm)
% CS MV AVERAGE
%
% Local code for maintaining a running average.

n = CS.N;

fn = {'antenna1Self', 'antenna2Self', 'antenna3Self', ...
      'antenna12CrossSp','antenna13CrossSp','antenna23CrossSp'};

m = numel(CSrm);
p = numel(CSn);

for i = 1:numel(fn)

    CS.(fn{i}) = CS.(fn{i}).*n;

    for j = 1:m
        CS.(fn{i}) = CS.(fn{i}) - CSrm(j).(fn{i});
    end

    for k = 1:p
        CS.(fn{i}) = CS.(fn{i}) + CSn(k).(fn{i});
    end

    CS.(fn{i}) = CS.(fn{i})./(n-m+p);
end

CS.N = n-m+p;

try
    CS.Header = CSn(end).Header;
catch
end

end


function get_averaging_setup
% OBSOLETE - retained from original toolbox.
keyboard
end

function saveStatData
global CT
global SS
global CB
global selected
global CBCB
global fd_data
global RadoncID

fn_data = [RadoncID{1}, '_StatData_', SS.sNames{selected.idxSS}];
ffn = fullfile(fd_data, RadoncID{1}, fn_data);

statData = CBCB;
statInfo.date = CB.dateCreated;
statInfo.machine = CB.machineName;
statInfo.sliceNo = CB.ind;
statInfo.isoSlice = CT.idx_iso;

save(ffn, 'statData', 'statInfo')
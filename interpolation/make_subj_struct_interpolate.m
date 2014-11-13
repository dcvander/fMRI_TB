function[X]=make_subj_struct_interpolate(folder)

% this function interpolates the TS and makes a subject structure X in the
% right format for the graph theory fmriTB_v1 pipeline by analyzing a 
% specific folder containing one .txt file per subject and appending each 
% to a cell of X.
% you only need to specify the folder location in the function argument!

% WARNING: there cannot be other .txt files; they will mess up the resulting file.
% created by Davy Vanderweyen

cd(folder);                                            % go into putative folder
files=dir('*.txt');                                    % put all .csv files in a cell array
l=length(files);                                       % evaluate the number of subjects
X=cell(1,l);                                           % create a cell array of the same length as there are subjects
for i=1:l
    s=files(i).name;                                   % set up a variable equal to a string
    [token,remain]=strtok(s,'.');                      % use it to separate the subject ID from the file extension
    clear(remain);                                     % nothing useless will remain
    X{i}.ID=token;                                     % append subject name to appropriate cell
    interpolatedTS=interpolateTS(files(i).name);       % import and interpolate data
    X{i}.TS=interpolatedTS;                            % append data to subj structure
    X{i}.Nodes=length(X{i}.TS);                        % append the number of nodes to the subj structure
end

end
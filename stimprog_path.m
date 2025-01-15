function [stimprogdir] = stimprog_path()
%STIMPROG_PATH Returns the path of the StimProg directory, to use to form
%other paths as needed
filename = mfilename("fullpath");
idxs = strfind(filename, filesep);
stimprogdir = filename(1:idxs(end)-1);
end


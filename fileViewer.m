function varargout = fileViewer(varargin)
% FILEVIEWER M-file for fileViewer.fig
%      FILEVIEWER, by itself, creates a new FILEVIEWER or raises the existing
%      singleton*.
%
%      H = FILEVIEWER returns the handle to a new FILEVIEWER or the handle to
%      the existing singleton*.
%
%      FILEVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILEVIEWER.M with the given input arguments.
%
%      FILEVIEWER('Property','Value',...) creates a new FILEVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fileViewer_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fileViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help fileViewer

% Last Modified by GUIDE v2.5 19-Aug-2010 15:31:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fileViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @fileViewer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before fileViewer is made visible.
function fileViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fileViewer (see VARARGIN)

% Choose default command line output for fileViewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fileViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fileViewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in fileButton.
function fileButton_Callback(hObject, eventdata, handles)
% hObject    handle to fileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[input_file,pathname] = uigetfile( ...
    {'*.bin', 'Binary (*.bin)'; ...
    '*.*', 'All Files (*.*)'}, ...
    'Select files');

%if file selection is cancelled, pathname should be zero
%and nothing should happen
if pathname == 0
    return
end
cd(pathname);

%gets the current data file names inside the listbox
inputFileNames = '' % get(handles.fileListbox,'String');

%if they only select one file, then the data will not be a cell
%if more than one file selected at once,
%then the data is stored inside a cell
if iscell(input_file) == 0

    %add the most recent data file selected to the cell containing
    %all the data file names
    inputFileNames{end+1} = fullfile(pathname,input_file);

    %else, data will be in cell format
else
    %stores full file path into inputFileNames
    for n = 1:length(input_file)
        %notice the use of {}, because we are dealing with a cell here!
        inputFileNames{end+1} = fullfile(pathname,input_file{n});
    end
end

%updates the gui to display all filenames in the listbox
%set(handles.fileListbox,'String',inputFileNames);
handles.files = inputFileNames;

% PLOT
axes(handles.axes1)
fid = fopen(inputFileNames{1});
data = fread(fid, 10000, 'int16', 'l');
plot(data)
fclose all        


% Update handles structure
guidata(hObject, handles);


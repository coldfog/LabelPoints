function varargout = labelPoint(varargin)
% LABELPOINT MATLAB code for labelPoint.fig
%      LABELPOINT, by itself, creates a new LABELPOINT or raises the existing
%      singleton*.
%
%      H = LABELPOINT returns the handle to a new LABELPOINT or the handle to
%      the existing singleton*.
%
%      LABELPOINT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LABELPOINT.M with the given input arguments.
%
%      LABELPOINT('Property','Value',...) creates a new LABELPOINT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before labelPoint_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to labelPoint_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help labelPoint

% Last Modified by GUIDE v2.5 08-Aug-2013 12:19:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @labelPoint_OpeningFcn, ...
                   'gui_OutputFcn',  @labelPoint_OutputFcn, ...
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


% --- Executes just before labelPoint is made visible.
function labelPoint_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to labelPoint (see VARARGIN)

% Choose default command line output for labelPoint
handles.output = hObject;

% The default result output file
handles.DEFAULT_CONFIG_NAME = 'config.mat';
handles.DEFAULT_RESULT_NAME = 'result.mat';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes labelPoint wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function saveData(hObject, handles)
saveFoldereName = handles.folderName;
saveFileNames = handles.fileNames;
saveFileIndex = handles.fileIndex;
savePts = handles.pts;
save(fullfile(handles.folderName, handles.DEFAULT_CONFIG_NAME), 'saveFoldereName', 'saveFileNames', 'saveFileIndex', 'savePts');


function saveResult(hObject, handles)
result = handles.result;
save(fullfile(handles.folderName, handles.DEFAULT_RESULT_NAME), 'result');

% --- Outputs from this function are returned to the command line.
function varargout = labelPoint_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnRevoke.
function btnRevoke_Callback(hObject, eventdata, handles)
% hObject    handle to btnRevoke (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.pts = handles.pts(1:end-1, :);
guidata(hObject, handles);
updateStaticText(hObject, handles);
update_PointOnLoc(0, 0, hObject, handles);


% --- Executes on button press in btnConfirm.
function btnConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to btnConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.result(handles.fileIndex).I = imread(fullfile(handles.folderName,handles.fileNames{handles.fileIndex}));
handles.result(handles.fileIndex).Points = handles.pts;
guidata(hObject, handles);
saveResult(hObject, handles);


% --- Executes on button press in btnNext.
function btnNext_Callback(hObject, eventdata, handles)
% hObject    handle to btnNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.result(handles.fileIndex).I = imread(fullfile(handles.folderName,handles.fileNames{handles.fileIndex}));
handles.result(handles.fileIndex).Points = handles.pts;
saveResult(hObject, handles);
handles.fileIndex = handles.fileIndex + 1;
if size(handles.result, 2) >= handles.fileIndex
    handles.pts = handles.result(handles.fileIndex).Points;
else
    handles.pts = zeros(0);
end
if handles.fileIndex == 2
    set(handles.btnPrevious, 'Enable', 'on');
end
if handles.fileIndex == size(handles.fileNames, 2)
    set(handles.btnNext, 'Enable', 'off');
end
guidata(hObject, handles);
updateStaticText(hObject, handles);
update_PointOnLoc(0, 0, hObject, handles);


% --- Executes on button press in btnPrevious.
function btnPrevious_Callback(hObject, eventdata, handles)
% hObject    handle to btnPrevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.result(handles.fileIndex).I = imread(fullfile(handles.folderName,handles.fileNames{handles.fileIndex}));
handles.result(handles.fileIndex).Points = handles.pts;
saveResult(hObject, handles);
handles.fileIndex = handles.fileIndex - 1;
if handles.fileIndex == 1
    set(handles.btnPrevious, 'Enable', 'off');
end
if handles.fileIndex == size(handles.fileNames, 2) -1
    set(handles.btnNext, 'Enable', 'on');
end
handles.pts = handles.result(handles.fileIndex).Points;
guidata(hObject, handles);
updateStaticText(hObject, handles);
update_PointOnLoc(0, 0, hObject, handles);



% --- Executes on mouse press over axes background.
function axesArea_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axesArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%plot(pt(1,1), pt(1,2), '.');
%hold on;

function draw_PointOnLoc(src, event, hObject, handles)
axes_handle = gca;
pt = get(axes_handle, 'CurrentPoint');
x = xlim;
y = ylim;
if pt(1,1) >= x(1) && pt(1,1) <= x(2) && pt(1,2) >= y(1) && pt(1,2) <= y(2)
    handles.pts = [handles.pts; pt(1,1:2)];
    guidata(hObject, handles);
    update_PointOnLoc(src, event, hObject, handles);
    updateStaticText(hObject, handles);
end

function update_PointOnLoc(src, event, hObject, handles)
%set(h,'Marker','.','MarkerFaceColor','y');
imshow(fullfile(handles.folderName,handles.fileNames{handles.fileIndex}));
if size(handles.pts, 1) ~= 0
    hold on;
    plot(handles.pts(:, 1), handles.pts(:, 2), '.');
end
set(gcf, 'WindowButtonDownFcn', {@draw_PointOnLoc, hObject, handles});


% --- Executes during object creation, after setting all properties.
function axesArea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axesArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axesArea




function edtFolderName_Callback(hObject, eventdata, handles)
% hObject    handle to edtFolderName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtFolderName as text
%        str2double(get(hObject,'String')) returns contents of edtFolderName as a double


% --- Executes during object creation, after setting all properties.
function edtFolderName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtFolderName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnOpen.
function btnOpen_Callback(hObject, eventdata, handles)
% hObject    handle to btnOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Initialize the data
folder = get(handles.edtFolderName, 'string');
if exist(folder, 'file') == 0
    set(handles.edtFolderName, 'String', 'Folder not exist');
    return
end
config_folder = fullfile(folder, handles.DEFAULT_CONFIG_NAME);
result_folder = fullfile(folder, handles.DEFAULT_RESULT_NAME);
if exist(config_folder, 'file') ~= 0
    load(config_folder);
    handles.folderName = saveFoldereName;
    handles.fileNames = saveFileNames;
else
    handles.folderName = folder;
    handles.fileNames = {};
    temp = dir(handles.folderName);
    j = 1;
    for i=1:size(temp)
        if temp(i).isdir == 0 && size(regexpi(temp(i).name, '.*\.(jpg|png|gif|bmp)'), 2) ~= 0
            handles.fileNames{j} = temp(i).name;
            j = j + 1;
        end
    end
%pointsNum = str2double(get(handles.edtPointsNum, 'String'));
end

if exist(result_folder, 'file') ~=0
    load(result_folder);
    handles.result = result;
else
    handles.result = struct;
    handles.result(1).Points = zeros(0);
end
handles.fileIndex = 1;
if size(handles.result, 2) >= handles.fileIndex
    handles.pts = handles.result(handles.fileIndex).Points;
else
    handles.pts = zeros(0);
end

guidata(hObject, handles);

updateStaticText(hObject, handles);
update_PointOnLoc(0, 0, hObject, handles);
set(gcf, 'WindowButtonDownFcn', {@draw_PointOnLoc, hObject, handles});


function updateStaticText(hObject, handles)
set(handles.edtFileIndex, 'String', sprintf('%d', handles.fileIndex));
set(handles.txtImagesNum, 'String', sprintf('/%d', size(handles.fileNames, 2)));
set(handles.txtPointsNum, 'String', sprintf('%d', size(handles.pts, 1)));
set(handles.txtFileName, 'String', handles.fileNames{handles.fileIndex});


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);



function edtFileIndex_Callback(hObject, eventdata, handles)
% hObject    handle to edtFileIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtFileIndex as text
%        str2double(get(hObject,'String')) returns contents of edtFileIndex as a double

handles.result(handles.fileIndex).I = imread(fullfile(handles.folderName,handles.fileNames{handles.fileIndex}));
handles.result(handles.fileIndex).Points = handles.pts;
saveResult(hObject, handles);

fileIndex = str2double(get(hObject,'String'));
if isnan(fileIndex)
    set(hObject, 'String', num2str(handles.fileIndex));
    return
end
handles.fileIndex = fileIndex;
if size(handles.result, 2) >= handles.fileIndex
    handles.pts = handles.result(handles.fileIndex).Points;
else
    handles.pts = zeros(0);
end
if handles.fileIndex == 2
    set(handles.btnPrevious, 'Enable', 'on');
end
if handles.fileIndex == size(handles.fileNames, 2)
    set(handles.btnNext, 'Enable', 'off');
end
guidata(hObject, handles);
updateStaticText(hObject, handles);
update_PointOnLoc(0, 0, hObject, handles);


% --- Executes during object creation, after setting all properties.
function edtFileIndex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtFileIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

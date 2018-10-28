function varargout = myTest(varargin)
% MYTEST MATLAB code for myTest.fig
%      MYTEST, by itself, creates a new MYTEST or raises the existing
%      singleton*.
%
%      H = MYTEST returns the handle to a new MYTEST or the handle to
%      the existing singleton*.
%
%      MYTEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYTEST.M with the given input arguments.
%
%      MYTEST('Property','Value',...) creates a new MYTEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before myTest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to myTest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help myTest

% Last Modified by GUIDE v2.5 30-Nov-2016 09:37:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @myTest_OpeningFcn, ...
                   'gui_OutputFcn',  @myTest_OutputFcn, ...
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



% --- Executes just before myTest is made visible.
function myTest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to myTest (see VARARGIN)

he = imread('football.jpg');
he=im2double(he);
he=imresize(he,0.2);
axes(handles.axes1);
imshow(he);
handles.he = he;

%surf(handles.current_data);
% Choose default command line output for myTest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes myTest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = myTest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnSelectImg.
function btnSelectImg_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelectImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
he = getImage();
axes(handles.axes1);
imshow(he);
handles.he = he;
guidata(hObject, handles);



% --- Executes on button press in btnStart.
function btnStart_Callback(hObject, eventdata, handles)
% hObject    handle to btnStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set disabled
% set(handles.menuSelectN, 'Enable', 'off');
% set(handles.menuSelectNPoint, 'Enable', 'off');

he = handles.he;
[m,n,~]=size(he);
rgb=median(median(he));
img=ones(m,n,3);
img(:,:,1)=img(:,:,1)*rgb(1);
img(:,:,2)=img(:,:,2)*rgb(2);
img(:,:,3)=img(:,:,3)*rgb(3);
dis=norm(sum(abs(he-img),3)); % distance between the loaded image and generated img

% set max number of polygons
list1 = get(handles.menuSelectN, 'String');
val1 = get(handles.menuSelectN, 'Value');
maxPoly = str2num(list1{val1});
maxPoly = int32(maxPoly);
maxPoly = maxPoly(1);

% set max number of points in a polygon
list2 = get(handles.menuSelectNPoint, 'String');
val2 = get(handles.menuSelectNPoint, 'Value');
maxPoint = str2num(list2{val2});
maxPoint = int32(maxPoint);
maxPoint = maxPoint(1);

% set max number and mutation probability of points in all polygons
maxTotal = get(handles.maxTotalP, 'String');
maxTotal = str2double(maxTotal);
maxTotal = int32(maxTotal);
curTotal = 0;
list3 = get(handles.muPoint, 'String');
val3 = get(handles.muPoint, 'Value');
muPoint = str2num(list3(val3));
muPoint = int32(muPoint);
muPoint = muPoint(1);

% set the max and min and mutation probability of transparency
maxTrans = get(handles.editMaxTrans, 'String');
maxTrans = str2double(maxTrans);
minTrans = get(handles.editMinTrans, 'String');
minTrans = str2double(minTrans);
muTrans = get(handles.muTrans, 'String');
muTrans = str2double(muTrans);

% set the mutation of the color
muColor = get(handles.muColor, 'String');
muColor = str2double(muColor);

% set gerneration interval
list4 = get(handles.generationNo, 'String');
val4 = get(handles.generationNo, 'Value');
if val4 < 2
    generationNo = 500;
else
    generationNo = 1000;
end
% generationNo = str2num(list4(val4));
% generationNo = int32(generationNo);
% generationNo = generationNo(1);

if ~(minTrans >=0 && minTrans <= 1 && maxTrans >=0 && minTrans<= 1 && minTrans <= maxTrans)
    h = errordlg('Please input valid transprency domain!');
%     set(handles.editMinTrans, 'Enable', 'on');
%     set(handles.editMaxTrans, 'Enable', 'on');
elseif (muTrans < 0 || muTrans > 1)
    h = errordlg('Please input valid transprency mutation rate!');
elseif (muColor < 0 || muColor > 1)
    h = errordlg('Please input valid color mutation rate!');
else
    % set the factor
    numV = 0;
    x1 = [];
    y1 = [];
    rgb1 = [];
    alpha1 = 0;
    numV1 = 0;
    % set the first poly
    count = 0;
    store = [];
    axes(handles.axes2);
    for i=1:maxPoly
        numV1=randi(maxPoint - 2)+2; %The number of vertex should at least 3
        x1=randi(n,[numV1,1]);y1=randi(m,[numV1,1]); % randomly set vertex of polygon
        rgb1=rand(3,1); % randomly set color
        [imgpoly,mask]=getImgPloy(m,n, x1,y1, rgb1); % get the image of polygon and the mask
        alpha1=rand*(maxTrans - minTrans) + minTrans; % randomly generate the alpha rate
        img1=fuseImg(img,imgpoly,mask,alpha1); % fuse the polygon into image to get a new image
        dis1=norm(sum(abs(he-img1),3)); % the distance between the new image and the loaded image
        if dis1<dis; % if distance is smaller, add the polygon, otherwise do nothing
            img=img1;
            dis=dis1;
            curTotal = numV1;
            break;
        end
        count = count + 1;
    end
    numPoly = 1;

    for j=count:maxPoly
        %rng('shuffle');
        % set the number of the points in a poly
        % numV2=randi(maxPoint - 2)+2; %The number of vertex should at least 3
        % check the current number of total points
        if curTotal > maxTotal 
            break;
        end
        % randomly set vertex of polygon
        [x2, y2, numV2] = ESUpdatePoint(numV1, maxPoint, x1, y1, n, m, muPoint);
        % update the color
        rgb2 = ESUpdateColor(rgb1, muColor);
        % get the image of polygon and the mask
        [imgpoly,mask]=getImgPloy(m,n, x2,y2, rgb2);
        % transparency of polygon
        alpha2 = ESUpdateTrans(alpha1, minTrans, maxTrans, muTrans);
        % fuse the polygon into image to get a new image
        img1=fuseImg(img,imgpoly,mask,alpha2);
        % the distance between the new image and the loaded image
        dis1=norm(sum(abs(he-img1),3)); 
        % if distance is smaller, add the polygon, otherwise backward all the parameter
        if dis1<dis; 
            img=img1;
            dis=dis1;
            curTotal = curTotal + numV2;
            x1 = x2;
            y1 = y2;
            numV1 = numV2;
            rgb1 = rgb2;
            alpha1 = alpha2;
            numPoly = numPoly + 1;
        end
        if mod(j,generationNo) == 0
            imshow(img);
            pause(0.001);
            disp('generation No.');
            disp(j);
            disp('fitness function value: ');
            disp(dis);
            disp('the number of polygons: ');
            disp(numPoly);
            disp('the total points: ');
            disp(curTotal);
            store = [store; j dis numPoly curTotal];
            
        end
    end
    %axes(handles.axes2);
    %save afile.text - ascii data;
    imshow(img);
    filename = ['ESData_'  datestr(now)];
    filename(find(isspace(filename))) = [];
    filename(strfind(filename,':')) = [];
    filename(strfind(filename,'-')) = [];
    save(filename, 'store');
end
% set(handles.menuSelectN, 'Enable', 'on');
% set(handles.menuSelectNPoint, 'Enable', 'on');
% set(handles.editMinTrans, 'Enable', 'on');
% set(handles.editMaxTrans, 'Enable', 'on');




% --- Executes on key press with focus on btnStart and none of its controls.
function btnStart_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to btnStart (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in menuSelectN.
function menuSelectN_Callback(hObject, eventdata, handles)
% hObject    handle to menuSelectN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuSelectN contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuSelectN


% --- Executes during object creation, after setting all properties.
function menuSelectN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuSelectN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menuSelectNPoint.
function menuSelectNPoint_Callback(hObject, eventdata, handles)
% hObject    handle to menuSelectNPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuSelectNPoint contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuSelectNPoint


% --- Executes during object creation, after setting all properties.
function menuSelectNPoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuSelectNPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMinTrans_Callback(hObject, eventdata, handles)
% hObject    handle to editMinTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMinTrans as text
%        str2double(get(hObject,'String')) returns contents of editMinTrans as a double


% --- Executes during object creation, after setting all properties.
function editMinTrans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMinTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMaxTrans_Callback(hObject, eventdata, handles)
% hObject    handle to editMaxTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMaxTrans as text
%        str2double(get(hObject,'String')) returns contents of editMaxTrans as a double


% --- Executes during object creation, after setting all properties.
function editMaxTrans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMaxTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxTotalP_Callback(hObject, eventdata, handles)
% hObject    handle to maxTotalP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxTotalP as text
%        str2double(get(hObject,'String')) returns contents of maxTotalP as a double


% --- Executes during object creation, after setting all properties.
function maxTotalP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxTotalP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function muColor_Callback(hObject, eventdata, handles)
% hObject    handle to muColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of muColor as text
%        str2double(get(hObject,'String')) returns contents of muColor as a double


% --- Executes during object creation, after setting all properties.
function muColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to muColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in muPoint.
function muPoint_Callback(hObject, eventdata, handles)
% hObject    handle to muPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns muPoint contents as cell array
%        contents{get(hObject,'Value')} returns selected item from muPoint


% --- Executes during object creation, after setting all properties.
function muPoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to muPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function muTrans_Callback(hObject, eventdata, handles)
% hObject    handle to muTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of muTrans as text
%        str2double(get(hObject,'String')) returns contents of muTrans as a double


% --- Executes during object creation, after setting all properties.
function muTrans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to muTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in generationNo.
function generationNo_Callback(hObject, eventdata, handles)
% hObject    handle to generationNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns generationNo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from generationNo


% --- Executes during object creation, after setting all properties.
function generationNo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to generationNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

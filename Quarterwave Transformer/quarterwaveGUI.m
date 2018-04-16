function varargout = quarterwaveGUI(varargin)
%QUARTERWAVEGUI M-file for quarterwaveGUI.fig
%      QUARTERWAVEGUI, by itself, creates a new QUARTERWAVEGUI or raises the existing
%      singleton*.
%
%      H = QUARTERWAVEGUI returns the handle to a new QUARTERWAVEGUI or the handle to
%      the existing singleton*.
%
%      QUARTERWAVEGUI('Property','Value',...) creates a new QUARTERWAVEGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to quarterwaveGUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      QUARTERWAVEGUI('CALLBACK') and QUARTERWAVEGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in QUARTERWAVEGUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help quarterwaveGUI

% Last Modified by GUIDE v2.5 16-Apr-2018 01:34:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @quarterwaveGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @quarterwaveGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before quarterwaveGUI is made visible.
function quarterwaveGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
    % Create the data to plot.
    %clc;
    Z0_init = 50;
    R_Loadinit = 50;
    handles.data.Rload = Z0_init;
    handles.data.Z0 = R_Loadinit;
    RefreshData(hObject, eventdata, handles);
    
        
    handles.loadSlider.Value = handles.data.Rload/handles.data.Z0;
    handles.RLoad_Text.String = ['R Load = ',num2str(handles.data.Rload),'ohm'];
    % Save the handles structure.
    guidata(hObject,handles);
    

    % Choose default command line output for quarterwaveGUI
    handles.output = hObject;
    % Save the handles structure.
    guidata(hObject,handles);


    % UIWAIT makes quarterwaveGUI wait for user response (see UIRESUME)
    %uiwait(handles.figure1);

    
% --- Outputs from this function are returned to the command line.
function varargout = quarterwaveGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
    varargout{1} = handles.data;



% --- Executes on slider movement.
function loadSlider_Callback(hObject, eventdata, handles)
% hObject    handle to loadSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.data.Rload = hObject.Value * handles.data.Z0;
    handles.RLoad_Text.String = ['R Load = ',num2str(handles.data.Rload),'ohm'];
    
    % Save the handles structure.
    guidata(hObject,handles);
    RefreshData(hObject, eventdata, handles);
        


% --- Executes during object creation, after setting all properties.
function loadSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loadSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end


% --- Executes on button press in output_to_workspace_btn.
function output_to_workspace_btn_Callback(hObject, eventdata, handles)
% hObject    handle to output_to_workspace_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    assignin('base','GUIDataOut', handles.data);
    disp('Data saved to GUIDataOut');
    % Save the handles structure.
    guidata(hObject,handles);
    RefreshData(hObject, eventdata, handles);



% --- Executes on selection change in Z0_feedLine1.
function Z0_feedLine1_Callback(hObject, eventdata, handles)
% hObject    handle to Z0_feedLine1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    str = get(hObject, 'String');
    val = get(hObject,'Value');
    Z0 = str2num(str{val});

    handles.data.Z0 = Z0;
    handles.data.Rload = handles.loadSlider.Value * handles.data.Z0;
    handles.RLoad_Text.String = ['R Load = ',num2str(handles.data.Rload),'ohm'];
    
    % Save the handles structure.
    guidata(hObject,handles);
    RefreshData(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function Z0_feedLine1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Z0_feedLine1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function RefreshData(hObject, eventdata, handles)
    % hObject    handle to ImageHelp (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    [ff0,Zin,gamma_abs,SWR] = func_quarterwave(handles.data.Z0, handles.data.Rload);
    
    handles.data.ff0 = ff0;
    handles.data.Zin = Zin;
    handles.data.gammaABS = gamma_abs;
    handles.data.SWR = SWR;
    
    % Save the handles structure.
    guidata(hObject,handles);
    CreatePlots(hObject, eventdata, handles);
      
    
    
function CreatePlots(hObject, eventdata, handles)
    % hObject    handle to ImageHelp (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    plot(handles.gammaPlot, handles.data.ff0,handles.data.gammaABS);
    handles.gammaPlot.YLim = [0 1];
    handles.gammaPlot.YLimMode = 'manual';
    title(handles.gammaPlot,'Quarter Wave Match - SWR');
    ylabel(handles.gammaPlot,'|\Gamma|');
    xlabel(handles.gammaPlot,'f/f0');

    %plot(handles.gammaPlot, handles.data.ff0,handles.data.gammaABS);
    plot(handles.SWRPlot, handles.data.ff0,handles.data.SWR);                
    ylim(handles.SWRPlot,[1 inf]);
    title(handles.SWRPlot,'Quarter Wave Match - SWR');
    ylabel(handles.SWRPlot,'SWR');
    xlabel(handles.SWRPlot,'f/f0');

    
    
function figure1_CloseRequestFcn(hObject, eventdata, handles)
    % hObject    handle to ImageHelp (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    if isequal(get(hObject, 'waitstatus'), 'waiting')
        % The GUI is still in UIWAIT, us UIRESUME
        uiresume(hObject);
    else
        % The GUI is no longer waiting, just close it
        delete(hObject);
    end


% --- Executes during object creation, after setting all properties.
function Image1Line_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to Image1Line (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    image(imread('QuarterWavePNG.PNG') );
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);


% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to text4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    C = {'Save to MATLAB workspace as GUIDataOut:',...
        '',...
        'Rload - Real part of ZL',...
        'Z0 - Characteristic impedance',...
        'ff0 - freq \ quarterwave frequency',...
        'Zin - Complex double',...
        'gammaABS - Reflection coefficient magnutude',...
        'SWR - Standing wave ratio'};

    cellstrg = cell(numel(C),1);
    for k = 1:numel(C)
        cellstrg(k) = C(k);
    end
    hObject.String = cellstrg;



function varargout = logistal(varargin)
% LOGISTAL MATLAB code for logistal.fig
%      LOGISTAL, by itself, creates a new LOGISTAL or raises the existing
%      singleton*.
%
%      H = LOGISTAL returns the handle to a new LOGISTAL or the handle to
%      the existing singleton*.
%
%      LOGISTAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOGISTAL.M with the given input arguments.
%
%      LOGISTAL('Property','Value',...) creates a new LOGISTAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before logistal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to logistal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help logistal

% Last Modified by GUIDE v2.5 20-May-2016 16:40:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @logistal_OpeningFcn, ...
                   'gui_OutputFcn',  @logistal_OutputFcn, ...
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


% --- Executes just before logistal is made visible.
function logistal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to logistal (see VARARGIN)

% Choose default command line output for logistal
handles.output = hObject;

handles.r_disp.String = get(handles.r_slider, 'Value');
guidata(hObject, handles);
draw(hObject, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes logistal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = logistal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% logistical function used in drawings
function lf = lf(y, r)
    lf = r * y * (1 - y);
    
% f(f(x)) -- 2-cycle function
function lf2 = lf2(y, r)
    lf2 = r^2 * y * (1 - y)*(1 - r*y*(1 - y));

% (re)draw the plot
function draw(hObject, handles)
    v = [0:.01:1];
    w = [ ];
    z = [ ];
    r = get(handles.r_slider, 'Value');
    for t = v
        w = [w, lf(t, r)];
        z = [z, lf2(t, r)];
    end
       
    if abs(2 - r) < 1
        col = 'g';
        l_title = 'f(x) (stable)';
    else
        col = 'r';
        l_title = 'f(x) (unstable)';
    end
    whitebg('k');
    if get(handles.f2_toggle, 'Value') ~=  0
        plot(v, w, col, v, z, 'c', v, v, 'w', 'LineWidth', 2);
        legend(l_title, 'f(f(x))', 'y = x', 'Location', 'northwest');
    else
        plot(v, w, col, v, v, 'w', 'LineWidth', 2);
        legend(l_title, 'y = x', 'Location', 'northwest');
    end
    
    if get(handles.cobweb_toggle, 'Value') ~= 0

        C = cobweb(r);
        if C(end,2) > 0.001   % Don't care about trivial solution
            hold on;
            cs = size(C);
            for i = 1:cs(1)-1
                plot([C(i:i,1), C(i:i,1), C(i+1:i+1,1)], ...
                    [C(i:i,2) C(i+1:i+1) C(i+1:i+1,2)], 'y', 'LineWidth', .5);
            end
            hold off;
        end
    end
    
    text((v(end)-v(1))/2, max(w) + (v(end)-v(1))/30, num2str(r, 'r = %5.3f'));

% cobweb -- return an array of points that will be
%     used to plot a cobweb to highlight the logistical equation.

function [cobweb] = cobweb(r)
    xr = [0.1, lf(0.1, r)];
    yr = [0, lf(0.1, r)];
    epsilon = 0.0001;
    stop_at = 400;  % For 2-cycles, which don't reach epsilon = 0
    while abs(yr(end)-yr(end-1)) > epsilon && stop_at > 0
        yr = [yr, lf(xr(end), r)];
        xr = [xr, yr(end)];
        stop_at = stop_at - 1;
    end
    cobweb = [xr(:) yr(:)];

    
% --- Executes on slider movement.
function r_slider_Callback(hObject, eventdata, handles)
% hObject    handle to r_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.r_disp.String = get(handles.r_slider, 'Value');
guidata(hObject, handles);
draw(hObject, handles);

% --- Executes during object creation, after setting all properties.
function r_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in cobweb_toggle.
function cobweb_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to cobweb_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cobweb_toggle
guidata(hObject, handles);
draw(hObject, handles);

% --- Executes on button press in f2_toggle.
function f2_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to f2_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of f2_toggle
guidata(hObject, handles);
draw(hObject, handles);
function varargout = NASE3D(varargin)
% NASE3D MATLAB code for NASE3D.fig
%      NASE3D, by itself, creates a new NASE3D or raises the existing
%      singleton*.
%
%      H = NASE3D returns the handle to a new NASE3D or the handle to
%      the existing singleton*.
%
%      NASE3D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NASE3D.M with the given input arguments.
%
%      NASE3D('Property','Value',...) creates a new NASE3D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NASE3D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NASE3D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NASE3D

% Last Modified by GUIDE v2.5 17-Apr-2018 10:02:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NASE3D_OpeningFcn, ...
                   'gui_OutputFcn',  @NASE3D_OutputFcn, ...
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


% --- Executes just before NASE3D is made visible.
function NASE3D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NASE3D (see VARARGIN)

% Choose default command line output for NASE3D
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NASE3D wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NASE3D_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% ----------------------------------------------------------------------%
%                          LOAD FILE                          %
% ----------------------------------------------------------------------%

function uipushtool1_ClickedCallback(hObject, eventdata, handles)
clear fn
handles.output = hObject;

[fn pn] = uigetfile('*.dcm','select dicom file');
addpath(pn);

if fn==0
    errordlg ('Please load a dicom file')
    handles.var1=0;
    guidata(hObject,handles);
    return
else
    msgbox ('File Loaded', 'Success')
end

display (fn) % In the Matlab "Command Window" the name of the DICOM file we are going to use will appear 

handles.var1=dicominfo(fn);

%Initialize
handles.tubes=[];
handles.var2=[];
guidata(hObject,handles);



% ----------------------------------------------------------------------%
%                          INFORMATION ICON                             %
% ----------------------------------------------------------------------%

% --------------------------------------------------------------------
function uipushtool4_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty (handles.var1)
    errordlg ('Please, load a dicom file first.')
    return
    
else
    info=handles.var1;
    numstructures=fieldnames(info.ROIContourSequence);
    sitems=size(numstructures,1);
    stritems=(num2str( sitems));
    
    for k=1:sitems
        field2=getfield(info.StructureSetROISequence, numstructures{k});
        field2=getfield(field2,'ROIName');
        noms{k}=strcat('Item',num2str(k),':',field2) ;
    end
  
 set(handles.text4,'String',noms)  
 guidata(hObject, handles)   
end

% --- Executes during object creation, after setting all properties.
function Information_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Information (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in text4.
function text4_Callback(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text4,'Value')  

% Hint: get(hObject,'Value') returns toggle state of text4

% --- Executes on key press with focus on text4 and none of its controls.
function text4_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------- %
%                               MOULD                                   %
% --------------------------------------------------------------------- %

% MOULD ITEM

function edit1_Callback(hObject, eventdata, handles)
    k=str2double(get(hObject, 'String'));

if isnan(k)
    errordlg('You must enter a numeric value','Invalid Input','modal')
    uicontrol(hObject)
    return
else
    display(k);
    
end

info=handles.var1; 
numstructures=fieldnames(info.ROIContourSequence);

if k > size(numstructures,1)
    errordlg ('Item value out of limits')
    uicontrol (hObject)
    return
end

handles.var2 = k;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% CREATE  MOULD

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
if isempty (handles.var1)
    errordlg ('Please load a dicom file first')
    return
    
end

if isempty (handles.var2)
    errordlg ('Please indicate the mould item number first')
    return
end

info=handles.var1;
k=handles.var2;

numstructures=fieldnames(info.ROIContourSequence); %diferent structures

field1=getfield(info.ROIContourSequence, numstructures{k});
field1=getfield(field1,'ContourSequence');
items=fieldnames(field1);

%initialize

clear ex ey ez xx yy zz myAng x0 y0 z0 xcir ycir
cla reset

for j=1:length(items) %loop slices
    
    a=getfield(field1, items{j});
    a=getfield(a,'ContourData');
    s=size(a,1);
    ii=1;
    
    for i=1:3:s %loop data
        ex(j,ii)=((a(i,1)));
        ey(j,ii)=((a(i+1,1)));
        ez(j,ii)=((a(i+2,1)));
        
        ii=ii+1;
        %ii is the number of points
    end
end

% Eliminate incomplete slices 

for i=1:size(ex,1)-1
    
    if i > 1 && abs(ex(i,1)-ex(i-1,1)) > 1000
        
        ex(i,:)=[];
        ey(i,:)=[];
        ez(i,:)=[];
        
    else
        
        ex(i,:)=ex(i,:);
        ey(i,:)=ey(i,:);
        ez(i,:)=ez(i,:);
        
    end
    
end

for i=1:size(ex,1)
    for j=1:size(ex,2)
        if ex(i,j)==0
            ex(i,j)=ex(i,j-1);
        end
        if ey(i,j)==0
            ey(i,j)=ey(i,j-1);
        end
        if ez(i,j)==0 && j > 1
            ez(i,j)=ez(i,j-1);
        end
    end
end

plot3(ex',ey',ez','ro','LineWidth',2)
traceplot=surf(ex',ey',ez');
surf(ex', ey', ez')
axis off equal
axis on

% Check if figure is closed
choice = questdlg('Is the figure closed?','Figure','Yes','No','No')

switch choice
    case 'No'
        ex(:,1)=ex(:,1)-2;
        ey(:,end)=ey(:,end)-2;
        plot3(ex',ey',ez','ro','LineWidth',2)
        traceplot=surf(ex',ey',ez');
        surf(ex', ey', ez')
        axis off equal
        axis on
end

handles.save=vertcat(ex, ey, ez);
guidata(hObject, handles);

% CLEAR MOULD

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)

cla reset;
handles.save=[];
handles.var2=[];
guidata(hObject, handles);

% --------------------------------------------------------------------- %
%                       TUBES                                           %
% --------------------------------------------------------------------- %

% TUBES ITEMS

% TUBE 1

function edit2_Callback(hObject, eventdata, handles)

handles.tube_t1=[];
tube_t1=[];
tube_t1=str2double(get(hObject, 'String'));

if isnan(tube_t1)
    errordlg('You must enter a numeric value','Invalid Input','modal')
    uicontrol(hObject)
    return
else
    display(tube_t1);    
end

handles.tubes=[handles.tubes,tube_t1];
handles.tube_t1=tube_t1;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% TUBE 2

function edit3_Callback(hObject, eventdata, handles)
clear tube_t2;
tube_t2=str2double(get(hObject, 'String'));

if isnan(tube_t2)
    errordlg('You must enter a numeric value','Invalid Input','modal')
    uicontrol(hObject)
    return
else
    display(tube_t2);
    
end

handles.tube_t2=tube_t2;
handles.tubes=[handles.tubes,tube_t2];
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% TUBE 3

function edit4_Callback(hObject, eventdata, handles)
clear tube_t3;
tube_t3=str2double(get(hObject, 'String'));

if isnan(tube_t3)
    errordlg('You must enter a numeric value','Invalid Input','modal')
    uicontrol(hObject)
    return
    
else
    display(tube_t3);
end

handles.tube_t3=tube_t3;
handles.tubes=[handles.tubes,tube_t3];
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% TUBE 4

function edit5_Callback(hObject, eventdata, handles)
clear tube_t4;
tube_t4=str2double(get(hObject, 'String'));

if isnan(tube_t4)
    errordlg('You must enter a numeric value','Invalid Input','modal')
    uicontrol(hObject)
    return
    
else
    display(tube_t4);
end

handles.tube_t4=tube_t4;
handles.tubes=[handles.tubes,tube_t4];
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% TUBE 5

function edit6_Callback(hObject, eventdata, handles)
clear tube_t5;
tube_t5=str2double(get(hObject, 'String'));

if isnan(tube_t5)
    errordlg('You must enter a numeric value','Invalid Input','modal')
    uicontrol(hObject)
    return
else
    display(tube_t5);
    
end

handles.tube_t5=tube_t5;
handles.tubes=[handles.tubes,tube_t5];
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% TUBE 6

function edit7_Callback(hObject, eventdata, handles)
clear tube_t6;
tube_t6=str2double(get(hObject, 'String'));

if isnan(tube_t6)
    errordlg('You must enter a numeric value','Invalid Input','modal')
    uicontrol(hObject)
    return
else
    display(tube_t6);
    
end
handles.tube_t6=tube_t6;
handles.tubes=[handles.tubes,tube_t6];
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% TUBE 7

function edit8_Callback(hObject, eventdata, handles)
clear tube_t7;
tube_t7=str2double(get(hObject, 'String'));

if isnan(tube_t7)
    errordlg('You must enter a numeric value','Invalid Input','modal')
    uicontrol(hObject)
    return
    
else
    display(tube_t7);
end

handles.tube_t7=tube_t7;
handles.tubes=[handles.tubes,tube_t7];
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% TUBE 8

function edit9_Callback(hObject, eventdata, handles)
clear tube_t8;
tube_t8=str2double(get(hObject, 'String'));

if isnan(tube_t8)
    errordlg('You must enter a numeric value','Invalid Input','modal')
    uicontrol(hObject)
    return
else
    display(tube_t8);
    
end
handles.tube_t8=tube_t8;
handles.tubes=[handles.tubes,tube_t8];
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% TUBE 9

function edit10_Callback(hObject, eventdata, handles)
clear tube_t9;
tube_t9=str2double(get(hObject, 'String'));

if isnan(tube_t9)
    errordlg('You must enter a numeric value','Invalid Input','modal')
    uicontrol(hObject)
    return

else
    display(tube_t9);   
end


handles.tube_t9=tube_t9;
handles.tubes=[handles.tubes,tube_t9];
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------- %
%                       RADIUS                                           %
% --------------------------------------------------------------------- %

% RADIUS ITEMS

function edit11_Callback(hObject, eventdata, handles)
handles.radius =[];
Radius=[];

Radius = str2double(get(hObject,'String')); % returns contents of edit27 as a double

if isnan(Radius)
    errordlg('You must enter a numeric value','Invalid Input','modal')
    uicontrol(hObject)
    return
else
    display(Radius);   
end

handles.radius = Radius;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ------------------------------------------------------------------------%
%                          CREATE TUBES                                   %
% ------------------------------------------------------------------------%

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
info=handles.var1;

if isempty(info)
    errordlg ('Please load a dicom file first')
    return
end

if isempty(handles.tubes)
    errordlg ('Please enter at least one numeric tube item value first')
    return
end

numstructures=fieldnames(info.ROIContourSequence); %diferent structures
tubes=handles.tubes;

handles.s=size(tubes,2);
c=1; % Is the index for each tube ("item"). We have to start always in the first item box.

cla reset

for k=tubes
    
    %initialize
    ii=1;
    clear e xx yy zz myAng x0 y0 z0 xcir ycir 
    
    field1=getfield(info.ROIContourSequence, numstructures{k});
    field1=getfield(field1,'ContourSequence');
    items=fieldnames(field1); %items de cada structure (slices)
    
    
    for j=1:length(items) %loop slices
        
        a=getfield(field1, items{j});
        a=getfield(a,'ContourData');
        s=size(a);
        
        for i=1:3:s %loop data
            
            e(ii,1)=((a(i,1)));     % e matriu amb coordenades [x y z] de cada punt
            e(ii,2)=((a(i+1,1)));
            e(ii,3)=((a(i+2,1)));
            ii=ii+1;                %ii numero de punts
            
        end
    end
    
    plot3(e(:,1)',e(:,2)',e(:,3)','ro','LineWidth',2);  %plot del punts
    hold on
    ply=fnplt(cscvn(e')); %crear linea a partir dels punts
    

    N = 10;
    R = handles.radius; %1.7 Default Radius (mm). 
    
    % All the Radius is going to be equal for all the tubes, because if we 
    % use different values, the uncertainty will be different for each tubes.
    
    %Convert all vectors to column
    x0=reshape(ply(1,:),[],1);
    y0=reshape(ply(2,:),[],1);
    z0=reshape(ply(3,:),[],1);
    
    %Copy x, y
    x0=repmat(x0,1,N+1);
    y0=repmat(y0,1,N+1);
    
    %Generate points in circles
    myAng=linspace(0,2*pi,N+1);
    xcir=R*cos(myAng);
    ycir=R*sin(myAng);
    xx=x0+repmat(xcir,size(x0,1),1);
    yy=y0+repmat(ycir,size(y0,1),1);
    zz=repmat(z0,1,N+1);
    
    hold on
    traceplot=surf(xx',yy',zz'); %Creating surface using the points
    axis off equal
    axis on
    
    if c==1
        handles.xx1=xx;
        handles.yy1=yy;
        handles.zz1=zz;
    elseif c==2
        handles.xx2=xx;
        handles.yy2=yy;
        handles.zz2=zz;
    elseif c==3
        handles.xx3=xx;
        handles.yy3=yy;
        handles.zz3=zz;
    elseif c==4
        handles.xx4=xx;
        handles.yy4=yy;
        handles.zz4=zz;
    elseif c==5
        handles.xx5=xx;
        handles.yy5=yy;
        handles.zz5=zz;
    elseif c==6
        handles.xx6=xx;
        handles.yy6=yy;
        handles.zz6=zz;
    elseif c==7
        handles.xx7=xx;
        handles.yy7=yy;
        handles.zz7=zz;
    elseif c==8
        handles.xx8=xx;
        handles.yy8=yy;
        handles.zz8=zz;
    elseif c==9
        handles.xx9=xx;
        handles.yy9=yy;
        handles.zz9=zz;
    end
    
    c=c+1;
    
end

guidata(hObject, handles);


% ------------------------------------------------------------------------%
%                          CLEAR TUBES                                   %
% ------------------------------------------------------------------------%

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
cla reset
display (handles.tubes)
handles.tubes=[];
handles.s=[];
guidata(hObject, handles);


% ------------------------------------------------------------------------%
%                          SAVE MOULD                                   %
% ------------------------------------------------------------------------%


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
if isempty(handles.save)
    errordlg ('Please create the mould first')
    return
end
if isempty (handles.var1)
    errordlg ('Please load a dicom file')
    return
end

e_save=handles.save;
e_size=size(e_save,1);
ex=e_save(1:e_size/3, : );
ey=e_save(((e_size/3)+1):(2*(e_size/3)),:);
ez=e_save(2*(e_size/3)+1:e_size, : );

%Triar el nom en que es guarda
x = inputdlg('File name: ');
mould_name=strcat(x{:}, '.stl')
if exist (mould_name)
    choice = questdlg ('The file already exist, do you want to continue?', 'File', 'Yes', 'No', 'Yes')
    switch choice
        case 'No'
            return
    end
end

surf2stl(mould_name,ex,ey,ez)
msgbox('Mould Saved','Success');


% ------------------------------------------------------------------------%
%                          SAVE TUBES                                   %
% ------------------------------------------------------------------------%


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)

c=1;
if isempty (handles.var1)
    errordlg ('Please load a dicom file')
    return
elseif isempty(handles.s)
    errordlg ('Please create tubes first')
    return
end

s=handles.s;

for i=1:s
    display (c)
    clear xx yy zz x
    
    if c==1
        xx=handles.xx1;
        yy=handles.yy1;
        zz=handles.zz1;
    elseif c==2
        xx=handles.xx2;
        yy=handles.yy2;
        zz=handles.zz2;
    elseif c==3
        xx=handles.xx3;
        yy=handles.yy3;
        zz=handles.zz3;
    elseif c==4
        xx=handles.xx4;
        yy=handles.yy4;
        zz=handles.zz4;
    elseif c==5
        xx=handles.xx5;
        yy=handles.yy5;
        zz=handles.zz5;
    elseif c==6
        xx=handles.xx6;
        yy=handles.yy6;
        zz=handles.zz6;
    elseif c==7
        xx=handles.xx7;
        yy=handles.yy7;
        zz=handles.zz7;
    elseif c==8
        xx=handles.xx8;
        yy=handles.yy8;
        zz=handles.zz8;
    elseif c==9
        xx=handles.xx9;
        yy=handles.yy9;
        zz=handles.zz9;
    end
        
    %Crear i guardar malla de cada tub
    
    num=num2str(c);
    file_name=strcat('File name ',num);
    
    x = inputdlg({file_name});
    tube_name=strcat( x{:}, '.stl');
    
    if exist (tube_name)
        choice = questdlg ('The file already exist, do you want to continue?', 'File', 'Yes', 'No', 'Yes');
        switch choice
            case 'No'
                return %Si no es vol continuar retorna i no es guarda. 
        end
    end
    surf2stl(tube_name, xx', yy', zz')
    c=c+1;
    
end
msgbox('Tubes Saved', 'Success')


% ------------------------------------------------------------------------%
%                          CLEAR ALL                                      %
% ------------------------------------------------------------------------%

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
choice = questdlg('Are you sure you want to clear all?','Clear all','Yes','No', 'No') 
switch choice
    case 'No'
        return
    case 'Yes'
        cla reset
        handles.tube_t1=[]; handles.tube_t2=[]; handles.tube_t3=[];
        handles.tube_t4=[]; handles.tube_t5=[]; handles.tube_t6=[];
        handles.tube_t7=[]; handles.tube_t8=[]; handles.tube_t9=[];
        handles.tubes=[];
        handles.var1=[]; handles.var2=[];
        handles.s=[];
end

guidata(hObject,handles);

function axes1_CreateFcn(hObject,eventdata,guidata)
% hObject    handle to axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function edit27_CreateFcn(hObject,eventdata,guidata)
% hObject    handle to axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function test3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to test3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



%---------------------------------------------------------------------- %
%                                 SURF2STL                              %
%---------------------------------------------------------------------- %

function surf2stl(filename,x,y,z,mode)
%SURF2STL   Write STL file from surface data.
%   SURF2STL('filename',X,Y,Z) writes a stereolithography (STL) file
%   for a surface with geometry defined by three matrix arguments, X, Y
%   and Z.  X, Y and Z must be two-dimensional arrays with the same size.
%
%   SURF2STL('filename',x,y,Z), uses two vector arguments replacing
%   the first two matrix arguments, which must have length(x) = n and
%   length(y) = m where [m,n] = size(Z).  Note that x corresponds to
%   the columns of Z and y corresponds to the rows.
%
%   SURF2STL('filename',dx,dy,Z) uses scalar values of dx and dy to
%   specify the x and y spacing between grid points.
%
%   SURF2STL(...,'mode') may be used to specify the output format.
%
%     'binary' - writes in STL binary format (default)
%     'ascii'  - writes in STL ASCII format
%
%   Example:
%
%     surf2stl('test.stl',1,1,peaks);
%
%   See also SURF.
%
%   Author: Bill McDonald, 02-20-04

error(nargchk(4,5,nargin));

if (ischar(filename)==0)
    error( 'Invalid filename');
end

if (nargin < 5)
    mode = 'binary';
elseif (strcmp(mode,'ascii')==0)
    mode = 'binary';
end

if (ndims(z) ~= 2)
    error( 'Variable z must be a 2-dimensional array' );
end

if any( (size(x)~=size(z)) | (size(y)~=size(z)) )
    
    % size of x or y does not match size of z
    
    if ( (length(x)==1) & (length(y)==1) )
        % Must be specifying dx and dy, so make vectors
        dx = x;
        dy = y;
        x = ((1:size(z,2))-1)*dx;
        y = ((1:size(z,1))-1)*dy;
    end
        
    if ( (length(x)==size(z,2)) & (length(y)==size(z,1)) )
        % Must be specifying vectors
        xvec=x;
        yvec=y;
        [x,y]=meshgrid(xvec,yvec);
    else
        error('Unable to resolve x and y variables');
    end
        
end

if strcmp(mode,'ascii')
    % Open for writing in ascii mode
    fid = fopen(filename,'w');
else
    % Open for writing in binary mode
    fid = fopen(filename,'wb+');
end

if (fid == -1)
    error( sprintf('Unable to write to %s',filename) );
end

title_str = sprintf('Created by surf2stl.m %s',datestr(now));

if strcmp(mode,'ascii')
    fprintf(fid,'solid %s\r\n',title_str);
else
    str = sprintf('%-80s',title_str);    
    fwrite(fid,str,'uchar');         % Title
    fwrite(fid,0,'int32');           % Number of facets, zero for now
end

nfacets = 0;

for i=1:(size(z,1)-1)
    for j=1:(size(z,2)-1)
        
        p1 = [x(i,j)     y(i,j)     z(i,j)];
        p2 = [x(i,j+1)   y(i,j+1)   z(i,j+1)];
        p3 = [x(i+1,j+1) y(i+1,j+1) z(i+1,j+1)];
        val = local_write_facet(fid,p1,p2,p3,mode);
        nfacets = nfacets + val;
        
        p1 = [x(i+1,j+1) y(i+1,j+1) z(i+1,j+1)];
        p2 = [x(i+1,j)   y(i+1,j)   z(i+1,j)];
        p3 = [x(i,j)     y(i,j)     z(i,j)];        
        val = local_write_facet(fid,p1,p2,p3,mode);
        nfacets = nfacets + val;
        
    end
end

if strcmp(mode,'ascii')
    fprintf(fid,'endsolid %s\r\n',title_str);
else
    fseek(fid,0,'bof');
    fseek(fid,80,'bof');
    fwrite(fid,nfacets,'int32');
end

fclose(fid);

disp( sprintf('Wrote %d facets',nfacets) );


% Local subfunctions

function num = local_write_facet(fid,p1,p2,p3,mode)

if any( isnan(p1) | isnan(p2) | isnan(p3) )
    num = 0;
    return;
else
    num = 1;
    n = local_find_normal(p1,p2,p3);
    
    if strcmp(mode,'ascii')
        
        fprintf(fid,'facet normal %.7E %.7E %.7E\r\n', n(1),n(2),n(3) );
        fprintf(fid,'outer loop\r\n');        
        fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p1);
        fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p2);
        fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p3);
        fprintf(fid,'endloop\r\n');
        fprintf(fid,'endfacet\r\n');
        
    else
        
        fwrite(fid,n,'float32');
        fwrite(fid,p1,'float32');
        fwrite(fid,p2,'float32');
        fwrite(fid,p3,'float32');
        fwrite(fid,0,'int16');  % unused
        
    end
    
end

function n = local_find_normal(p1,p2,p3)
 
v1 = p2-p1;
v2 = p3-p1;
v3 = cross(v1,v2);
n = v3 ./ sqrt(sum(v3.*v3));



% --------------------------------------------------------------------- %
% -------------------------- TOOLBAR COMMANDS ------------------------- %
% --------------------------------------------------------------------- %

% --------------------------------------------------------------------- %
%                               Rotate 3D                               %
% --------------------------------------------------------------------- %

function uitoggletool1_ClickedCallback(hObject, eventdata, handles)
set(rotate3d,'RotateStyle','orbit', 'Enable','on');


% --------------------------------------------------------------------- %
%                               Zoom Out                                %
% --------------------------------------------------------------------- %

function uitoggletool3_ClickedCallback(hObject, eventdata, handles)
set(zoom,'Motion', 'horizontal', 'Enable','on', 'Direction','out');


% --------------------------------------------------------------------- %
%                               Zoom In                                 %
% --------------------------------------------------------------------- %
function uitoggletool2_ClickedCallback(hObject, eventdata, handles)
set(zoom,'Motion','horizontal','Enable','on', 'Direction', 'in');

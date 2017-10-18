function varargout = MappingG(varargin)
% MAPPINGG MATLAB code for MappingG.fig
%      MAPPINGG, by itself, creates a new MAPPINGG or raises the existing
%      singleton*.
%
%      H = MAPPINGG returns the handle to a new MAPPINGG or the handle to
%      the existing singleton*.
%
%      MAPPINGG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAPPINGG.M with the given input arguments.
%
%      MAPPINGG('Property','Value',...) creates a new MAPPINGG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MappingG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MappingG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MappingG

% Last Modified by GUIDE v2.5 01-Mar-2016 21:36:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MappingG_OpeningFcn, ...
                   'gui_OutputFcn',  @MappingG_OutputFcn, ...
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


% --- Executes just before MappingG is made visible.
function MappingG_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
addpath(pwd)
handles.mapping_p=uipanel('parent',gcf,'units','characters', ...
    'position',[-0.2 -0.2 50.6 44],'visible','off');
handles.radio_p=uipanel('parent',handles.mapping_p,'units','characters', ...
    'position',[1.4 39 47 3.5],'visible','off','title','Mapping type:');
handles.radio1=uicontrol('parent',handles.radio_p,'unit','characters', ...
    'position',[3.2 0.4 17 1.77],'style','radiobutton', ...
    'visible','off','string','2D mapping', ...
    'callback',{@rad1_val},'value',1);
handles.radio2=uicontrol('parent',handles.radio_p,'unit','characters', ...
    'position',[24.2 0.4 17 1.77],'style','radiobutton', ...
    'visible','off','string','3D mapping', ...
    'callback',{@rad2_val});
handles.coor_tab=uitable('parent',handles.mapping_p,'unit','characters', ...
    'position',[2 3.3 45.8 24], ...
    'visible','off');
handles.dat_tab=uitable('parent',handles.mapping_p,'unit','characters', ...
    'position',[2 3.3 45.8 24], ...
    'visible','off', ...
    'columnname',{'Station pair' 'Channel' 'Sampl. freq.' ...
    'Min. freq' 'Max. freq'}, ...
    'columnwidth',{70, 70, 70, 70, 70}, ...
    'columnformat',{'char' 'char' 'char' 'char' 'char'});
handles.dat_b=uicontrol('parent',handles.mapping_p, ...
    'units','characters', ...
    'position',[2 0.7 13 1.7],'style','togglebutton', ...
    'value',1, ...
    'string','Data table','foregroundcolor','b', ...
    'callback',@dat_b2);
handles.coor_b=uicontrol('parent',handles.mapping_p, ...
    'units','characters', ...
    'position',[15 0.7 13 1.7],'style','togglebutton', ...
    'value',0, ...
    'string','Coordinate','foregroundcolor','b', ...
    'callback',@coor_b2);
handles.show_input_b=uicontrol('parent',handles.mapping_p, ...
    'units','characters', ...
    'position',[28 0.7 15 1.7],'style','pushbutton', ...
    'string','<<Input panel','foregroundcolor','b');
handles.show_map_b=uicontrol('parent',handles.uipanel1, ...
    'units','characters', ...
    'position',[28 0.7 19 1.7],'style','pushbutton', ...
    'string','Mapping panel>>','foregroundcolor','b');
handles.text_tab1=uicontrol('parent',handles.mapping_p, ...
    'unit','characters', ...
    'position',[2 27.5 35 1.5],'style','text', ...
    'string','Coordinate table:','horizontalalignment','left', ...
    'visible','off');
handles.text_tab2=uicontrol('parent',handles.mapping_p, ...
    'unit','characters', ...
    'position',[2 27.5 28 1.5],'style','text', ...
    'string','Data table:','horizontalalignment','left');
handles.plot_map=uicontrol('parent',handles.mapping_p, ...
    'unit','characters', ...
    'position',[32 29 15 1.5],'style','pushbutton', ...
    'string','Plot map','visible','off', ...
    'fontweight','bold','callback',@plot_b,'tag','all_maps');
handles.save_b=uicontrol('parent',handles.mapping_p, ...
    'unit','characters', ...
    'position',[17 29 15 1.5], ...
    'string','Save map', ...
    'foregroundcolor','blue','callback',{@save_b2},'enable','off');
% Cutomizing axes ------------------------------------------------------- %
handles.n_big=[315 48 380 482];
handles.n_small=[780 290 305 210];
handles.n2_big=[315 48 380 482];
handles.n2_small=[780 290 305 210];
handles.m_big=[80 48 540 482];
handles.axesm=axes('unit','pixel','position',[305 48 770 482]);
handles.axes2=axes('unit','pixel','position',handles.n_big, ...
    'fontsize',8);
handles.axes3=axes('unit','pixel','position',handles.n_small, ...
    'fontsize',8);
set(handles.axesm,'fontsize',8)
set(get(handles.axesm,'xlabel'),'string','Longitude','fontweight', ...
    'bold','fontsize',8)
set(get(handles.axesm,'ylabel'),'string','Latitude','fontweight', ...
    'bold','fontsize',8)
set(get(handles.axes2,'zlabel'),'string','Period (s)','fontweight', ...
    'bold','fontsize',8)
set(get(handles.axes2,'ylabel'),'string','Latitude','fontweight', ...
    'bold','fontsize',8)
set(get(handles.axes2,'xlabel'),'string','Longitude','fontweight', ...
    'bold','fontsize',8)
set(get(handles.axes3,'zlabel'),'string','Period (s)','fontweight', ...
    'bold','fontsize',8)
set(get(handles.axes3,'ylabel'),'string','Latitude','fontweight', ...
    'bold','fontsize',8)
set(get(handles.axes3,'xlabel'),'string','Longitude','fontweight', ...
    'bold','fontsize',8)
set(get(handles.axes2,'title'),'string','3D Map','fontweight', ...
    'bold','fontsize',10)
set(get(handles.axes3,'title'),'string','Slicing Map','fontweight', ...
    'bold','fontsize',10)
% 2D mapping on --------------------------------------------------------- %
handles.freq_t=uicontrol('parent',handles.mapping_p,'unit', ...
    'characters', ...
    'position',[1.6 37 20 1.2],'style','text', ...
    'string','Desired periode:', ...
    'visible','off','horizontalalignment','left');
handles.freq_box=uicontrol('parent',handles.mapping_p, ...
    'unit','characters', ...
    'position',[1.8 35.2 10.2 1.5],'style','edit', ...
    'visible','off', ...
    'backgroundcolor',[1 1 1], ...
    'callback',{@verify_freq});
handles.range_t=uicontrol('parent',handles.mapping_p, ...
    'unit','characters', ...
    'position',[13.4 35.3 26.6 1.2],'style','text', ...
    'string','min-max','horizontalalignment','left', ...
    'visible','off');
handles.gridding_t=uicontrol('parent',handles.mapping_p, ...
    'unit','characters', ...
    'position',[1.6 33.7 14.2 1.2],'style','text', ...
    'string','Gridding type:', ...
    'visible','off');
handles.gridding_pop=uicontrol('parent',handles.mapping_p, ...
    'unit','characters', ...
    'position',[1.8 32 26 1.5],'style','popupmenu', ...
    'string',{'Linear(Triangulation)','Cubic(Spline)','Natural', ...
    'Nearest','V4(Spline)'}, ...
    'visible','off', ...
    'backgroundcolor',[1 1 1], ...
    'callback',{@grid_pop});
handles.ui2D=   [handles.freq_t, handles.freq_box, handles.range_t, ...
                handles.gridding_t, handles.gridding_pop];
% 3D mapping on --------------------------------------------------------- %
handles.radio3=uicontrol('unit','pixel','position', ...
    [730 530 200 15],'style','radiobutton', ...
    'visible','on','string','Maximize 3D map', ...
    'callback',{@map_switch1},'value',1);
handles.radio4=uicontrol('unit','pixel','position', ...
    [860 530 200 15],'style','radiobutton', ...
    'visible','on','string','Maximize slicing map', ...
    'callback',{@map_switch2},'value',0);
handles.custom_p=uipanel('unit','pixel','position',[730 45 360 180], ...
    'title','Mapping customization:','ShadowColor',[0.8 0.8 0.8]);
handles.radio5=uicontrol('unit','pixel','position', ...
    [740 235 200 15],'style','radiobutton', ...
    'visible','on','string','3D customization', ...
    'callback',{@custom_3d},'value',1);
handles.radio6=uicontrol('unit','pixel','position', ...
    [850 235 150 15],'style','radiobutton', ...
    'visible','on','string','Slicing customization', ...
    'callback',{@custom_slice},'value',0);
handles.hide_show=uicontrol('units','pixel', ...
    'position',[980 20 110 20],'style','pushbutton', ...
    'string','<<Hide table panel','foregroundcolor','b', ...
    'callback',{@table_panel});
handles.ui3d=[handles.radio3, handles.radio4, handles.radio5, ...
    handles.radio6, handles.custom_p, handles.hide_show, ...
    handles.axes2, handles.axes3];
set(handles.ui3d,'visible','off')
% 3D customization on --------------------------------------------------- %
handles.nslice_t=uicontrol('unit','pixel', ...
    'position',[740 192 200 15],'style','text','string', ...
    'Number of slicing:','horizontalalignment','left', ...
    'visible','on');
handles.slicing_box=uicontrol('unit','pixel', ...
    'position',[835 190 30 17],'style','edit', ...
    'visible','on', ...
    'backgroundcolor',[1 1 1], ...
    'callback',{@verify_nslice},'string','40');
handles.grid3d_t=uicontrol('unit','pixel', ...
    'position',[740 165 200 15],'style','text','string', ...
    'Gridding type:','horizontalalignment','left', ...
    'visible','on');
handles.gridding2_pop=uicontrol('unit','pixel', ...
    'position',[815 167 130 15],'style','popupmenu', ...
    'string',{'Linear(Triangulation)','Natural Neighbor','Nearest'}, ...
    'visible','on','backgroundcolor',[1 1 1], ...
    'callback',{@v3dmap});
handles.opacity_t=uicontrol('unit','pixel', ...
    'position',[740 140 200 15],'style','text','string', ...
    'Opacity:','horizontalalignment','left', ...
    'visible','on');
handles.opacity_slide=uicontrol('unit','pixel','position', ...
    [740 120 180 15],'style','slider','visible','on', ...
    'max',100,'min',0,'value',20,'sliderstep',[0.01 0.01], ...
    'callback',@opac_s,'tag','opc1');
handles.opacity_box=uicontrol('unit','pixel', ...
    'position',[930 119 28 17],'style','edit', ...
    'visible','on', ...
    'backgroundcolor',[1 1 1], ...
    'callback',{@opac_sb},'string','20','tag','opb1');
handles.percent_t=uicontrol('unit','pixel', ...
    'position',[960 119 20 15],'style','text','string', ...
    '%','horizontalalignment','left', ...
    'visible','on');
handles.m3d_custom=[handles.nslice_t, handles.slicing_box, handles.grid3d_t, ...
    handles.gridding2_pop, handles.opacity_t, handles.opacity_slide, ...
    handles.opacity_box, handles.percent_t];
set(handles.m3d_custom,'visible','off')
% Slice customization on ------------------------------------------------ %
handles.slice_t=uicontrol('unit','pixel', ...
    'position',[740 192 100 15],'style','text','string', ...
    'Slicing mode:','horizontalalignment','left');
handles.radio7=uicontrol('unit','pixel','position', ...
    [810 192 120 15],'style','radiobutton', ...
    'string','Horizontal/vertical', ...
    'callback',{@HV_mode},'value',1);  
handles.radio8=uicontrol('unit','pixel','position', ...
    [925 192 60 15],'style','radiobutton', ...
    'string','Diagonal', ...
    'callback',{@diagonal_mode},'value',0);
% H/V mode ------------------------- %
handles.slice3d_t=uicontrol('unit','pixel', ...
    'position',[740 167 100 15],'style','text','string', ...
    'Slice plane in:','horizontalalignment','left');
handles.radio12=uicontrol('unit','pixel','position', ...
    [810 167 60 15],'style','radiobutton', ...
    'visible','on','string','X axis:', ...
    'callback',{@update_plane},'value',1,'tag','Xp'); 
handles.radio13=uicontrol('unit','pixel','position', ...
    [810 142 60 15],'style','radiobutton', ...
    'visible','on','string','Y axis:', ...
    'callback',{@update_plane},'value',0,'tag','Yp'); 
handles.radio14=uicontrol('unit','pixel','position', ...
    [810 117 60 15],'style','radiobutton', ...
    'visible','on','string','Z axis:', ...
    'callback',{@update_plane},'value',0,'tag','Zp'); 
handles.X_box=uicontrol('unit','pixel', ...
    'position',[870 165 45 17],'style','edit', ...   
    'backgroundcolor',[1 1 1], ...
    'callback',{@update_bplane});
handles.Y_box=uicontrol('unit','pixel', ...
    'position',[870 140 45 17],'style','edit', ...   
    'backgroundcolor',[1 1 1], ...
    'callback',{@update_bplane},'enable','off');
handles.Z_box=uicontrol('unit','pixel', ...
    'position',[870 115 45 17],'style','edit', ...   
    'backgroundcolor',[1 1 1], ...
    'callback',{@update_bplane},'enable','off');
handles.opacity2_t=uicontrol('unit','pixel', ...
    'position',[740 90 100 15],'style','text','string', ...
    'Opacity:','horizontalalignment','left');
handles.opacity2_slide=uicontrol('unit','pixel','position', ...
    [785 90 150 15],'style','slider', ...
    'max',100,'min',0,'value',100,'sliderstep',[0.01 0.01], ...
    'callback',@opac_s,'tag','opc2');
handles.opacity2_box=uicontrol('unit','pixel', ...
    'position',[940 89 33 17],'style','edit', ...   
    'backgroundcolor',[1 1 1], ...
    'callback',{@opac_sb},'string','100','tag','opb2');
handles.percent2_t=uicontrol('unit','pixel', ...
    'position',[975 90 15 15],'style','text','string', ...
    '%','horizontalalignment','left');
handles.grids2_t=uicontrol('unit','pixel', ...
    'position',[740 65 50 15],'style','text','string', ...
    'Gridding:','horizontalalignment','left');
handles.on2_check=uicontrol('unit','pixel','position', ...
    [795 65 40 15],'style','checkbox','value',1,'string','on', ...
    'callback',@gridm,'tag','on2');
handles.off2_check=uicontrol('unit','pixel','position', ...
    [835 65 40 15],'style','checkbox','value',0,'string','off', ...
    'callback',@gridm,'tag','off2');
handles.HV_all=[handles.slice3d_t, handles.radio12, handles.radio13, ...
    handles.radio14, handles.X_box, handles.Y_box, handles.Z_box, ...
    handles.opacity2_t, handles.opacity2_box, handles.percent2_t, ...
    handles.opacity2_slide, handles.grids2_t, handles.on2_check, ...
    handles.off2_check];
set(handles.HV_all,'visible','off')
% Diagonal mode -------------------- %
handles.rotate_t=uicontrol('unit','pixel', ...
    'position',[740 170 130 15],'style','text','string', ...
    'Rotate slice plane toward:','horizontalalignment','left');
% handles.rotate_slide=uicontrol('unit','pixel','position', ...
%     [740 150 150 15],'style','slider','max',360,'min', ...
%     -360,'value',45,'sliderstep',[0.01 0.01],'callback',@rot_s);
handles.rotate1_box=uicontrol('unit','pixel', ...
    'position',[930 168 33 16],'style','edit', ...   
    'backgroundcolor',[1 1 1], ...
    'callback',{@check_rot},'string','45');
handles.deg1_t=uicontrol('unit','pixel', ...
    'position',[970 169 50 15],'style','text','string', ...
    'degrees','horizontalalignment','left');
handles.rotate2_box=uicontrol('unit','pixel', ...
    'position',[930 148 33 16],'style','edit', ...   
    'backgroundcolor',[1 1 1], ...
    'callback',{@check_rot},'string','','enable','off');
handles.deg2_t=uicontrol('unit','pixel', ...
    'position',[970 149 50 15],'style','text','string', ...
    'degrees','horizontalalignment','left');
handles.rotate3_box=uicontrol('unit','pixel', ...
    'position',[930 128 33 16],'style','edit', ...   
    'backgroundcolor',[1 1 1], ...
    'callback',{@check_rot},'string','','enable','off');
handles.deg3_t=uicontrol('unit','pixel', ...
    'position',[970 129 50 15],'style','text','string', ...
    'degrees','horizontalalignment','left');
% handles.deg2_t=uicontrol('unit','pixel', ...
%     'position',[740 127 50 15],'style','text','string', ...
%     'toward:','horizontalalignment','left');
handles.radio9=uicontrol('unit','pixel','position', ...
    [870 170 60 15],'style','radiobutton', ...
    'visible','on','string','X axis:', ...
    'callback',{@d_axis},'value',1,'tag','radx');  
handles.radio10=uicontrol('unit','pixel','position', ...
    [870 150 60 15],'style','radiobutton', ...
    'visible','on','string','Y axis:', ...
    'callback',{@d_axis},'value',0,'tag','rady'); 
handles.radio11=uicontrol('unit','pixel','position', ...
    [870 130 60 15],'style','radiobutton', ...
    'visible','on','string','Z axis:', ...
    'callback',{@d_axis},'value',0,'tag','radz'); 
handles.elev_t=uicontrol('unit','pixel', ...
    'position',[740 105 50 15],'style','text','string', ...
    'Elevation:','horizontalalignment','left');
handles.elev_slide=uicontrol('unit','pixel','position', ...
    [795 105 140 15],'style','slider','max',100,'min', ...
    0,'value',50,'sliderstep',[0.01 0.01],'callback',@elev_s);
handles.elev_box=uicontrol('unit','pixel', ...
    'position',[940 104 40 17],'style','edit', ...   
    'backgroundcolor',[1 1 1], ...
    'callback',{@check_elev},'string','');
handles.grids_t=uicontrol('unit','pixel', ...
    'position',[740 80 50 15],'style','text','string', ...
    'Gridding:','horizontalalignment','left');
handles.on_check=uicontrol('unit','pixel','position', ...
    [795 80 40 15],'style','checkbox','value',1,'string','on', ...
    'tag','on1','callback',@gridm);
handles.off_check=uicontrol('unit','pixel','position', ...
    [835 80 40 15],'style','checkbox','value',0,'string','off', ...
    'tag','off1','callback',@gridm);
handles.opacity3_t=uicontrol('unit','pixel', ...
    'position',[740 55 50 15],'style','text','string', ...
    'Opacity:','horizontalalignment','left');
handles.opacity3_slide=uicontrol('unit','pixel','position', ...
    [785 55 150 15],'style','slider','max',100,'min', ...
    0,'value',100,'sliderstep',[0.01 0.01],'tag','opc3', ...
    'callback',@opac_s);
handles.opacity3_box=uicontrol('unit','pixel', ...
    'position',[940 54 33 17],'style','edit', ...   
    'backgroundcolor',[1 1 1], ...
    'callback',@opac_sb,'string','100','tag','opb3');
handles.percent3_t=uicontrol('unit','pixel', ...
    'position',[975 55 15 15],'style','text','string', ...
    '%','horizontalalignment','left');
handles.diagonal_all=[handles.rotate_t, ...
    handles.rotate1_box, handles.deg1_t, handles.radio9, ...
    handles.radio10, handles.radio11, handles.elev_slide, ... 
    handles.grids_t, handles.on_check, handles.off_check, ...
    handles.elev_t, handles.opacity3_t, handles.opacity3_slide, ...
    handles.opacity3_box, handles.percent3_t, handles.elev_box, ...
    handles.rotate2_box, handles.rotate3_box, handles.deg2_t, ...
    handles.deg3_t];
set([handles.slice_t, handles.radio7, handles.radio8],'visible','off')
set(handles.diagonal_all,'visible','off')
% Update handles structure ---------------------------------------------- %
guidata(hObject, handles);
set(handles.show_input_b,'callback',{@show_input});
guidata(handles.show_input_b,handles)
set(handles.show_map_b, ...
    'callback',{@show_map_p},'enable','off');
guidata(handles.show_map_b,handles)

% UIWAIT makes MappingG wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MappingG_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% Load data button =======================================================%
function add_b_Callback(hObject, eventdata, handles)

if (isfield(handles,'NL') && isfield(handles,'dcoor'))
set(findall(handles.uipanel1, '-property', 'visible'), 'visible', 'off')
set(findall(handles.mapping_p, '-property', 'visible'), 'visible', 'on')
handles2D=[handles.freq_t handles.freq_box handles.gridding_t ...
    handles.gridding_pop handles.range_t];
if get(handles.radio1,'value')==1;
    set(handles2D,'visible','on')
    set(handles.radio2,'value',0)
elseif get(handles.radio2,'value')==1;
    set(handles3D,'visible','on')
    set(handles.radio,'value',0)
else
    %shouldn't be happended
end
coor=handles.coor;
if handles.idf==2
    %Convert UTM to degree------------------------------------------------%
    stacoor=coor(:,1);
    for m=1:size(coor,1)
    zones=strjoin({num2str(coor{m,4}),coor{m,5}},' ');
    [Lat,Lon]=utm2deg(coor{m,2},coor{m,3},zones);
    latX{m}=Lat;
    lonX{m}=Lon;    
    end
    coor=[stacoor latX' lonX'];
    %---------------------------------------------------------------------%
else
    %skip
end
% Creating data table ----------------------------------------------------%
pair_list=handles.NL;
selected_file={};
m=1;
for i=1:length(pair_list)
                v=regexp(pair_list(i),['D_\w*.mat'],'match');
            if  (~isempty(v{1}))
                selected_file{end+1}=pair_list{i};
            else
                cl=clock;
                err1=([date ' ' num2str(cl(1,4)) ':' num2str(cl(1,5))...
                    ':' num2str(floor(cl(1,5))) ...
                    ' Load file: unable to load ''' ...
                    pair_list{i} '''.']);
                vlog=get(handles.log_r,'value');
%                 try    
                handles.log=[{err1} handles.log];
%                 catch
%                 handles.log={err1};
%                 end
%                 handles.log=logrep;
                set(handles.log_r,'string',handles.log,'listboxtop',10)
            end 
end
set(handles.log_r,'listboxtop',10)
% Creating data table 1 & acquiring polynomial eq. data ------------------%
for j=1:length(selected_file)
    load([selected_file{j}])
    All_inf(j,1:5)=inf_dat(1:5);
    pair_n{j}=strrep(All_inf{j,1},'-','_');
    Eq.(pair_n{j})=eq_dat;
end
set(handles.dat_tab,'data',All_inf)
% Setting limit for desired freq. ----------------------------------------%
mp1=cell2mat(All_inf(:,4));
mp2=cell2mat(All_inf(:,5));
minr=max(mp1);
maxr=min(mp2);
set(handles.range_t,'string',['(' num2str(minr) ' - ' num2str(maxr) ')'])
% Setting default X slice plane ----------------------------------------- %
miX=min(cell2mat(coor(:,3)));
maX=max(cell2mat(coor(:,3)));
handles.mdx=sprintf('%0.2f',((maX-miX)/2)+miX);
set(handles.X_box,'string',num2str(handles.mdx))
% Calculating middle points from coordinates -----------------------------%
m=1;
md=[];
for n1=1:length(selected_file)  
    n_pairs=strsplit(All_inf{n1,1},'-');
    sta1=n_pairs{1};
    sta2=n_pairs{2};
    ind1=getnameidx(coor,sta1);
    ind2=getnameidx(coor,sta2);
    coor1=coor(ind1,2:3);
    coor2=coor(ind2,2:3);
    cooR=cell2mat([coor1;coor2]);
    coorY=max(cooR(1:2,1))-((max(cooR(1:2,1))-min(cooR(1:2,1)))/2);
    coorX=max(cooR(1:2,2))-((max(cooR(1:2,2))-min(cooR(1:2,2)))/2);
    md(m,1)=coorX;
    md(m,2)=coorY;
    m=m+1;        
end
% Creating measured station pts ----------------------------------------- %
    for k=1:size(All_inf)
        staX(k,1:2)=strsplit(All_inf{k,1},'-');
    end
        stats=[staX(:,1); staX(:,2)];
        q=1;
    for p=1:length(stats)-1
        A=strcmp(stats{p},stats(p+1:end));
        if any(A,1)
            if p==length(stats)-1
                selected_sta{q}=stats{end};
            else
            end  
        else
            selected_sta{q}=stats{p};
            q=q+1;                                                          
        end                   
    end                
    b=1;
    for x=1:length(selected_sta)
        for x2=1:length(coor)
            if strcmp(selected_sta{x},coor{x2,1})
                req_coor(b,:)=coor(x2,:);
                b=b+1;                            
            else
                %skip
            end
        end
    end
% Saving data to handles ------------------------------------------------ %
handles.maxf=maxr;
handles.minf=minr;
handles.Eq=Eq;
handles.md=md;
handles.pair_n=pair_n;
handles.coor=coor;
handles.All_inf=All_inf;
handles.idf_f=0;
handles.req_coor=req_coor;
set(handles.freq_box,'string','')
mdf=((maxr-minr)/2)+minr;
set(handles.elev_slide,'max',maxr,'min',minr,'value', ...
    mdf)
set(handles.elev_box,'string',sprintf('%0.2f',mdf))
guidata(hObject,handles)
% ----------------------------------------------------------------------- %
else
    if (~isfield(handles,'NL') && ~isfield(handles,'dcoor'))
        msgbox({'No input data found' 'No coordinate data'}, ...
            'Failed to load data found','warn')
    elseif ~isfield(handles,'NL')
        msgbox('No input file found','Failed to load file','warn')
    else
        msgbox('No coordinate data found','Failed to load coordinates','warn')
    end
end  

function reset_b_Callback(hObject, eventdata, handles)
% blankx={};
% % Hblank= [handles.ucornerx, handles.lcornerx, handles.center_freq, ...
% %         handles.gauss_dev];
% % set(handles.uitable1,'data',blankx)
% % set(handles.dat_tab,'data',blankx)
% set(handles.show_dir,'string',blankx)
% set(handles.coor_tab,'data',[])
% set(handles.dat_tab,'data',[])
% % handles.NL=blankx;
% % 
%     try    handles=rmfield(handles,'scatS');end
%     try    handles=rmfield(handles,'scattS');end
%     try    handles=rmfield(handles,'scatt3');end
%     try    handles=rmfield(handles,'scatt');end
%     try    handles=rmfield(handles,'colb1');end
%     try    handles=rmfield(handles,'colb2');end
%     try    handles=rmfield(handles,'colb3');end
%     try    handles=rmfield(handles,'vmap');end
%     try    handles=rmfield(handles,'p_sta');end
%     try    handles=rmfield(handles,'t_sta');end
%     try    handles=rmfield(handles,'vel3d');end
%     try    handles=rmfield(handles,'dcoor');end
%     try    handles=rmfield(handles,'NL');end
%     try    handles=rmfield(handles,'h');end
%     try    handles=rmfield(handles,'coor');end
% % try    handles=rmfield(handles,'smap');end
% % try    handles=rmfield(handles,'colb3');end
% % try    handles=rmfield(handles,'colb3');end
% %   
% handlesX=   [handles.save_m, handles.save_b];            
% % handlesX2=  [handles.auto_p];
% set(handlesX,'enable','off')
% % set(handlesX2,'value',0)
% % set(handles.time_lag,'string','Time lag:')
% % set(findall(handles.axes1, '-property', 'visible'), 'visible', 'off')
% guidata(hObject,handles)
close(gcf)
MappingG %Simple solution :p

function coor_b_Callback(hObject, eventdata, handles)
% hObject    handle to coor_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = questdlg('Which type of coordinate data you want to load?', ...
	'Coordinate type', ...
	'Degree','UTM','Cancel','Degree');
% Handle response
switch choice
    case 'Degree'        
        handles.idf = 1;
        set(handles.coor_tab,'columnname',{'Station','Latitude', ...
            'Longitude'}, ...
            'columnwidth',{50 70 70}, ...
            'columnformat',{'char' 'char' 'char'})
    case 'UTM'    
        handles.idf = 2;
        set(handles.coor_tab,'columnname',{'Station','Easting', ...
            'Northing','Long. zone','Lat. zone'}, ...
            'columnwidth',{70 100 100 70 70}, ...
            'columnformat',{'char' 'char' 'char' 'char' 'char'})
    case 'Cancel' 
        handles.idf = 0;
end

if handles.idf~=0
[a b]=uigetfile('*.txt','C:/');
try
addpath(b)
coor=readtable(a,'delimiter',' ','ReadVariableNames',false);
coor=table2cell(coor);
coor2=coor;
if handles.idf==2
for n1=2:3;
    for n2=1:size(coor,1);
        coor2{n2,n1}=sprintf('%0.2f',coor{n2,n1});
    end
end
else
    %skip
end

for m1=1:size(coor,1)
    sta_n{m1}=coor{m1,1};
    dcoor.(sta_n{m1})=coor(m1,2:3);
end
handles.dcoor=dcoor;
handles.coor=coor;
set(handles.coor_tab,'data',coor2)
% if handles.idf==1
%     set(handles.dat_tab,'columnname', ...
%         {'Station' 'Latitude' 'Longitude'},'columnwidth',{60 70 70})
% elseif handles.idf==2
%     set(handles.dat_tab,'columnname', ...
%         {'Station' 'Easting' 'Northing' 'Long. zone' 'Lat. zone'}, ...
%         'columnwidth',{60 70 70 70 70})
% end
% set([handles.text4, handles.dat_tab],'visible','on')
% set([handles.dat_tab, handles.add_b, handles.map_b],'enable','on')
guidata(hObject,handles)
catch
end
else
    %skip the process
end

function show_dir_ButtonDownFcn(hObject, eventdata, handles)
seltype = get(gcf,'selectiontype');
del_row=get(handles.show_dir,'Value');

hcmenu = uicontextmenu;
item1 = uimenu(hcmenu,'Label','Delete','Callback', ...
    {@opsi1,hObject,eventdata,handles});
item2 = uimenu(hcmenu,'Label','Add file');
item2_2=uimenu(item2,'Label','Select file(s)...','Callback',{@opsi3,hObject,eventdata,handles});
item2_1=uimenu(item2,'Label','All files in a folder...','Callback',{@opsi2,hObject,eventdata,handles});

if strmatch(seltype,'alt')
    set(handles.show_dir,'uicontextmenu',hcmenu)
end
%=========================================================================%
        function opsi1(varargin)            
            handles=varargin{5};
            hObject=varargin{3};            
            del_row=get(handles.show_dir,'Value');
            new_list=get(handles.show_dir, 'string');
            x=0;
            for i=1:length(del_row);
                n=del_row(i);    
                new_list(n-x)=[];
                x=x+1;    
            end
             set(handles.show_dir,'string',new_list,'value',1)             
             handles.NL=new_list;             
             set(handles.add_b,'enable','on')
             guidata(hObject,handles)
             
        function opsi2(varargin)
            handles=varargin{5};
            hObject=varargin{3};
            folder_name=uigetdir(pwd);
            try
            addpath(folder_name)
            cd(folder_name)
                try
                list1=handles.NL;
                catch
                list1=[];
                end            
            list2=dir(folder_name);
            list2=struct2cell(list2)';
            list2=list2(:,1);
            newlist=[list1;list2];
            set(handles.show_dir,'string',newlist)
            handles.NL=newlist;            
            sz=size(list2,1);
            cl=clock;
            if sz>=1
                rep1=([date ' ' num2str(cl(1,4)) ':' num2str(cl(1,5)) ...
                    ':' num2str(floor(cl(1,5))) ...
                    ' Open dir: Successully added ' num2str(sz-2) ' files']);
            else
                rep1=([date ' ' num2str(cl(1,4)) ':' num2str(cl(1,5)) ...
                    ':' num2str(floor(cl(1,5))) ...
                    ' Open dir: Successfully added ' num2str(sz) ' file']);
            end
            try
                handles.log=[rep1 handles.log];
            catch
                handles.log{1}=rep1;
            end
            set(handles.log_r,'string',handles.log)
            set(handles.add_b,'enable','on')
            guidata(hObject,handles)
            catch
                %skip
            end
        function opsi3(varargin)
            handles=varargin{5};
            hObject=varargin{3};
            [a b c]=uigetfile('*', ...
                'Select file... (you can select multiple files)', ...
                'multiselect','on');
            try
            addpath(b)
            cd(b)
                try
                list1=handles.NL;
                catch
                list1=[];
                end
                if ~iscell(a)
                    list2={a};
                else
                list2=a';
                end
            newlist=[list1;list2];
            set(handles.show_dir,'string',newlist)
            handles.NL=newlist;
            sz=size(list2,1);
            cl=clock;
            if sz>=1
                rep1=([date ' ' num2str(cl(1,4)) ':' num2str(cl(1,5)) ...
                    ':' num2str(floor(cl(1,5))) ...
                    ' Open dir: Successully added ' num2str(sz) ' files']);
            else
                rep1=([date ' ' num2str(cl(1,4)) ':' num2str(cl(1,5)) ...
                    ':' num2str(floor(cl(1,5))) ...
                    ' Open dir: Successfully added ' num2str(sz) ' file']);
            end
            try
                handles.log=[rep1 handles.log];
            catch
                handles.log{1}=rep1;
            end
            set(handles.log_r,'string',handles.log)
            set(handles.add_b,'enable','on')
            guidata(hObject,handles)
            catch
                %skip
            end
            
%Additional function======================================================%
    function show_input(hObject, eventdada)
%         hObject=varargin{3};
%         handles=varargin{5};
        handles=guidata(hObject);        
        set(findall(handles.uipanel1,'-property','visible'),'visible','on')
        set(findall(handles.mapping_p,'-property','visible'), ...
            'visible','off')        
        set(handles.show_map_b,'enable','on')        
        guidata(hObject,handles)
        
     function show_map_p(hObject,eventdata)
        handles=guidata(hObject);
        set(findall(handles.uipanel1,'-property','visible'),'visible','off')
        set(findall(handles.mapping_p,'-property','visible'), ...
            'visible','on')
        if get(handles.radio1,'value')==1
            set(handles.ui2D,'visible','on')
        else
            set(handles.ui2D,'visible','off')
        end
        guidata(hObject,handles)
%=========================================================================%

        % Coordinate button ============================================= %
        function coor_b2(hObject, eventdata)
        handles=guidata(hObject);       
        set([handles.dat_tab handles.text_tab2],'visible','off')
        set([handles.coor_tab handles.text_tab1],'visible','on')
        set(handles.dat_b,'value',0)
        set(handles.coor_b,'value',1)
        guidata(hObject,handles)
        
        % Data button =================================================== %
        function dat_b2(hObject, eventdata)
        handles=guidata(hObject);       
        set([handles.dat_tab handles.text_tab2],'visible','on')
        set([handles.coor_tab handles.text_tab1],'visible','off')
        set(handles.dat_b,'value',1)
        set(handles.coor_b,'value',0)        
        guidata(hObject,handles)
        
        % Verifying frequency input ===================================== %
        function verify_freq(hObject, eventdata)
        handles=guidata(hObject);
        fin=get(hObject,'string');
        maxf=handles.maxf;
        minf=handles.minf;
        try
            fin=str2double(fin);
        catch
            %skip
        end
        if (isnan(fin) || ~isnumeric(fin) || ~isreal(fin) ...
            || fin>maxf || fin<minf)
            msgbox({'Input requires:' ...
            '- Numeric input' ...
            '- Real number' ...
            '- Within the frequency limit'}, ... 
            'Invalid input','warn')
            idf_f=0;
            set(hObject,'string',[])
        % '  (unless frequency extrapolation is enabled)'}, ...            
        else
            idf_f=1;
            %skip
        end
        % Saving data in handles ---------------------------------------- %
        handles.dfreq=fin;
        handles.idf_f=idf_f;
        guidata(hObject,handles)
        
        % Verifying number of slicing input ============================= %
        function verify_nslice(hObject, eventdata)
        handles=guidata(hObject);
        fin=get(hObject,'string');
        try
            fin=str2double(fin);
        catch
            %skip
        end
        if (isnan(fin) || ~isnumeric(fin) || ~isreal(fin))
            msgbox({'Input requires:' ...
            '- Numeric input' ...
            '- Real number'}, ... 
            'Invalid input','warn')
            idf_nslice=0;    
            set(handles.slicing_box,'string',[])
        else
            idf_nslice=1;            
        end
        % Saving data in handles ---------------------------------------- %
        handles.nslice=fin;
        handles.idf_nslice=idf_nslice;
        guidata(hObject,handles)
        v3dmap(hObject,eventdata);
        
        % Gridding popup ================================================ %
        function grid_pop(hObject,eventdata)
        handles=guidata(hObject);
        handles.meth_n=get(hObject,'value');
        guidata(hObject,handles)
               
        % 3D radio button ================================================ %
        function rad2_val(hObject, eventdata)
        handles=guidata(hObject);
        set(handles.radio2,'value',1)
        set(handles.radio1,'value',0) 
        try set(handles.colb1,'visible','off'); end
        try set(handles.colb2,'visible','on'); end
        try set(handles.colb3,'visible','on'); end
        set(handles.ui2D,'visible','off')
        set(handles.axesm,'visible','off')        
        set(handles.ui3d,'visible','on') 
        set(findall(handles.axesm),'visible','off')
        set(findall(handles.axes2),'visible','on')
        set(findall(handles.axes3),'visible','on')
        idf_1=get(handles.radio5,'value')==1;
        idf_2=get(handles.radio6,'value')==1;
        idf_3=get(handles.radio7,'value')==1;
        idf_4=get(handles.radio8,'value')==1;       
        if  idf_1==true
            set(handles.m3d_custom,'visible','on')
        elseif idf_2==true && idf_3==true
            set([handles.HV_all, handles.radio7, ...
                handles.radio8, handles.slice_t],'visible','on')
        elseif idf_2==true && idf_4==true
            set([handles.diagonal_all, handles.radio7, ...
                handles.radio8, handles.slice_t],'visible','on')
        else
            %shouldn't be happened
        end
        % repositioning mome UIs ---------------------------------------- %
        set(handles.plot_map,'position',[32 37 15 1.5])
        set(handles.save_b,'position',[17 37 15 1.5])
        set(handles.text_tab1,'position',[2 35.5 15 1.5])
        set(handles.text_tab2,'position',[2 35.5 15 1.5])
        set(handles.coor_tab,'position',[2 3.3 45.8 32])
        set(handles.dat_tab,'position',[2 3.3 45.8 32])
        axes(handles.axes2)
        guidata(hObject,handles)
        
        % 2D radio button =============================================== %
        function rad1_val(hObject, eventdata)
        handles=guidata(hObject);
        set(handles.radio2,'value',0)
        set(handles.radio1,'value',1)  
        try set(handles.colb1,'visible','on'); end
        try set(handles.colb2,'visible','off'); end
        try set(handles.colb3,'visible','off'); end
        set(handles.ui2D,'visible','on')
        set(handles.axesm,'visible','on')        
        set(findall(handles.axesm),'visible','on')
        set(findall(handles.axes2),'visible','off')
        set(findall(handles.axes3),'visible','off')
        set([handles.ui3d, handles.m3d_custom, handles.HV_all, ...
            handles.diagonal_all, handles.radio7, ...
            handles.radio8, handles.slice_t],'visible','off') 
        % repositioning mome UIs ---------------------------------------- %
        set(handles.plot_map,'position',[32 29 15 1.5])
        set(handles.save_b,'position',[17 29 15 1.5])
        set(handles.text_tab1,'position',[2 27.5 15 1.5])
        set(handles.text_tab2,'position',[2 27.5 15 1.5])
        set(handles.coor_tab,'position',[2 3.3 45.8 24])
        set(handles.dat_tab,'position',[2 3.3 45.8 24])
        set(handles.axesm,'visible','on')
        axes(handles.axesm)
        guidata(hObject,handles)
        
        % Hide-show table panel ========================================= %
        function table_panel(hObject, eventdata)
        handles=guidata(hObject);        
        if strcmp(get(handles.hide_show,'string'),'<<Hide table panel')
            handles.idf_p=strcmp(get(handles.mapping_p,'visible'),'on');
            set(handles.hide_show,'string','<<Show table panel')            
            set(findall(handles.uipanel1,'-property','visible'), ...
            'visible','off')
            set(findall(handles.mapping_p,'-property','visible'), ...
            'visible','off')      
            if any((get(handles.axes2,'position'))==handles.n_big)                
                set(handles.axes2,'position',handles.m_big)
            else
                set(handles.axes3,'position',handles.m_big)
            end
        elseif strcmp(get(handles.hide_show,'string'), ...
                '<<Show table panel') && handles.idf_p==true  
            if any(get(handles.axes2,'position')==handles.m_big)
                set(handles.axes2,'position',handles.n_big)
            else
                set(handles.axes3,'position',handles.n_big)
            end
            set(findall(handles.mapping_p,'-property','visible'), ...
            'visible','on')
            set(handles.hide_show,'string','<<Hide table panel')
            set(handles.ui2D,'visible','off')            
        else
            if any(get(handles.axes2,'position')==handles.m_big)
                set(handles.axes2,'position',handles.n_big)
            else
                set(handles.axes3,'position',handles.n_big)
            end
            set(handles.hide_show,'string','<<Hide table panel')
               set(findall(handles.uipanel1,'-property','visible'), ...
            'visible','on')
            set(handles.hide_show,'string','<<Hide table panel')
        end
        guidata(hObject,handles)
        
        % Maximize-minimize map ========================================= %
        function map_switch1(hObject, eventdata)
        handles=guidata(hObject);
        if get(handles.radio4,'value')==1
        set(handles.radio3,'value',1)
        set(handles.radio4,'value',0)
        posx1=get(handles.axes3,'position');
            if posx1(1)==handles.n_big(1)  
                set(handles.axes2,'position',handles.n_big)
            else
                set(handles.axes2,'position',handles.m_big)
            end 
        set(handles.axes3,'position',handles.n_small)
        else
            %skip
        end
        set(handles.radio3,'value',1) 
        guidata(hObject,handles)
        function map_switch2(hObject, eventdata)
        handles=guidata(hObject);
        if get(handles.radio3,'value')==1
        set(handles.radio3,'value',0)        
        posx1=get(handles.axes2,'position');
            if posx1(1)==handles.n_big(1)
                set(handles.axes3,'position',handles.n_big); 
            else
                set(handles.axes3,'position',handles.m_big)
            end   
        set(handles.axes2,'position',handles.n_small)
        else
            %skip
        end
        set(handles.radio4,'value',1) 
        guidata(hObject,handles)
        
        % 3D customize ================================================== %
        function custom_3d(hObject, eventdata)
        handles=guidata(hObject);
        set(handles.radio5,'value',1)
        set(handles.radio6,'value',0)
        set(handles.m3d_custom,'visible','on')
        set([handles.HV_all, handles.diagonal_all],'visible','off')
        set([handles.slice_t, handles.radio7, handles.radio8], ...
        'visible','off')
        guidata(hObject,handles)
        
        % Slice customize =============================================== %
        function custom_slice(hObject, eventdata)
        handles=guidata(hObject);
        set(handles.radio5,'value',0)
        set(handles.radio6,'value',1)
        set(handles.m3d_custom,'visible','off')
        set([handles.radio7, handles.radio8, handles.slice_t], ...
            'visible','on')
        if get(handles.radio7,'value')==1
        set(handles.HV_all,'visible','on')
        else
        set(handles.diagonal_all,'visible','on')
        end
        guidata(hObject,handles)       
        
        % Slicing mode ================================================== %
        function HV_mode(hObject, eventdata)
        handles=guidata(hObject);
        set(handles.radio7,'value',1)
        set(handles.radio8,'value',0)
        set(handles.HV_all,'visible','on')
        set(handles.diagonal_all,'visible','off')
        guidata(hObject,handles)
        function diagonal_mode(hObject, eventdata)
        handles=guidata(hObject);
        set(handles.radio7,'value',0)
        set(handles.radio8,'value',1)
        set(handles.HV_all,'visible','off')
        set(handles.diagonal_all,'visible','on')
        dslice(hObject,handles)
%         guidata(hObject,handles)
        
        % Griding 3D popup ============================================== %
        function grid3d_pop(hObject, eventdata)
        handles=guidata(hObject);
        handles.meth_3d=get(hObject,'value');
        guidata(hObject,handles)
        
        % Opacity slide ================================================= %
        function opac_s(hObject, eventdata)
        handles=guidata(hObject);
        cval=ceil(get(hObject,'value'));        
        switch get(hObject,'tag')
            case 'opc1'
                set(handles.opacity_box,'string',num2str(cval))
                cur_map=handles.h;
            case 'opc2'
                set(handles.opacity2_box,'string',num2str(cval))
                cur_map=handles.smap;
            otherwise
                set(handles.opacity3_box,'string',num2str(cval))
                cur_map=handles.drmap;
        end
        try 
            alpha(cur_map,cval/100)
        catch
            %skip
        end
        guidata(hObject,handles)

        % Opacity box =================================================== %
        function opac_sb(hObject, eventdata)
        handles=guidata(hObject);
        try 
            cval=ceil(str2double(get(hObject,'string')));
        catch
            msgbox({'Frequency input is empty or invalid'}, ...
                'Failed to plot map','warn')
        end
        if cval>100
            cval=100;
            set(hObject,'string','100')
        elseif cval<0
            cval=0;
            set(hObject,'string','0')
        else
            %skip
        end            
        set(handles.opacity_slide,'value',cval)
        switch get(hObject,'tag')
            case 'opb1'
                set(handles.opacity1_slide,'value',cval)
                cur_map=handles.h;
            case 'opb2'
                set(handles.opacity2_slide,'value',cval)
                cur_map=handles.smap;
            otherwise
                set(handles.opacity3_slide,'value',cval)
                cur_map=handles.drmap;
        end
        try 
            alpha(cur_map,cval/100)
        catch
            %skip
        end
        guidata(hObject,handles)
        
        % Slicing axis options ========================================== %
        function update_plane(hObject, eventdata)
        handles=guidata(hObject);
%         get(handles.radio13,'value')
        if get(handles.radio12,'value')==0 && ...
                get(handles.radio13,'value')==0 && ...
                get(handles.radio14,'value')==0
            try delete(handles.smap); end
            try delete(handles.scatS); end 
            try delete(handles.scattS); end
        else
            switch get(hObject,'tag')
                case 'Xp'
                    if get(hObject,'value')==1
                        set(handles.X_box,'enable','on')
                    else
                        set(handles.X_box,'enable','off')
                    end                    
                    switch get(handles.Z_box,'string')
                        case ''
                        miX=min(cell2mat(handles.coor(:,3)));
                        maX=max(cell2mat(handles.coor(:,3)));
                        mdX=sprintf('%0.2f',((maX-miX)/2)+miX);
                        set(handles.X_box,'string',mdX)    
                        otherwise
                            %skip
                    end
                    update_bplane(hObject,eventdata)
                case 'Yp'
                    if get(hObject,'value')==1
                        set(handles.Y_box,'enable','on')
                    else
                        set(handles.Y_box,'enable','off')
                    end 
                    switch get(handles.Y_box,'string')
                        case ''
                        miY=min(cell2mat(handles.coor(:,2)));
                        maY=max(cell2mat(handles.coor(:,2)));
                        mdY=sprintf('%0.2f',((maY-miY)/2)+miY);
                        set(handles.Y_box,'string',mdY)    
                        otherwise
                            %skip
                    end
                    update_bplane(hObject,eventdata)
                case 'Zp'
                    if get(hObject,'value')==1
                        set(handles.Z_box,'enable','on')
                    else
                        set(handles.Z_box,'enable','off')
                    end 
                    switch get(handles.Z_box,'string')
                        case ''
                        miZ=handles.minf;
                        maZ=handles.maxf;
                        mdZ=sprintf('%0.2f',((maZ-miZ)/2)+miZ);
                        set(handles.Z_box,'string',mdZ)    
                        otherwise
                            %skip
                    end
                    update_bplane(hObject,eventdata)
            end
        end     
        
        % Creating slicing H/V plane ==================================== %
        function update_bplane(hObject,eventdata)
        handles=guidata(hObject);
        coorn=cell2mat(handles.coor(:,2:3));
        try delete(handles.smap); end
        try delete(handles.scatS{:}); end 
        try delete(handles.scattS{:}); end
        try delete(handles.colb3); end
%         try delete(handles.drmap); end        
        % Acquiring slicing pts ----------------------------------------- %
        if strcmp(get(handles.X_box,'enable'),'on')
            mdX=str2double(get(handles.X_box,'string'));
        else
            mdX=[];
        end
        if strcmp(get(handles.Y_box,'enable'),'on')
            mdY=str2double(get(handles.Y_box,'string'));
        else
            mdY=[];
        end
        if strcmp(get(handles.Z_box,'enable'),'on')
            mdZ=str2double(get(handles.Z_box,'string'));
            mdZ=handles.maxf-(mdZ-handles.minf);
        else
            mdZ=[];
        end
        % Creating slicing map ------------------------------------------ %
        try
            waitbar(0.9,handles.wb,'Creating slicing map...')
        catch
            handles.wb=waitbar(0.9,'Creating slicing map...');
        end
        axes(handles.axes3)
        hold on
        handles.smap=slice(handles.mesh(:,:,:,1), ...
            handles.mesh(:,:,:,2),handles.mesh(:,:,:,3), ...
            handles.vel3d,mdX,mdY,mdZ);
            tickz=linspace(handles.minf,handles.maxf,8);
        for m=1:length(tickz)
            tickzlabel{m}=sprintf('%0.2f',tickz(m));
        end
        set(gca,'ztick',tickz)
        set(gca,'zticklabel',fliplr(tickzlabel))
        alpha(handles.smap,str2double(get(handles.opacity2_box, ...
            'string'))/100)
        set(handles.smap,'facecolor','interp')
        if get(handles.on_check,'value')==1
            set(handles.smap,'edgealpha',.05)
            try set(handles.drmap,'edgealpha',.03);end
        else
            set(handles.smap,'edgealpha',0)
            try set(handles.drmap,'edgealpha',0); end
        end
        % Plotting station pts ------------------------------------------ %
        for s=1:size(coorn,1)
            handles.scatS{s}=scatter3(coorn(s,2),coorn(s,1), ...
                handles.maxf,'marker','o','markeredgecolor', ...
                'r','linewidth',2);
            handles.scattS{s}=text(coorn(s,2),coorn(s,1), ...
            handles.maxf+(handles.maxf/25),handles.coor(s,1), ...
                'fontsize',8,'fontweight','bold');
        end
        handles.colb3=colorbar('location','eastoutside'); 
        set(get(handles.colb3,'ylabel'),'string', ...
            'Velocity (m/s)','fontweight','bold','fontsize',8)
        set(handles.colb3,'fontsize',8)
        grid on        
        view(-20,40)
        handles.lim=[get(gca,'xlim');get(gca,'ylim')];
        posx1=get(handles.axes2,'position');
        posx2=get(handles.axes3,'position');
        if posx1(1)==handles.m_big(1) || posx2(1)==handles.m_big(1)
            %skip
        else
            if get(handles.radio3,'value')==1
                handles.n_big=get(handles.axes2,'position');
                handles.n_small=get(handles.axes3,'position');
            else
                handles.n_big=get(handles.axes3,'position');
                handles.n_small=get(handles.axes2,'position');
            end
        end
        delete(handles.wb)
        try rmfield(handles,'wb'); end
        hold off
        set([handles.save_m handles.save_b],'enable','on')
        guidata(hObject,handles)        
        
        % Creating slicing diagonal plane =============================== %
        function d_axis(hObject,eventdata)
        handles=guidata(hObject);
        switch get(hObject,'tag')
            case 'radx'
                if get(hObject,'value')==1
                    set(handles.rotate1_box,'enable','on')
                    if strcmp(get(handles.rotate1_box,'string'),'')
                        set(handles.rotate1_box,'string',45)
                    else
                        %end
                    end
                    dslice(hObject,eventdata)
                else
                    set(handles.rotate1_box,'enable','off')
                end
            case 'rady'
                if get(hObject,'value')==1
                    set(handles.rotate2_box,'enable','on')
                    if strcmp(get(handles.rotate2_box,'string'),'')
                        set(handles.rotate2_box,'string',45)
                    else
                        %end
                    end
                    dslice(hObject,eventdata)
                else
                    set(handles.rotate2_box,'enable','off')
                end
            otherwise
                if get(hObject,'value')==1
                    set(handles.rotate3_box,'enable','on')
                    if strcmp(get(handles.rotate3_box,'string'),'')
                        set(handles.rotate3_box,'string',45)
                    else
                        %end
                    end
                    dslice(hObject,eventdata)
                else
                    set(handles.rotate3_box,'enable','off')
                end
        end        
        dslice(hObject,eventdata)
        
        % Creating slicing diagonal plane =============================== %
        function dslice(hObject,eventdata)
        handles=guidata(hObject);
        if get(handles.radio9,'value')==0 && ...
            get(handles.radio10,'value')==0 && ...
            get(handles.radio11,'value')==0
            try delete(handles.drmap); end
        else            
        if isfield(handles,'h')
            try delete(handles.drmap); end
            elev=str2double(get(handles.elev_box,'string'));
            lx=length(handles.f_surf(:,:,1));
            ly=length(handles.f_surf(:,:,2));
            ghost=axes; %temporal
            handles.dmap=surf(handles.f_surf(:,:,1),handles.f_surf(:,:,2), ...
                zeros(lx,ly));
            xlim([handles.lim(1,1) handles.lim(1,2)])
            ylim([handles.lim(2,1) handles.lim(2,2)])
            if get(handles.radio9,'value')==1
                rot=str2double(get(handles.rotate1_box,'string'));
                rotate(handles.dmap,[1,0,0],rot)
            else
                %skip
            end
            if get(handles.radio10,'value')==1
                rot=str2double(get(handles.rotate2_box,'string'));
                rotate(handles.dmap,[0,1,0],rot)
            else
                %skip
            end
            if get(handles.radio11,'value')==1
                rot=str2double(get(handles.rotate3_box,'string'));
                rotate(handles.dmap,[0,0,1],rot)
            else
                %skip
            end
            xd = get(handles.dmap,'XData');
            yd = get(handles.dmap,'YData');
            zd = get(handles.dmap,'ZData');
            delete(handles.dmap)
            delete(ghost)            
            [Rx,Cx]=find(xd(500,:)>=handles.lim(1,1) & xd(500,:)<=handles.lim(1,2));
            cmin=min(Cx);cmax=max(Cx);
            [Ry,Cy]=find(yd(:,500)>=handles.lim(2,1) & yd(:,500)<=handles.lim(2,2));
            rmin=min(Ry);rmax=max(Ry);
            xd3=xd(rmin:rmax,cmin:cmax);
            yd3=yd(rmin:rmax,cmin:cmax);
            zd3=zd(rmin:rmax,cmin:cmax);            
            axes(handles.axes3)
            hold on
            elev=handles.maxf-(elev-handles.minf);
            handles.drmap=slice(handles.mesh(:,:,:,1), ...
                handles.mesh(:,:,:,2),handles.mesh(:,:,:,3), ...
                handles.vel3d,xd3,yd3,zd3+elev);
            set(handles.drmap,'FaceColor','interp','edgealpha',0.03)
            view(-20,30)
%             axes(ha)
            delete(handles.colb3)
            try handles.colb3=colorbar; end
            set(get(handles.colb2,'ylabel'),'string', ...
                    'Velocity (m/s)','fontweight','bold','fontsize',8)
            set(handles.colb2,'fontsize',8)
            hold off
        else
            %skip
        end        
        end
        guidata(hObject,handles)
        
        % Rotation slide ================================================ %
        function rot_s(hObject,eventdata)
        handles=guidata(hObject);
        rot=round(get(handles.rotate_slide,'value'));
        set(handles.rotate_box,'string',num2str(rot))
        check_rot(hObject,eventdata)
        
        % Rotation box ================================================ %
        function check_rot(hObject,eventdata)
        handles=guidata(hObject);        
        % Verifying input validity -------------------------------------- %
        try rot=str2double(get(hObject,'string'));
            if rot<-360
%                 set(handles.rotate_slide,'value',-360)
                set(hObject,'string','-360')
            elseif rot>360
%                 set(handles.rotate_slide,'value',360)
                set(hObject,'string','360')
            else
                %skip
            end
            dslice(hObject,handles)
        catch
            msgbox({'Degree input is empty or invalid'}, ...
                    'Failed to plot map','warn')
            guidata(hObject,handles)
        end    
        
        % Elevation slide =============================================== %
        function elev_s(hObject,eventdata)
        handles=guidata(hObject);
        elev=get(handles.elev_slide,'value');
        set(handles.elev_box,'string',sprintf('%0.2f',elev))
        check_elev(hObject,eventdata)
        
        % Elevation box ================================================= %
        function check_elev(hObject,eventdata)
        handles=guidata(hObject);
        % Verifying input validity -------------------------------------- %
        try elev=str2double(get(handles.elev_box,'string'));
            if elev<handles.minf
                set(handles.elev_slide,'value',handles.minf)
                set(handles.elev_box,'string',num2str(handles.minf))
            elseif elev>handles.maxf
                set(handles.elev_slide,'value',handles.maxf)
                set(handles.elev_box,'string',num2str(handles.maxf))
            else
                %skip
            end
            dslice(hObject,handles)
        catch
            msgbox({'Elvation input is empty or invalid'}, ...
                    'Failed to plot map','warn')
            guidata(hObject,handles)
        end  
        
        % Gridding options ============================================== %
        function gridm(hObject, eventdata)
        handles=guidata(hObject); 
        if strcmp(get(hObject,'tag'),'on1') || ...
                strcmp(get(hObject,'tag'),'on2')
            set([handles.on_check, handles.on2_check],'value',1)
            set([handles.off_check, handles.off2_check],'value',0)
            set(handles.smap,'edgealpha',0.05)
            try set(handles.drmap,'edgealpha',.03); end
        else
            set([handles.on_check, handles.on2_check],'value',0)
            set([handles.off_check, handles.off2_check],'value',1)
            set(handles.smap,'edgealpha',0)         
            try set(handles.drmap,'edgealpha',0); end
        end
        guidata(hObject,handles)
        
        % Plot map ====================================================== %
        function plot_b(hObject, eventdata)
        handles=guidata(hObject);        
        idf_map=get(handles.radio1,'value');
%         try delete(handles.colb1); end
        switch idf_map
            % If 2D map option is chosen ---------------------------------%
            case 1
            % Checking input validity ------------------------------------%
            if handles.idf_f==1
                try delete(handles.vmap); end
                try delete(handles.p_sta); end
                try delete(handles.t_sta); end
                try delete(handles.colb1); end
                All_inf=handles.All_inf;
                Eq=handles.Eq;
                md=handles.md;
                pair_n=handles.pair_n;                
                coorn=cell2mat(handles.coor(:,2:3));
                dfreq=handles.dfreq;
                try
                    meth_n=handles.meth_n;
                catch
                    meth_n=1;
                end
                % Acquiring selected gridding method -------------------- %
                switch meth_n
                    case 1
                        methX='linear';
                    case 2
                        methX='cubic';
                    case 3 
                        methX='natural';
                    case 4
                        methX='nearest';
                    case 5
                        methX='v4';
                    otherwise
                        %shouldn't be happened
                end             
                % Acquiring velocity data ------------------------------- %
                for j=1:length(pair_n)
                    eqx=Eq.(pair_n{j});
                    vel(j)=polyval(eqx,dfreq);
                end
                vel=vel';
                % Creating blank "canvas" ------------------------------- %
                minY=min(coorn(:,1));
                maxY=max(coorn(:,1));
                minX=min(coorn(:,2));
                maxX=max(coorn(:,2));
                elimX=((maxX-minX)*10)/100;
                elimY=((maxY-minY)*10)/100;
                limxin=minX-elimX;
                limxax=maxX+elimX;
                limyin=minY-elimY;
                limyax=maxY+elimX;
                rX=limxin:0.005:limxax;
                rY=limyin:0.005:limyax;               
                % Gridding ---------------------------------------------- %
                [Xmesh, Ymesh]=meshgrid(rX,rY);
                velz=griddata(md(:,1),md(:,2),vel,Xmesh,Ymesh,methX);
                axes(handles.axesm)
                hold on                
                vmap=pcolor(Xmesh,Ymesh,velz);
                handles.colb1=colorbar; 
                set(get(handles.colb1,'ylabel'),'string', ...
                    'Velocity (m/s)','fontweight','bold','fontsize',8)
                set(handles.colb1,'fontsize',8)
%                 caxis([1200,3800])
                shading flat                
                % Plotting stations ------------------------------------- % 
                req_coor=handles.req_coor;
                req_coorx=cell2mat(req_coor(:,2:3));            
                for s=1:size(req_coor,1)
                    p_sta=plot(req_coorx(s,2),req_coorx(s,1),'marker','o');
                    t_sta=text(req_coorx(s,2),req_coorx(s,1)+0.03, ...
                        req_coor(s,1),'fontsize',8,'fontweight','bold');
                end
                set(get(handles.axesm,'title'),'string', ...
                    ['Velocity map (Periode: ' num2str(dfreq) 's)'], ...
                    'fontweight','bold', ...
                    'fontsize',12)
                handles.vmap=vmap;
                handles.p_sta=p_sta;
                handles.t_sta=t_sta;
                hold off
                else            
                    msgbox({'Frequency input is empty or invalid'}, ...
                    'Failed to plot map','warn')
                end
                set([handles.save_m handles.save_b],'enable','on')
                guidata(hObject,handles)
                % If 3D map option is chosen -------------------------------- %
                case 0
                v3dmap(hObject,eventdata)    
                update_bplane(hObject,eventdata)
                otherwise
                disp('err')
                %shouldn't be happened
        end  
        
        % 3D map function =============================================== %
        function v3dmap(hObject, eventdata)
            handles=guidata(hObject);   
            try delete(handles.colb2); end
%             try delete(handles.colb3); end
            try delete(handles.h); end
            try delete(handles.scat3{:}); end
            try delete(handles.scatt{:}); end            
            All_inf=handles.All_inf;
            Eq=handles.Eq;
            md=handles.md;
            pair_n=handles.pair_n;
            % Checking input validity ----------------------------------- %
            nslice=get(handles.slicing_box,'string');
            try 
                handles.nslice=str2double(nslice);
                handles.idf_nslice=1;
            catch
                handles.idf_nslice=0;
            end
            if handles.idf_nslice==1                
                coor=handles.coor;
                coorn=cell2mat(coor(:,2:3));
                % Acquiring selected gridding method -------------------- %
                try
                    meth_3d=get(handles.gridding2_pop,'value');
                catch
                    meth_3d=1;
                end
                switch meth_3d
                    case 1
                        methX='linear';
                    case 2
                        methX='natural';  
                    case 3
                        methX='nearest'; 
                    otherwise
                        %shouldn't be happened
                end 
                samp3d=[];
                freq_samp=linspace(handles.minf,handles.maxf,25);
                for j=1:length(pair_n)
                    for k=1:length(freq_samp)
                        eqx=Eq.(pair_n{j});
                        vel(k)=polyval(eqx,freq_samp(k));
                        xsamp(k)=md(j,1);
                        ysamp(k)=md(j,2);
                    end
                    vel=fliplr(vel);
                    samp3=[xsamp' ysamp' freq_samp' vel'];
                    if ~isempty(samp3d)
                        samp3d=[samp3d; samp3];
                    else
                        samp3d=samp3;
                    end                
                end    
                % Creating blank "canvas" ------------------------------- %
                minY=min(coorn(:,1));
                maxY=max(coorn(:,1));
                minX=min(coorn(:,2));
                maxX=max(coorn(:,2));
                minZ=max(cell2mat(All_inf(:,4)));
                maxZ=min(cell2mat(All_inf(:,5))); 
                halfx=(maxX-minX)/2;
                halfy=(maxY-minY)/2;
                limX=minX-halfx*(20/100);lamX=maxX+halfx*(20/100);
                limY=minY-halfy*(20/100);lamY=maxY+halfy*(20/100);
                rX=linspace(minX,maxX,200);
                rY=linspace(minY,maxY,200);
                rZ=linspace(minZ,maxZ,handles.nslice);
                halfz=(maxZ-minZ)/2;
                rsX=linspace((minX-halfz),(maxX+halfz),1000);
                rsY=linspace((minY-halfz),(maxY+halfz),1000);                
                idx=(maxX-minX)/200;
                idy=(maxY-minY)/200;
                % Gridding ---------------------------------------------- %                 
                handles.wb=waitbar(0.60,'Gridding...');
                [Xmesh, Ymesh, Zmesh]=meshgrid(rX,rY,rZ);
                handles.vel3d=griddata(samp3d(:,1),samp3d(:,2), ...
                    samp3d(:,3),samp3d(:,4),Xmesh,Ymesh,Zmesh,methX);                
                waitbar(0.80,handles.wb,'Visualizing map...')
                axes(handles.axes2)
                hold on 
                handles.h=slice(handles.vel3d,[],[],1:handles.nslice);
                set(handles.h,'EdgeColor','none','FaceColor','interp')
                % Plotting station pts ---------------------------------- %
                for s=1:size(coorn,1)
                    xn=ceil((coorn(s,2)-minX)/idx);
                    yn=ceil((coorn(s,1)-minY)/idy);
                handles.scat3{s}=scatter3(xn,yn, ...
                    handles.nslice,'marker','o','markeredgecolor', ...
                    'r','linewidth',2);
                handles.scatt{s}=text(xn,yn, ...
                    handles.nslice+(20/handles.nslice),coor(s,1), ...
                    'fontsize',8,'fontweight','bold');
                end
                % ------------------------------------------------------- %
                tickz=linspace(1,handles.nslice,8);
                tickz2=linspace(handles.minf,handles.maxf,8);
                tickz2=fliplr(tickz2);
                ticky=linspace(1,length(rY),6);
                ticky2=linspace(minY,maxY,6);
                tickx=linspace(1,length(rX),6);
                tickx2=linspace(minX,maxX,6);
                for m=1:length(tickz)
                    tickzlabel{m}=sprintf('%0.2f',tickz2(m));
                end
                for m=1:length(ticky)
                    tickylabel{m}=sprintf('%0.2f',ticky2(m));
                end
                for m=1:length(tickx)
                    tickxlabel{m}=sprintf('%0.2f',tickx2(m));
                end
                set(gca,'ztick',tickz)
                set(gca,'zticklabel',tickzlabel) 
                set(gca,'ytick',ticky)
                set(gca,'yticklabel',tickylabel) 
                set(gca,'xtick',tickx)
                set(gca,'xticklabel',tickxlabel) 
                trans=str2double(get(handles.opacity_box,'string'))/100;
                alpha(trans)
                view(-20,40)
                grid on
                handles.colb2=colorbar; 
                set(get(handles.colb2,'ylabel'),'string', ...
                    'Velocity (m/s)','fontweight','bold','fontsize',8)
                set(handles.colb2,'fontsize',8)
                handles.mesh=cat(4,Xmesh,Ymesh,Zmesh);
                handles.f_surf=cat(3,rsX,rsY);
                handles.lim=[limX lamX; limY lamY];
                hold off       
                set([handles.save_m handles.save_b],'enable','on')
                if strcmp(get(hObject,'tag'),'all_maps')
                    %retain waitbar
                else
                delete(handles.wb)
                end
            else 
                msgbox({'Number of slicing input is empty or invalid'}, ...
                'Failed to plot 3d map','warn')
            end
        guidata(hObject,handles)
        
%         function vslice(hObject, eventdata)
%         handles=guidata(hObject);  
%         disp('test')
%         guidata(hObject,handles)
        
function log_r_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function show_dir_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% ======================================================================= %
function show_dir_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function show_dir_KeyPressFcn(hObject, eventdata, handles)
% --------------------------------------------------------------------
function file_m_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function cnm_m_Callback(hObject, eventdata, handles)
open('MergeG.fig')
% --------------------------------------------------------------------
function filter_m_Callback(hObject, eventdata, handles)
open('FilterG.fig')
% --------------------------------------------------------------------
function X_corr_Callback(hObject, eventdata, handles)
open('XcorrG.fig')
% --------------------------------------------------------------------
function stack_m_Callback(hObject, eventdata, handles)
open('StackG_V2.fig')
% --------------------------------------------------------------------
function dispersion_m_Callback(hObject, eventdata, handles)
open('DispersionG.fig')
% --------------------------------------------------------------------
function map_m_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function open_m_Callback(hObject, eventdata, handles)
try
addpath(pwd)
folder_name = uigetdir('C:\');
addpath(folder_name)
% set(handles.browse_text,'string',folder_name)
all_files=dir(folder_name);
all_files=struct2cell(all_files)';
all_files=all_files(:,1);
set(handles.show_dir,'string',all_files)
handles.NL=all_files;
sz=size(all_files,1);
cl=clock;
if sz>=1
    rep1=([date ' ' num2str(cl(1,4)) ':' num2str(cl(1,5)) ...
        ':' num2str(floor(cl(1,5))) ...
        ' Open dir: Successully added ' num2str(sz) ' files']);
else
    rep1=([date ' ' num2str(cl(1,4)) ':' num2str(cl(1,5)) ...
        ':' num2str(floor(cl(1,5))) ...
        ' Open dir: Successfully added ' num2str(sz) ' file']);
end
try
    handles.log=[rep1 handles.log];
catch
    handles.log{1}=rep1;
end
set(handles.log_r,'string',handles.log)
guidata(hObject,handles)
coor_b_Callback(hObject,eventdata,handles)
catch
    %cancel    
end

% Saving images in axes ================================================= %
function save_m_Callback(hObject, eventdata, handles)
    save_f(hObject,eventdata,handles)
    
function save_b2(hObject, eventdata)
    save_f(hObject,eventdata)

function save_f(varargin)
[hObject,eventdata]=varargin{[1,2]};
handles=guidata(hObject);
switch get(handles.radio1,'value')
    case 1
        [Xfile, Xpath, FI]=uiputfile({'*.fig';'*.jpg';'*.bmp';'*.png'}, ...
        'Save 2D map as...','');
        save_opt='2D map';
        save_ax(hObject,eventdata,Xfile,Xpath,save_opt,FI)
    otherwise
        save_opt=questdlg ...
            ('Which image do you want to save?', ...
            'Saving file...', ...
            '3D map','Slicing map','Both maps','Both maps');        
    switch save_opt
        case '3D map'
            [Xfile, Xpath, FI]=uiputfile({'*.fig';'*.jpg';'*.bmp'; ...
                '*.png'},'Save 3D map as...','');
                save_ax(hObject,eventdata,Xfile,Xpath,save_opt,FI)              
        case 'Slicing map'
            [Xfile, Xpath, FI]=uiputfile({'*.fig';'*.jpg';'*.bmp'; ...
                '*.png'},'Save Slicing map as...','');
            save_ax(hObject,eventdata,Xfile,Xpath,save_opt,FI)              
        otherwise %'Both maps'
            [Xfile, Xpath, FI]=uiputfile({'*.fig';'*.jpg';'*.bmp'; ...
                '*.png'},'Save 3D map as...','');
            save_ax(hObject,eventdata,Xfile,Xpath,save_opt,FI) 
    end            
end

% Saving axes image function -------------------------------------------- %
function save_ax(hObject,eventdata,Xfile,Xpath,save_opt,FI)
    handles=guidata(hObject);
    if strcmp(save_opt,'Cancel')
        %skip
    else
    temp_fig=figure('unit','pixel','position', ...
        [100 100 1000 630],'visible','off','numbertitle','off');
    idf_loop=0;
    switch save_opt
        case '2D map'
            dfile=copyobj(handles.axesm,temp_fig);
            cobarfile=copyobj(handles.colb1,temp_fig);
            set(temp_fig,'name','2D map')
        case '3D map'
            dfile=copyobj(handles.axes2,temp_fig);
            cobarfile=copyobj(handles.colb2,temp_fig);
            set(temp_fig,'name','3D map')
        case 'Slicing map'
            dfile=copyobj(handles.axes3,temp_fig);
            cobarfile=copyobj(handles.colb3,temp_fig); 
            set(temp_fig,'name','Slicing map')
        otherwise %'Both maps'
            dfile=copyobj(handles.axes2,temp_fig);
            cobarfile=copyobj(handles.colb2,temp_fig);
            set(temp_fig,'name','3D map')
            save_opt='Slicing map';
            idf_loop=1;
    end
    set(dfile,'unit','pixel','position',[80 70 800 500])
    set(cobarfile,'unit','pixel','position',[900 70 30 500])  
    switch FI 
        case 1
            set(temp_fig,'visible','on')           
        otherwise
            set(temp_fig,'paperunits','centimeters','paperposition', ...
            [3.2 4 26.8 16.2])
    end
    saveas(temp_fig,fullfile(Xpath,Xfile))
    close(temp_fig)    
        if idf_loop==1
            [Xfile, Xpath, FI]=uiputfile({'*.fig';'*.jpg';'*.bmp'; ...
                '*.png'},'Save Slicing map as...','');
            save_ax(hObject,eventdata,Xfile,Xpath,save_opt,FI)
        else
            %skip
        end
    end

% Quit/close current GUI ================================================ %
function quit_m_Callback(hObject, eventdata, handles)
choice = questdlg('Do you want to quit?', ...
	'Close GUI', ...
	'Yes','No','No');
switch choice
    case 'Yes'
        close(gcf)
    otherwise
        %cancel
end

function Untitled_6_Callback(hObject, eventdata, handles)


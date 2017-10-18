function varargout = DispersionG(varargin)
% DISPERSIONG MATLAB code for DispersionG.fig
%      DISPERSIONG, by itself, creates a new DISPERSIONG or raises the existing
%      singleton*.
%
%      H = DISPERSIONG returns the handle to a new DISPERSIONG or the handle to
%      the existing singleton*.
%
%      DISPERSIONG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPERSIONG.M with the given input arguments.
%
%      DISPERSIONG('Property','Value',...) creates a new DISPERSIONG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DispersionG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DispersionG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DispersionG

% Last Modified by GUIDE v2.5 06-Mar-2016 09:54:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DispersionG_OpeningFcn, ...
                   'gui_OutputFcn',  @DispersionG_OutputFcn, ...
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

function DispersionG_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
addpath(pwd)
handles.pos1x=get(handles.pop1,'position');
handles.pos2x=get(handles.load_b,'position');
handles.pos3x=get(handles.auto_p,'position');
handles.pos4x=get(handles.hide_b,'position');
handles.posz1=get(handles.uitable_dat,'position');
handles.posz2=get(handles.text4,'position');
set(handles.slider2,'max',1,'min',0.05,'value',0.1)
set(handles.slider3,'max',10,'min',1,'value',3,'sliderstep',[0.1 0.1])
set(handles.uitable_disp,'columnname',{'Period(s)', ...
    'Velocity(km/s)','Time lag(s)','Data input'},'columnformat',{'char', ...
    'char','char','logical'},'columneditable',[false true true true], ...
    'columnwidth',{70 110 85 70}, ...
    'celleditcallback',{@edit_tab})
set(handles.axes2,'buttondownfcn', ...
    @update_curve);
set(handles.slider2,'max',0.99,'min',0.05)
set([handles.slider2, handles.slider3, handles.e_span, ...
    handles.e_deg, handles.pop_method],'enable','off')
% Update handles structure
guidata(hObject, handles);

function varargout = DispersionG_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function load_b_Callback(hObject, eventdata, handles)
cla(handles.axes1)
cla(handles.axes2)
try    handles=rmfield(handles,'F');end
try    handles=rmfield(handles,'F1');end
try    handles=rmfield(handles,'F2');end
hold off
n=get(handles.pop1,'value');
s_name=handles.s_name;
tab_n=handles.tab_n;
table_dat=tab_n.(s_name{n});
table_datX=table_dat(:,1:7);
% datX=tab_n.(s_name{n});
distance=table_dat{1,6};
set(handles.uitable_dat,'data',table_datX)
% HV=[handles.uitable_dat]
set(handles.uitable_dat,'visible','on','enable','on')
set(handles.axes2,'visible','on')
q=0;
for m=1:size(table_datX,1)
    bw=strrep(table_datX{m,3},'Hz','');
    bw=strsplit(bw,'-');
    mf=(str2num(bw{1})+str2num(bw{2}))/2;
    Ploc{m,1}=[num2str(mf) 'Hz'];
end
for n=1:size(table_dat,1)
    load([table_dat{n,8}]);
    max_d=max(n_data);
    n_data=(n_data/max_d)*(1/2);
    max_t=str2num(inf_dat{7});
    ytickz{n}=q;
    q=q+1;
    yticklabelz{n}=table_datX{n,3};    
    %Plotting peak auto detect--------------------------------------------%
    if  (get(handles.auto_p,'Value') == get(handles.auto_p,'Max'))
        [Yp,Xp] = findpeaks(n_data,'SortStr','descend');
        [Yn,Xn] = findpeaks((n_data*-1),'SortStr','descend');
        GbY=[Yp;Yn]; [Ys, I]=sort(GbY,'descend');
        GbX=[Xp;Xn]; [Xs]=sort(GbX,'descend'); 
        Xloc=GbX(I(1));
        Tloc=(Xloc/inf_dat{5})-((str2num(inf_dat{4})/inf_dat{5})/2);
        Ym=Ys(1);
        set(handles.axes2,'nextplot','add')
        P(n)=plot([Tloc Tloc],[(n-1)-0.5,(n-1)+0.5],'color','r','linewidth',...
            1.4,'Parent', handles.axes2, 'Tag', 'ThePlotTag', 'HitTest', 'off');hold on
        %Creating data for dispersion table-------------------------------%
        F2(n)=abs(str2num(distance)/Tloc)*1000;        
        Ploc{n,2}=num2str(F2(n)/1000);
        Ploc{n,3}=num2str(Tloc);
        %Ploting dispersion curve-----------------------------------------%        
        mf2=strrep(Ploc{n,1},'Hz','');
        F1(n)=1/str2num(mf2);
        set(handles.axes1,'nextplot','add')
        Dc(n)=plot(abs(1/str2num(mf2)),...
                abs(str2num(Ploc{n,2})*1000),'b.','parent',handles.axes1);        
        %-----------------------------------------------------------------%
    else
        %skip
    end
    %---------------------------------------------------------------------%
    set(handles.axes2,'nextplot','add')
    LX=linspace(-max_t,max_t,str2num(inf_dat{4}));
    plot(LX,n_data+(n-1),'Parent', handles.axes2, 'Tag', 'ThePlotTag', 'HitTest', 'off');hold on
end
ytickz=cell2mat(ytickz);
set(handles.axes2,'ytick',ytickz,'yticklabel',yticklabelz, ...
    'fontsize',7,'fontweight','bold')
set(handles.axes1,'fontsize',7)
set(get(handles.axes2,'ylabel'),'string','Frequency')
set(get(handles.axes2,'xlabel'),'string','Time lag (second)')
set(get(handles.axes1,'ylabel'),'string','Phase velocity (m/s)')
set(get(handles.axes1,'xlabel'),'string','Period (second)')
set(get(handles.axes1,'title'),'string','Dispersion curve')
set([handles.axes2 handles.axes1],'xtickmode','auto','xticklabelmode','auto')
set(handles.axes1,'ytickmode','auto','yticklabelmode','auto')

Ehandles=[handles.dat_table handles.disp_table handles.uitable_disp];
set(Ehandles,'enable','on')
set(handles.dat_table,'value',1)
set(handles.disp_table,'value',0)
set([handles.uitable_dat handles.text8],'visible','on')
%--------------
try
    sd=smooth(F1,F2,20,'loess');F1=F1';
    sd=polyfit(F1,sd,3); %     
    x1=min(F1);
    x2=max(F1);
    xx=linspace(x2,x1,100);
    sd2=polyval(sd,xx);
    try delete(sm); end
    sm=plot(xx,sd2,'parent',handles.axes1);
    handles.sm=sm;
    handles.sd=sd;
    handles.F1=F1;
    handles.F2=F2;
end
for k=1:size(Ploc,1)
    h2p=strrep(Ploc{k,1},'Hz','');
    h2p=1/str2double(h2p);
    h2p=sprintf('%0.2f',h2p);
    per{k}=h2p;
end
new_Ploc=Ploc;
new_Ploc(:,1)=per';
for k=1:size(new_Ploc,1)
    if get(handles.auto_p,'value')==0
    new_Ploc{k,4}=false;
    else
    new_Ploc{k,4}=true;
    end
end
try handles.Ploc=Ploc; end
try handles.new_Ploc=new_Ploc; end
try handles.P=P; end
try handles.Dc=Dc; end
% Plotting PREM data------------------------------------------------------%
load('prem_dat2')
plot(per,prem,'parent',handles.axes1,'color',[0 0 0]);
% Enable/disable save button ---------------------------------------------%
nX=0;
for m=1:size(new_Ploc,1)
    if new_Ploc{m,4}==true
        nX=nX+1;
    else
        %skip
    end
end
set([handles.slider2, handles.slider3, handles.e_span, ...
    handles.e_deg, handles.pop_method],'enable','on')
if nX>=3
    set(handles.save_b,'enable','on')
else
    set(handles.save_b,'enable','off')
end
%-------------------------------------------------------------------------%
guidata(hObject,handles)  
set(handles.uitable_disp,'data',new_Ploc)
guidata(hObject,handles)  

% Load the data ==========================================================%
function add_b_Callback(hObject, eventdata, handles)

if isfield(handles,'NL') 
sta_list=handles.NL;
selected_file={};
m=1;
h=waitbar(0,'loading files...');
for i=1:length(sta_list)
                v=regexp(sta_list(i),['S_\w*.mat'],'match');
            if  (~isempty(v{1}))
                selected_file{end+1}=sta_list{i};
            end
end
for i=1:length(selected_file)
    load([selected_file{i}]);
    All_inf(i,1:7)=inf_dat(1:7);    
    All_inf(i,8)={[selected_file{i}]};  
    bwz=strrep(All_inf{i,3},'Hz','');
    bwz=strsplit(bwz,'-');
    bwx=str2double(bwz{1})+(str2double(bwz{2})-str2double(bwz{1}));
    All_inf{i,9}=bwx;
end
p1=1;p2=1;p3=1;p4=1;
All_inf=sortrows(All_inf,[1 2 5 9 3]);
All_infb=sortrows(All_inf,2);
All_infc=sortrows(All_inf,3);
All_infd=sortrows(All_inf,5);
for m=2:(length(selected_file))
    a1=All_inf{m-1,1};a2=All_inf{m,1};
    b1=All_infb{m-1,2};b2=All_infb{m,2};    
    c1=All_infb{m-1,3};c2=All_infb{m,3};
    d1=All_infd{m-1,5};d2=All_infd{m,5};
    bw_dot{p3}=c1;
    c1=strrep(c1,'.','');
    c1=strrep(c1,'-','_');
    aa=strrep(a1,'-','_');
    pairlist{p1}=aa;
    chalist{p2}=b1;
    bwlist{p3}=c1;
    srlist{p4}=d1;
    n_match1=strmatch(a1,a2);
    n_match2=strmatch(b1,b2);
    n_match3=strmatch(c1,c2);
    n_match4=strmatch(d1,d2);
    if ~isempty(n_match1)
        a1=strrep(a1,'-','_');
        pairlist{p1}=a1;
    else
        p1=p1+1;
        a2=strrep(a2,'-','_');
        pairlist{p1}=a2;
    end
    %
    if ~isempty(n_match2)
        chalist{p2}=b1;
    else
        p2=p2+1;
        chalist{p2}=b2;
    end
    %
    if ~isempty(n_match3)
        bw_dot{p3}=c1;
        c1=strrep(c1,'.','');
        c1=strrep(c1,'-','_');
        bwlist{p3}=c1;
    else
        p3=p3+1;
        bw_dot{p3}=c2;
        c2=strrep(c2,'.','');
        c2=strrep(c2,'-','_');
        bwlist{p3}=c2;
    end
    %    
    if ~isempty(n_match4)     
        srlist{p4}=d1;
    else
        p4=p4+1;      
        srlist{p4}=d2;
    end
end
waitbar(0,h,['Sorting files and creating table... (0/2)']);
q=1;
for n1=1:length(pairlist)
    for n2=1:length(chalist)        
        for n3=1:length(srlist)
            f_name={['S_' pairlist{n1} '_' chalist{n2} '_' '\w*' '_' num2str(srlist{n3})]};
            s_name(q)={['S_' pairlist{n1} '_' chalist{n2} '_' num2str(srlist{n3})]};
            p=1;
            for n4=1:size(All_inf,1)
                v=regexp(All_inf{n4,8},f_name,'match');                
                if ~isempty(v{1})
                    tab_x(p,:)=All_inf(n4,:);
                    p=p+1;
                end
                tab_n.(s_name{q})=tab_x;
            end
            q=q+1;
        end       
    end    
end
waitbar(1/2,h,['Saving handles... (1/2)']);
handles.tab_n=tab_n;
handles.s_name=s_name;
set(handles.pop1,'string',s_name)
% % set(handles.uitable1,'data',Tablist.(tab_n{1}))
hE=[handles.pop1 handles.load_b handles.auto_p handles.hide_b];
set(hE,'visible','on');
set(hE,'enable','on');
guidata(hObject,handles)
waitbar(1,h,['Completed']);
close(h)
else    
    msgbox('No input data found','Failed to load data','warn')    
end

function pop1_Callback(hObject, eventdata, handles)
n=get(handles.pop1,'value');
tab_n=handles.tab_n;
set(handles.uitable_dat,'data',tab_n.(handles.s_name{n}))

function pop1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function show_dir_Callback(hObject, eventdata, handles)

function show_dir_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function browse_t_Callback(hObject, eventdata, handles)

function browse_t_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function browse_b_Callback(hObject, eventdata, handles)
folder_name = uigetdir('C:\');
set(handles.browse_t,'string',folder_name)
handles.bf=folder_name;
all_files=dir(folder_name);
all_files=struct2cell(all_files)';
all_files=all_files(:,1);
set(handles.show_dir,'string',all_files)
handles.NL=all_files;
sz=size(all_files,1);
cl=clock;
rep1=([date ' ' num2str(cl(1,4)) ':' num2str(cl(1,5)) ':'...
        num2str(floor(cl(1,5))) ' Open dir: ' num2str(sz) ' files are found']);
handles.log{1}=rep1;
set(handles.r_log2,'string',rep1)
guidata(hObject,handles)

function r_log2_Callback(hObject, eventdata, handles)

function r_log2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function show_dir_ButtonDownFcn(hObject, eventdata, handles)
seltype = get(gcf,'selectiontype');
del_row=get(handles.show_dir,'Value');
hcmenu = uicontextmenu;
item1 = uimenu(hcmenu,'Label','Delete','Callback', ...
    {@opsi1,hObject,eventdata,handles});
item2 = uimenu(hcmenu,'Label','Add file');
item2_2=uimenu(item2,'Label','Select file(s)...','Callback', ...
    {@opsi3,hObject,eventdata,handles});
item2_1=uimenu(item2,'Label','All files in a folder...','Callback', ...
    {@opsi2,hObject,eventdata,handles});
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
            cd(folder_name)
            addpath(folder_name)
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
            set(handles.add_b,'enable','on')
            guidata(hObject,handles)
            catch
                %skip
            end
            
function reset_b_Callback(hObject, eventdata, handles)
cla(handles.axes1)
cla(handles.axes2)
set([handles.axes1 handles.axes2],'ytick',[],'xtick',[])
blankx={};
% Hblank= [handles.ucornerx, handles.lcornerx, handles.center_freq, ...
%         handles.gauss_dev];
set(handles.uitable_dat,'data',blankx)
set(handles.uitable_disp,'data',blankx)
set(handles.show_dir,'string',blankx)
% set(handles.tdlim,'string',[])
set(handles.pop1,'string','-','value',1)
set(handles.auto_p,'value',0)
% handles.NL=blankx;
% 
 try    handles=rmfield(handles,'tab_n');end
 try    handles=rmfield(handles,'s_name');end
 try    handles=rmfield(handles,'P');end
 try    handles=rmfield(handles,'Ploc');end
 try    handles=rmfield(handles,'Dc');end
 try    handles=rmfield(handles,'NL');end
 try    handles=rmfield(handles,'tab_n');end
 try    handles=rmfield(handles,'new_Ploc');end
 try    handles=rmfield(handles,'F');end
 try    handles=rmfield(handles,'F1');end
 try    handles=rmfield(handles,'F2');end
 try    handles=rmfield(handles,'sm');end
%   
handlesX=[handles.pop1, handles.load_b, handles.auto_p, handles.add_b, ...
        handles.save_b, handles.slider2, handles.slider3, handles.e_span, ...
        handles.e_deg, handles.pop_method];
% handlesX2=  [handles.auto_p];
set(handlesX,'enable','off')
% set(handlesX2,'value',0)
% % set(handles.time_lag,'string','Time lag:')
% set(findall(handles.axes1, '-property', 'visible'), 'visible', 'off')
guidata(hObject,handles)

function auto_p_Callback(hObject, eventdata, handles)

% Save Button ============================================================%
function save_b_Callback(hObject, eventdata, handles)
folder_name=uigetdir(pwd,'Select directory to save');
s_name=handles.s_name;
sd=handles.sd;
new_Ploc=handles.new_Ploc;
pop_val=get(handles.pop1,'value');
cd(folder_name)
% 
h=waitbar(0,'Saving file...');
f_name=strrep(s_name{pop_val},'S_','D_');
k=1;
for j=1:length(new_Ploc)
    if new_Ploc{j,4}==true
        perX(k,1)=new_Ploc(j,1);
        k=k+1;
    else
        %skip
    end
end
p_max=max(str2double(perX(:,1)));
p_min=min(str2double(perX(:,1)));
strx=strsplit(f_name,'_');
sta1=strx{2};
sta2=strx{3};
pair=strjoin({sta1,sta2},'-');
inf_dat{1,1}=pair;
inf_dat(1,2:3)=strx(1,4:5);
inf_dat{4}=p_min;
inf_dat{5}=p_max;
eq_dat=sd;
disp('check')
save(f_name,'eq_dat','inf_dat')
%
close(h)

function file_m_Callback(hObject, eventdata, handles)

function Untitled_2_Callback(hObject, eventdata, handles)

function cnm_m_Callback(hObject, eventdata, handles)
MergeG

function filter_m_Callback(hObject, eventdata, handles)
FilterG

function x_corr_m_Callback(hObject, eventdata, handles)
XcorrG

function stack_m_Callback(hObject, eventdata, handles)
StackG_V2

function disperion_m_Callback(hObject, eventdata, handles)

function mapping_m_Callback(hObject, eventdata, handles)
MappingG

% Opening/load file from menubar ======================================== % 
function open_m_Callback(hObject, eventdata, handles)
folder_name = uigetdir(pwd);
try
addpath(folder_name)
cd(folder_name)
% set(handles.browse_text,'string',folder_name)
all_files=dir(folder_name);
all_files=struct2cell(all_files)';
all_files=all_files(:,1);
if isfield(handles,'NL')
handles.NL=[handles.NL; all_files];    
else
handles.NL=all_files;
end
set(handles.show_dir,'string',handles.NL)
sz=size(all_files,1);
cl=clock;
if sz>=1
rep1=([date ' ' num2str(cl(1,4)) ':' num2str(cl(1,5)) ':'...
        num2str(floor(cl(1,5))) ' Open dir: ' num2str(sz) ...
        ' files are found']);
else
    rep1=([date ' ' num2str(cl(1,4)) ':' num2str(cl(1,5)) ':'...
        num2str(floor(cl(1,5))) ' Open dir: ' num2str(sz) ...
        ' file is found']);
end
handles.log{1}=rep1;
set(handles.r_log2,'string',rep1)
set(handles.add_b,'enable','on')
guidata(hObject,handles)
catch
    %skip
end

% Saving function ======================================================= %
function save_m_Callback(hObject, eventdata, handles)
folder_name=uigetdir(pwd,'Select directory to save');
s_name=handles.s_name;
sd=handles.sd;
new_Ploc=handles.new_Ploc;
pop_val=get(handles.pop1,'value');
cd(folder_name)
% 
h=waitbar(0,'Saving file...');
f_name=strrep(s_name{pop_val},'S_','D_');
p_max=max(str2double(new_Ploc(:,1)));
p_min=min(str2double(new_Ploc(:,1)));
strx=strsplit(f_name,'_');
sta1=strx{2};
sta2=strx{3};
pair=strjoin({sta1,sta2},'-');
inf_dat{1,1}=pair;
inf_dat(1,2:3)=strx(1,4:5);
inf_dat{4}=p_min;
inf_dat{5}=p_max;
eq_dat=sd;
disp('check')
save(f_name,'eq_dat','inf_dat')
%
close(h)

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
    
function hide_b_Callback(hObject, eventdata, handles)
set(handles.uipanel1,'visible','off')
handles.axpos=get(handles.axes2,'position');
pos1=handles.pos1x; pos1(1)=pos1(1)-44;
pos2=handles.pos2x; pos2(1)=pos2(1)-44;
pos3=handles.pos3x; pos3(1)=pos3(1)-44;
pos4=handles.pos4x; pos4(1)=pos4(1)-44;
set(handles.pop1,'position',pos1)
set(handles.load_b,'position',pos2)
set(handles.auto_p,'position',pos3)
handles.show_b=uicontrol('parent',gcf,'units','characters','position',pos4, ...
'style','pushbutton','string','Minimize','foregroundcolor','b');
guidata(handles.show_b,handles)
set(handles.show_b,'callback',{@show_files,hObject,eventdata,handles})
axpos2=handles.axpos;
axpos2(1)=20;axpos2(3)=128;
set(handles.axes2,'position',axpos2)
set(handles.hide_b,'visible','off')
guidata(handles.show_b,handles)

    function show_files(varargin)
        hObject=varargin{3};
        handles=varargin{5};
        set([handles.uipanel1 handles.hide_b],'visible','on')
        set(handles.axes2,'position',handles.axpos)
        delete(handles.show_b)
        set(handles.pop1,'position',handles.pos1x)
        set(handles.load_b,'position',handles.pos2x)
        set(handles.auto_p,'position',handles.pos3x)
        guidata(hObject,handles)

function coor_table_Callback(hObject, eventdata, handles)

function dat_table_Callback(hObject, eventdata, handles)

set([handles.uitable_dat handles.text8],'visible','on')
set([handles.uitable_disp handles.text4],'visible','off')
set(handles.disp_table,'value',0)

function disp_table_Callback(hObject, eventdata, handles)

set([handles.uitable_disp handles.text4],'visible','on')
set([handles.uitable_dat handles.text8],'visible','off')
set( handles.dat_table,'value',0)

function axes2_DeleteFcn(hObject, eventdata, handles)

function coor_b_Callback(hObject, eventdata, handles)
[a b]=uigetfile('*.txt','C:/');
addpath(b)
coor=readtable(a,'delimiter',' ','ReadVariableNames',false);
coor=table2cell(coor);
coor2=coor;
for n1=2:3;
    for n2=1:size(coor,1);
        coor2{n2,n1}=sprintf('%0.2f',coor{n2,n1});
    end
end
for m1=1:size(coor,1)
    sta_n{m1}=coor{m1,1};
    dcoor.(sta_n{m1})=coor(m1,2:3);
end
handles.dcoor=dcoor;
set(handles.uitable2,'data',coor2)
set([handles.text4, handles.uitable2],'visible','on')
set([handles.uitable2, handles.add_b],'enable','on')
guidata(hObject,handles)

function pushbutton17_Callback(hObject, eventdata, handles)

function hide_b_ButtonDownFcn(hObject, eventdata, handles)

function axes2_CreateFcn(hObject, eventdata, handles)

function slider2_CreateFcn(hObject, ~, ~)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Text box smoothong span ================================================%
function e_span_Callback(hObject, eventdata, handles)
% Verifying input & updating uicontrols ----------------------------------%
n=str2num(get(hObject,'string'));
if (~isnan(n) && isnumeric(n) && isreal(n))
    if n>=0.99
        set(handles.slider2,'value',0.99)
        set(handles.e_span,'string','0.99')
    elseif n<=0.05
        set(handles.slider2,'value',0.05)
        set(handles.e_span,'string','0.05')
    else
        n=sprintf('%0.02f',n);        
        set(handles.slider2,'string',str2double(n))
        set(handles.e_span,'string',n)
    end 
    update_customization(hObject)
else
    %skip
end

function e_span_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%=========================================================================%
function slider2_Callback(hObject, eventdata, handles)    
% Verifying input & updating uicontrols ----------------------------------%
n=get(handles.slider2,'value');
if n>=0.99
    set(handles.slider2,'value',0.99)
    set(handles.e_span,'string','0.99')
elseif n<=0.05
    set(handles.slider2,'value',0.05)
    set(handles.e_span,'string','0.05')
else
    n2=sprintf('%0.02f',n);
    n=str2double(n2);
    set(handles.e_span,'string',n2)
end
update_customization(hObject);

%=========================================================================%
function pushbutton18_Callback(hObject, eventdata, handles)
n=get(hObject,'value');
vhandles=[handles.text9 handles.text10 handles.text11 ...
        handles.slider2 handles.slider3 handles.e_span handles.e_deg ...
        handles.pop_method handles.text12 handles.text13];
if n==1
    set(vhandles,'visible','on')
    posz1=handles.posz1;posz1(4)=7;    
    posz2=handles.posz2;posz2(2)=12.5;    
    set([handles.uitable_dat handles.uitable_disp],'position',posz1)
    set([handles.text4 handles.text8],'position',posz2)
    set(handles.pushbutton18,'string','-')
else
    set(vhandles,'visible','off')
    posz1=handles.posz1;%posz1(4)=7;    
    posz2=handles.posz2;%posz2(2)=12.5;    
    set([handles.uitable_dat handles.uitable_disp],'position',posz1)
    set([handles.text4 handles.text8],'position',posz2)
    set(handles.pushbutton18,'string','+')
end

%=========================================================================%
function pop_method_Callback(hObject, eventdata, handles)    
update_customization(hObject);

function pop_method_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Degree slider ==========================================================%
function slider3_Callback(hObject, eventdata, handles)
n2=get(handles.slider3,'value');
n2=ceil(n2);
% Verifying input % updating uicontrols ----------------------------------%
if n2>=10
    set(handles.slider3,'value',10)
    set(handles.e_deg,'string','10')
elseif n2<=0.05
    set(handles.slider3,'value',1)
    set(handles.e_deg,'string','1')
else    
    set(handles.e_deg,'string',n2)
end 
update_customization(hObject)

%=========================================================================%
function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%=========================================================================%
function e_deg_Callback(hObject, eventdata, handles)    
% Verifying input % updating uicontrols ----------------------------------%
n2=get(handles.e_deg,'string');
n2=str2double(n2);
if (~isnan(n2) && isnumeric(n2) && isreal(n2))
    n2=ceil(n2);
    if n2>=10
        set(handles.slider3,'value',10)
        set(handles.e_deg,'string','10')
    elseif n2<=0.05
        set(handles.slider3,'value',1)
        set(handles.e_deg,'string','1')
    else    
        set(handles.e_deg,'string',n2)
        set(handles.slider3,'value',n2)
    end 
update_customization(hObject)
else
    %skip
end

function e_deg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%=========================================================================%
function uitable_disp_CellSelectionCallback(hObject, eventdata, handles)
%skip

% Updating dispersion curve ==============================================%
 function update_curve(hObject,eventdata)
handles=guidata(hObject);
seltype=get(gcf,'selectiontype');
n=get(handles.pop1,'value');
s_name=handles.s_name;
tab_n=handles.tab_n;
datX=tab_n.(s_name{n});
distance=datX{1,6};
mx=0;
try
P=handles.P;
Ploc=handles.Ploc;
Dc=handles.Dc;
end
try sm=handles.sm;end
F=cell([size(datX,1) 2]);
try F=handles.F;end
for m=1:size(datX,1)
    bw=strrep(datX{m,3},'Hz','');
    bw=strsplit(bw,'-');
    mf=(str2num(bw{1})+str2num(bw{2}))/2;
    Ploc{m,1}=[num2str(mf) 'Hz'];
end
if strmatch(seltype,'normal')
    p = get(handles.axes2, 'currentpoint'); 
    px=p(1);
    py=round(p(3));
    hold(handles.axes2)
    try
        delete(P(py+1))
    end
    hold(handles.axes2)
    Ploc{py+1,2}=num2str(str2num(distance)/px);
    Ploc{py+1,3}=num2str(px);
    P(py+1)=plot([px px],[py-.5 py+.5],'r', ...
        'parent',handles.axes2,'hittest','off');
end
for m=1:size(datX)
    mf2=strrep(Ploc{m,1},'Hz','');
    try
    a=abs(1/str2num(mf2));
    b=abs(str2num(Ploc{m,2})*1000);
    F{m,1}=a;
    F{m,2}=b;
    end
    if ~isempty(F{m})
        mx=mx+1;
    end
end
try
    delete(Dc(py+1))
end
mf2=strrep(Ploc{py+1,1},'Hz','');
set(handles.axes1,'nextplot','add')
Dc(py+1)=plot(abs(1/str2num(mf2)),...
        abs(str2num(Ploc{py+1,2})*1000),'color','r', ... 
        'marker','o','parent',handles.axes1);
%-------------------------------------------------------------------------%
new_Ploc=handles.new_Ploc;
new_Ploc(py+1,2:3)=Ploc(py+1,2:3);
new_Ploc{py+1,4}=true;
perX=str2double(new_Ploc(:,1));
min_per=min(perX);
max_per=max(perX);
% Acquiring non-empty data -----------------------------------------------%
m=1;
for n=1:size(new_Ploc,1)
    if (~isempty(new_Ploc{n,2}) && new_Ploc{n,4}==true)
        sel_rows(m,1:2)=new_Ploc(n,1:2);
        m=m+1;
    else
        %skip
    end
end
% Retriving additional data from smoothing customization -----------------%
n=get(handles.slider2,'value');
n2=get(handles.slider3,'value');
meth=get(handles.pop_method,'value');
n2=ceil(n2);
%-------------------------------------------------------------------------%
if mx>=3
    if meth==1
        methX='moving';
    elseif meth==2
        methX='loess';
    elseif meth==3
        methX='rloess';
    else
        %shouldn't be happen...
    end
    try
        F1=str2double(sel_rows(:,1));
        F2=abs(str2double(sel_rows(:,2))*1000);   
    catch
        F1=cell2mat(F(:,1));
        F2=cell2mat(F(:,2));
    end
    x1=min(F1);
    x2=max(F1);
    xx=linspace(x2,x1,100);
    switch get(handles.pop_method,'value')
        case 4
            modelFun2=@(b,F1) b(1).*(1-exp(-b(2).*F1));
            nlm=fitnlm(F1,F2,modelFun2,[3500; .5]);
            yy=predict(nlm,xx');
            sd=polyfit(xx,yy',n2);
            try delete(sm); end 
            sm=plot(xx,yy,'parent',handles.axes1);
            handles.sm=sm;
            handles.sd=sd;
            handles.F1=F1;
            handles.F2=F2;
        otherwise
            tl=smooth(F1,F2,n,methX);            
            sd=polyfit(F1,tl,n2);
            sd2=polyval(sd,xx);
            try delete(sm); end 
            sm=plot(xx,sd2,'parent',handles.axes1);
            handles.sm=sm;
            handles.sd=sd;
            handles.F1=F1;
            handles.F2=F2;
    end
else
end
handles.Ploc=Ploc;
handles.new_Ploc=new_Ploc;
handles.P=P;
handles.Dc=Dc;
handles.F=F;
set(handles.axes1,'Xlim',[min_per max_per])
set(handles.uitable_disp,'data',new_Ploc,'enable','on')
% Enable/disable save button ---------------------------------------------%
nX=0;
for m=1:size(new_Ploc,1)
    if new_Ploc{m,4}==true
        nX=nX+1;
    else
        %skip
    end
end
if nX>=3
    set(handles.save_b,'enable','on')
else
    set(handles.save_b,'enable','off')
end
th=1;
handles.th=th;
%-------------------------------------------------------------------------%
guidata(hObject,handles)


% Edit cell dispersion table =============================================%
 function edit_tab(hObject, eventdata)
handles=guidata(hObject);
rowx=eventdata.Indices(1);
colx=eventdata.Indices(2);
idfx=false;
try
P=handles.P;
Ploc=handles.Ploc;
Dc=handles.Dc;
end
try sm=handles.sm;end
new_Ploc=get(handles.uitable_disp,'data');
% Updating velocity or time lag ------------------------------------------%
if (colx==2 || colx==3)
    new_Ploc=get(handles.uitable_disp,'data');
    if (isreal(new_Ploc{rowx,colx}) && colx==3)
        temp_dat=get(handles.uitable_dat,'data');
        dist=str2double(temp_dat{1,6});
        time_lag=new_Ploc{rowx,colx};
        try 
            vel=num2str(dist/time_lag);
        catch
            vel=num2str(dist/str2double(time_lag));
        end
        time_lag=num2str(time_lag);
        new_Ploc{rowx,colx}=time_lag;
        new_Ploc{rowx,2}=vel;
        new_Ploc{rowx,4}=true;
        set(handles.uitable_disp,'data',new_Ploc)
    elseif (isnumeric(new_Ploc{rowx,colx}) ...
            && isreal(new_Ploc{rowx,colx}) && colx==2)
        temp_dat=get(handles.uitable_dat,'data');
        dist=str2double(temp_dat{1,6});
        vel=new_Ploc{rowx,colx};
        try
            time_lag=num2str(dist/vel);
        catch
            time_lag=num2str(dist/str2double(vel));
        end
        vel=num2str(vel);
        new_Ploc{rowx,colx}=vel;
        new_Ploc{rowx,3}=time_lag;
        new_Ploc{rowx,4}=true;
        set(handles.uitable_disp,'data',new_Ploc)
    elseif (ischar(new_Ploc{rowx,colx}) || isempty(new_Ploc{rowx,colx}))
        new_Ploc{rowx,2}=[];
        new_Ploc{rowx,3}=[];
        new_Ploc{rowx,4}=false;
        set(handles.uitable_disp,'data',new_Ploc)
        idfx=true;
    else
        %skip
    end
end
%-------------------------------------------------------------------------%
if (~isempty(new_Ploc{eventdata.Indices(1),2}) || idfx==true)
n_true=0;
P=handles.P;
for i=1:size(new_Ploc,1)
    if (new_Ploc{i,4}==1)
        n_true=n_true+1;
    else
        %skip
    end
end

% Updating dot plot ------------------------------------------------------%
for k=1:length(Dc)
    try delete(Dc(k)); end
end
for l=1:length(new_Ploc)    
    if new_Ploc{l,4}==true
        Dc(l)=plot(str2double(new_Ploc{l,1}),...
            abs(str2double(new_Ploc{l,2})*1000),'color','r', ...
            'marker','o','parent',handles.axes1);
    else
        %skip
    end       
end

% Updating auto peak marker ----------------------------------------------%
for k=1:length(P)
    try delete(P(k)); end
end
for l=1:size(new_Ploc)
    if new_Ploc{l,4}==true    
    P(l)=plot([str2double(new_Ploc{l,3}) str2double(new_Ploc{l,3})], ...
        [(l-1)-.5 (l-1)+.5],'r', ...
        'parent',handles.axes2,'hittest','off');    
    else
        %skip
    end
end
% Updating curve ---------------------------------------------------------%
if n_true>=3
    % Acquiring non-empty data -------------------------------------------%
    m=1;
    for n=1:size(new_Ploc,1)
        if (~isempty(new_Ploc{n,2}) && new_Ploc{n,4}==true)
            sel_rows(m,1:2)=new_Ploc(n,1:2);
            m=m+1;
        else
            %skip
        end
    end
    % Retriving additional data from smoothing customization -------------%
    n=get(handles.slider2,'value');
    n2=get(handles.slider3,'value');
    meth=get(handles.pop_method,'value');  
    n2=ceil(n2);
    % Recreating disp. curve ---------------------------------------------%
    if meth==1
        methX='moving';
    elseif meth==2
        methX='loess';
    elseif meth==3
        methX='rloess';
    else
        %shouldn't be happen...
    end
    try
        F1=str2double(sel_rows(:,1));
        F2=abs(str2double(sel_rows(:,2))*1000);   
    catch
        F1=cell2mat(F(:,1));
        F2=cell2mat(F(:,2));
    end
    x1=min(F1);
    x2=max(F1);
    xx=linspace(x2,x1,100);
    switch get(handles.pop_method,'value')
        case 4
            modelFun2=@(b,F1) b(1).*(1-exp(-b(2).*F1));
            nlm=fitnlm(F1,F2,modelFun2,[3500; .5]);
            yy=predict(nlm,xx');
            sd=polyfit(xx,yy',n2);
            try delete(sm); end 
            sm=plot(xx,yy,'parent',handles.axes1);
            handles.sm=sm;
            handles.sd=sd;
            handles.F1=F1;
            handles.F2=F2;
        otherwise
            tl=smooth(F1,F2,n,methX);            
            sd=polyfit(F1,tl,n2);
            sd2=polyval(sd,xx);
            try delete(sm); end 
            sm=plot(xx,sd2,'parent',handles.axes1);
            handles.sm=sm;
            handles.sd=sd;
            handles.F1=F1;
            handles.F2=F2;
    end
else
    try delete(sm); end
end
handles.new_Ploc=new_Ploc;
handles.P=P;
handles.Dc=Dc;
guidata(hObject,handles)  
set(handles.uitable_disp,'data',new_Ploc,'enable','on')
% Enable/disable save button ---------------------------------------------%
nX=0;
for m=1:size(new_Ploc,1)
    if new_Ploc{m,4}==true
        nX=nX+1;
    else
        %skip
    end
end
if nX>=3
    set(handles.save_b,'enable','on')
else
    set(handles.save_b,'enable','off')
end
% Store data in a structure ----------------------------------------------%

set(handles.uitable_disp,'celleditcallback', ...
    {@edit_tab})
else
    if eventdata.Indices(2)==4
        new_Ploc{eventdata.Indices(1),eventdata.Indices(2)}=false(0);
    else
        %skip
    end
    set(handles.uitable_disp,'data',new_Ploc)
    guidata(hObject,handles)  
    set(handles.uitable_disp,'data',new_Ploc,'enable','on')
end

% Recreate disp. curve with new customization ============================%
 function update_customization(hObject)
% Acquiring data ---------------------------------------------------------%
handles=guidata(hObject);
n=get(handles.slider2,'value');
n2=get(handles.slider3,'value');
meth=get(handles.pop_method,'value');
F1=handles.F1;
F2=handles.F2;
sm=handles.sm;
n2=ceil(n2);
% Updating disp curve ----------------------------------------------------%
if meth==1
        methX='moving';
    elseif meth==2
        methX='loess';
    elseif meth==3
        methX='rloess';
    else
        %shouldn't be happen...
end
    x1=min(F1);
    x2=max(F1);
    xx=linspace(x2,x1,100);
    switch get(handles.pop_method,'value')
        case 4
            modelFun2=@(b,F1) b(1).*(1-exp(-b(2).*F1));
            nlm=fitnlm(F1,F2,modelFun2,[3500; .5]);
            yy=predict(nlm,xx');
            sd=polyfit(xx,yy',n2);
            try delete(sm); end 
            sm=plot(xx,yy,'parent',handles.axes1);
            handles.sm=sm;
            handles.sd=sd;
            handles.F1=F1;
            handles.F2=F2;
        otherwise
            tl=smooth(F1,F2,n,methX);            
            sd=polyfit(F1,tl,n2);
            sd2=polyval(sd,xx);
            try delete(sm); end 
            sm=plot(xx,sd2,'parent',handles.axes1);
            handles.sm=sm;
            handles.sd=sd;
            handles.F1=F1;
            handles.F2=F2;
    end
% Store data in a structure ----------------------------------------------%
handles.n=n;
handles.n2=n2;
try handles.methX=methX; end
guidata(hObject,handles)

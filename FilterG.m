function varargout = FilterG(varargin)
% FILTERG MATLAB code for FilterG.fig
%      FILTERG, by itself, creates a new FILTERG or raises the existing
%      singleton*.
%
%      H = FILTERG returns the handle to a new FILTERG or the handle to
%      the existing singleton*.
%
%      FILTERG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTERG.M with the given input arguments.
%
%      FILTERG('Property','Value',...) creates a new FILTERG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FilterG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FilterG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FilterG

% Last Modified by GUIDE v2.5 06-Mar-2016 08:52:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FilterG_OpeningFcn, ...
                   'gui_OutputFcn',  @FilterG_OutputFcn, ...
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

function FilterG_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
addpath(pwd)
guidata(hObject, handles);

function varargout = FilterG_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function file_name_Callback(hObject, eventdata, handles)
A1 = get(hObject,'String');
handles.A1=A1;
guidata(hObject,handles)

function file_name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function browse_file_Callback(hObject, eventdata, handles)
if (get(handles.mode1,'Value') == get(handles.mode1,'Max'))
[a,b,c]=uigetfile;
set(handles.file_name,'string',b);
set(handles.show_dir,'string',a);
handles.NL={a};
sz=size(a,1);
cl=clock;
rep1=([date ' ' num2str(cl(1,4)) ':' num2str(cl(1,5)) ':'...
        num2str(floor(cl(1,5))) ' Open dir: ' num2str(sz) ' file is found']);
handles.log{1}=rep1;
set(handles.log_r,'string',rep1)
guidata(hObject,handles)  
% handles.fn1=a;
% cd(b);       
%         load(a);          
%         m=mean(data);        
%         Md=data-m; 
%         handles.Dat=Md;
%         l=1:length(Md);
% handles.infodat=infodat;
% handles.length_dat=l;
% guidata(hObject,handles)
% plot(handles.axes1,l,Md);xlim([0 length(Md)]);
else
folder_name = uigetdir('C:\','Select folder to open');
cd(folder_name)
addpath(folder_name)
set(handles.file_name,'string',folder_name)

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
set(handles.log_r,'string',rep1)
guidata(hObject,handles)    
end

function ucornerx_Callback(hObject, eventdata, handles)
ucor = get(hObject,'String');
handles.ucorner=ucor;
guidata(hObject,handles)

function ucornerx_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lcornerx_Callback(hObject, eventdata, handles)
lcor = get(hObject,'String');
handles.lcorner=lcor;
guidata(hObject,handles)

function lcornerx_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sample_rate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton2_Callback(hObject, eventdata, handles)
h=waitbar(0,'Loading file...');
sta_list=handles.NL;
selected_file={};
if length(sta_list)==1;
    selected_file=sta_list;
else
for i=1:length(sta_list)
                v=regexp(sta_list(i),['M_\w*.mat'],'match');
            if  (~isempty(v{1}))
                selected_file{end+1}=sta_list{i};
            end
end
end
if length(selected_file)==1
   load([selected_file{1}])
   SR=infodat{1,7};
else
    p=1;
for m=2:(length(selected_file))
    load([selected_file{m}]);SR2=infodat{1,7};    
    load([selected_file{m-1}]);SR1=infodat{1,7};
%     SR(p)=SR1;
    if SR2==SR1
        SR(p)=SR1;
    else
        p=p+1;
        SR(p)=SR2;
    end
end
end
if (get(handles.OpsiBF,'Value') == get(handles.OpsiBF,'Max'))
    waitbar(2/4,h,'Creating filter design...');
    for m=1:length(SR)
    hp_passband=((str2double(handles.lcorner))*2)/SR(m);
    lp_passband=((str2double(handles.ucorner))*2)/SR(m);
    hp_stopband=hp_passband-(hp_passband/10);
    lp_stopband=lp_passband+(lp_passband/10);

    hpFilt=designfilt('highpassfir','StopbandFrequency',hp_stopband, ...
         'PassbandFrequency',hp_passband,'PassbandRipple',0.5, ...
         'StopbandAttenuation',100,'DesignMethod','kaiserwin');
    lpFilt=designfilt('lowpassfir','PassbandFrequency',lp_passband, ...
         'StopbandFrequency',lp_stopband,'PassbandRipple',0.5, ...
         'StopbandAttenuation',100,'DesignMethod','kaiserwin'); 
     df.('hpFilt')=hpFilt;
     df.('lpFilt')=lpFilt;
     a(m)={['df' num2str(SR(m))]};
     DF.(a{m})=df;
    end
% waitbar(3/4,h,'Filtering and normalizing data...');
for q=1:length(selected_file)
    load([selected_file{q}])
    %====%    
    bandwidth={[num2str(handles.lcorner) '-' num2str(handles.ucorner) 'Hz']};    
    infodat(8)=bandwidth;
    handles.infodat=infodat;
    %====%
    m=mean(data);        
    Md=data-m; 
    sr=num2str(infodat{1,7});
    hpFilt=DF.(['df' sr]).hpFilt;
    lpFilt=DF.(['df' sr]).lpFilt;
    Filt1 = filter(hpFilt,Md);
    Filt1 = filter(lpFilt,Filt1);
    z50=zeros(1,50)';
    Nrm=[z50;Filt1];Nrm=[Nrm;z50];
        l=length(Filt1);B=abs(Nrm);
        for  n=1:(l-100);
             x=sum(B(n:100+n))/101;
             Nrm(50+n)=Nrm(50+n)/x;
        end 
        Nrm2=wkeep(Nrm,432000,'c');
        F2=filter(hpFilt,Nrm2);
        F2=filter(lpFilt,F2);
%         F2=wkeep(F2,412000,'r'); 

        b=strsplit(selected_file{q},{'.'});b=b{1,1};b(1)='F';      
        file_n(q)={b};
        All_fdat.(file_n{q})=F2;      
        All_inf(q,1:8)=infodat(1:8);
        pop_str(q)={[file_n{q} '_' infodat{8}]};        
        set(handles.uitable1,'data',All_inf)
        set(handles.pop1,'string',pop_str) 
        P=length(selected_file);
        P=q/P;
        waitbar(3/4,h,['Filtering and normalizing data...' num2str(ceil(P*100)) '%']);
end
close(h)
else    
    waitbar(2/4,h,'Creating filter design...');  
    for m=1:length(SR)  
        sr=SR(m);
        N = 1000;
        xb=sr/2;
        x=-xb:0.001:xb;
        b=str2double(handles.Cfreq);
        c=str2double(handles.Devf)/2;
        z=-(x-b).^2;
        y=2*(c^2);
        a=exp(z/y);
        X2=linspace(0,xb,length(x)/2);
        a2=wkeep(a,0.5*(length(a)-1),'r');
        X3=(X2*2)/sr;
        FreqVect=[X3];
        AmpVect=[a2];
    d = designfilt('arbmagfir',...
    'FilterOrder',N,'Amplitudes',AmpVect,'Frequencies',FreqVect,...
    'DesignMethod','freqsamp');
    ab(m)={['df' num2str(SR(m))]};
    DF.(ab{m})=d;
    try DF2.(ab{m})=hpFilt; end
    end
    for q=1:length(selected_file)
        load([selected_file{q}])
        %====%          
        b=str2double(handles.Cfreq);
        c=str2double(handles.Devf)/2;
        hp=b+(c*2);
        lp=b-(c*2);
        bandwidth={[num2str(lp) '-' num2str(hp) 'Hz']};        
        infodat(8)=bandwidth;
        handles.infodat=infodat;
        %====%
        m=mean(data);        
        Md=data-m; 
        sr=num2str(infodat{1,7});
        d=DF.(['df' sr]);
        % fvtool(d,'MagnitudeDisplay','Zero-phase')
        Filt1 = filter(d,Md);
        z50=zeros(1,50)';
        Nrm=[z50;Filt1];Nrm=[Nrm;z50];
        l=length(Filt1);B=abs(Nrm);
        for  n=1:(l-100);
             x=sum(B(n:100+n))/101;
             Nrm(50+n)=Nrm(50+n)/x;
        end 
        Nrm2=wkeep(Nrm,432000,'c');
        F2=filter(d,Nrm2);   
%         F2=wkeep(F2,412000,'r');  
        b=strsplit(selected_file{q},{'.'});b=b{1,1};b(1)='F';   
        file_n(q)={b};
        All_fdat.(file_n{q})=F2;      
        All_inf(q,1:8)=infodat(1:8);
        pop_str(q)={[file_n{q} '_' infodat{8}]};        
        set(handles.uitable1,'data',All_inf)
        set(handles.pop1,'string',pop_str) 
        P=length(selected_file);
        P=q/P;
        waitbar(3/4,h,['Filtering and normalizing data...' num2str(ceil(P*100)) '%']);
    end
close(h)
end
handles.file_n=file_n;
handles.All_fdat=All_fdat;  
handles.All_inf=All_inf; 
handles.pop_str=pop_str; 
set(handles.uitable1,'visible','on')
set(handles.pop1,'visible','on')
set(handles.plot_b,'visible','on')
set(handles.saveB,'visible','on')
set(handles.uitable1,'enable','on')
set(handles.pop1,'enable','on')
set(handles.plot_b,'enable','on')
set(handles.saveB,'enable','on')
set(handles.save_m,'enable','on')
guidata(hObject,handles)
    
function pushbutton3_Callback(hObject, eventdata, handles)

function gauss_dev_Callback(hObject, eventdata, handles)
Devf = get(hObject,'String');
handles.Devf=Devf;
guidata(hObject,handles)

function text_gauss_dev_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function center_freq_Callback(hObject, eventdata, handles)
Cfreq = get(hObject,'String');
handles.Cfreq=Cfreq;
guidata(hObject,handles)

function center_freq_CreateFcn(hObject, eventdata, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function uipanel5_CreateFcn(hObject, eventdata, handles)

function uipanel5_SelectionChangeFcn(hObject, eventdata, handles)
switch get(eventdata.NewValue,'Tag')
    case 'OpsiBF'
        set(handles.uipanel4,'visible','off')
        set(handles.uipanel3,'visible','on')
    case 'OpsiGauss'        
        set(handles.uipanel3,'visible','off')
        set(handles.uipanel4,'visible','on')
end

function gauss_dev_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function reset_b_Callback(hObject, eventdata, handles)
blankx={};
Hblank= [handles.ucornerx, handles.lcornerx, handles.center_freq, ...
        handles.gauss_dev];
set(handles.uitable1,'data',blankx)
set(handles.show_dir,'string',blankx)
set(Hblank,'string',[])
set(handles.pop1,'string','-','value',1)
handles.NL=blankx;
 try    handles=rmfield(handles,'lcorner');end
 try    handles=rmfield(handles,'ucorner');end
 try    handles=rmfield(handles,'Devf');end
 try    handles=rmfield(handles,'Cfreq');end
 try    handles=rmfield(handles,'All_fdat');end
 try    handles=rmfield(handles,'All_inf');end
 try    handles=rmfield(handles,'pop_str');end
 try    handles=rmfield(handles,'file_n');end 
handlesX=   [handles.uitable1, handles.plot_b, handles.saveB, ...
            handles.pushbutton2, handles.save_m, handles.pop1];
handlesV=   [handles.axes1_title, handles.axes2_title, ...
            handles.axes3_title];
set(handlesX,'enable','off')
set(handlesV,'visible','off')
set(findall(handles.axes1, '-property', 'visible'), 'visible', 'off')
set(findall(handles.axes2, '-property', 'visible'), 'visible', 'off')
set(findall(handles.axes3, '-property', 'visible'), 'visible', 'off')

guidata(hObject,handles)

function uipanel4_CreateFcn(hObject, ~, handles)

function mode1_Callback(hObject, eventdata, handles)

function mode2_Callback(hObject, eventdata, handles)

function uipanel4_ResizeFcn(hObject, eventdata, handles)

function uipanel7_SelectionChangeFcn(hObject, eventdata, handles)
switch get(eventdata.NewValue,'Tag')
    case 'mode1' 
        %....
    case 'mode2'
        %....
end

function saveB_Callback(hObject, eventdata, handles)
folder_name=uigetdir(pwd,'Select directory to save');
All_inf=handles.All_inf;
All_fdat=handles.All_fdat;
file_n=handles.file_n;
cd(folder_name);
h=waitbar(0,'Saving file...');
for n=1:size(All_inf,1)    
    bw=All_inf{n,8};bw=strsplit(bw,{'-'});    
    fn=[file_n{n} '_' bw{1} '_' bw{2}];
    fn=strrep(fn,'.','');
    data=All_fdat.(file_n{n});
    infodat=All_inf(n,:);
    save(fn,'data','infodat')
    P=size(All_inf,1);
    P=(n/P);
    waitbar(P,h,['Saving file...' num2str(ceil(P*100)) '%']);
end
close(h)

function gt_stack_Callback(hObject, eventdata, handles)

function gbt_merge_Callback(hObject, eventdata, handles)
XcorrProject_1;

function log_r_Callback(hObject, eventdata, handles)

function log_r_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function show_dir_Callback(hObject, eventdata, handles)

function show_dir_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pop1_Callback(hObject, eventdata, handles)

function pop1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plot_b_Callback(hObject, eventdata, handles)
n=get(handles.pop1,'value');
All_fdat=handles.All_fdat;
All_inf=handles.All_inf;
file_n=handles.file_n;
% file_n2=handles.file_n2;
aa=file_n{n};aa(1)='M';
load([aa])
fdat=All_fdat.([file_n{n}]);

Fs=All_inf{n,7};                        
m=mean(data);        
Md=data-m; 
L1 = length(Md);              
L2 = length(fdat);           

NFFT1 = 2^nextpow2(L1);           
NFFT2 = 2^nextpow2(L2);          
Y1 = fft(Md,NFFT1)/L1;
Y2 = fft(fdat,NFFT2)/L2;
f1 = Fs/2*linspace(0,1,NFFT1/2+1);
f2 = Fs/2*linspace(0,1,NFFT2/2+1);
YY1=2*abs(Y1(1:NFFT1/2+1));m=max(YY1);YY1=YY1/m;
YY2=2*abs(Y2(1:NFFT2/2+1));m=max(YY2);YY2=YY2/m;

plot(handles.axes2,f1,YY1);
set(handles.axes2,'FontSize',8)
set(get(handles.axes2,'xlabel'),'String','Frequency(Hz)','fontsize',8)
set(get(handles.axes2,'ylabel'),'String','Normalized Amplitude','fontsize',8)
set(handles.axes2,'ylim',[0 0.02])

plot(handles.axes3,f2,YY2);
set(handles.axes3,'FontSize',8)
set(get(handles.axes3,'xlabel'),'String','Frequency(Hz)','fontsize',8)
set(get(handles.axes3,'ylabel'),'String','Normalized Amplitude','fontsize',8)
%
try
handles.axes1=handles.AXEZ;
end
pos1 = getpixelposition(handles.axes1);
try
delete(handles.axes1)
end
handles.axes1=axes('unit','pixel','Position',pos1);
%
Mdat=max(abs(fdat));
fdat=fdat/Mdat;
Ns=length(fdat);
x1=0;
x2=Ns/Fs;
Xline=linspace(x1,x2,Ns);

ts1 = timeseries(fdat,Xline);
ts1.Name = '';
ts1.TimeInfo.Units = 'seconds';
ts1.TimeInfo.StartDate='00:00:00';
ts1.TimeInfo.Format = 'HH:MM:SS';
plot(ts1);
%
yr_day=strsplit(All_inf{n,4});yr_day=yr_day{1};
set(handles.axes1,'ylim',[-1.1 1.1],'fontsize',8)
set( get(handles.axes1,'ylabel'),'String','Normalized data','fontsize',8 )
set( get(handles.axes1,'xlabel'),'String','Time','fontsize',8 )
set( get(handles.axes1,'title'),'String',['Station: ' All_inf{1,1}...
    ' | Channel: ' All_inf{1,2} ' | Date: ' yr_day ' | Bw: '...
    All_inf{1,8}],'fontsize',8,'fontweight','bold')
%
handles.AXEZ=handles.axes1;
set(handles.axes1,'visible','on')
set(handles.axes2,'visible','on')
set(handles.axes3,'visible','on')
set(handles.axes1_title,'visible','on')
set(handles.axes2_title,'visible','on')
set(handles.axes3_title,'visible','on')
guidata(hObject,handles)

function uitable1_CellEditCallback(hObject, eventdata, handles)

function file_m_Callback(hObject, eventdata, handles)

function tools_m_Callback(hObject, eventdata, handles)

function cnv_m_Callback(hObject, eventdata, handles)
MergeG

function filter_m_Callback(hObject, eventdata, handles)
filterG

function x_corr_Callback(hObject, eventdata, handles)
XcorrG

function stack_m_Callback(hObject, eventdata, handles)
StackG_V2

function dispersion_m_Callback(hObject, eventdata, handles)
DispersionG    

function mapping_m_Callback(hObject, eventdata, handles)
MappingG

function open_m_Callback(hObject, eventdata, handles)
addpath(pwd)
folder_name = uigetdir('C:\');
addpath(folder_name)
% set(handles.browse_text,'string',folder_name)
all_files=dir(folder_name);
all_files=struct2cell(all_files)';
all_files=all_files(:,1);
set(handles.show_dir,'string',all_files)
handles.NL=all_files;
sz=size(all_files,1)
cl=clock;
if sz>=1
rep1=([date ' ' num2str(cl(1,4)) ':' num2str(cl(1,5)) ':'...
        num2str(floor(cl(1,5))) ' Open dir: ' num2str(sz) ' files are found']);
else
    rep1=([date ' ' num2str(cl(1,4)) ':' num2str(cl(1,5)) ':'...
        num2str(floor(cl(1,5))) ' Open dir: ' num2str(sz) ' file is found']);
end
handles.log{1}=rep1;
set(handles.log_r,'string',rep1)
set(handles.pushbutton2,'enable','on')
guidata(hObject,handles)

function save_m_Callback(hObject, eventdata, handles)
folder_name=uigetdir(pwd,'Select directory to save');
All_inf=handles.All_inf;
All_fdat=handles.All_fdat;
file_n=handles.file_n;
cd(folder_name);

h=waitbar(0,'Saving file...');
for n=1:size(All_inf,1)    
    bw=All_inf{n,8};bw=strsplit(bw,{'-'});    
    fn=[file_n{n} '_' bw{1} '_' bw{2}];
    fn=strrep(fn,'.','');
    data=All_fdat.(file_n{n});
    infodat=All_inf(n,:);
    save(fn,'data','infodat')
    P=size(All_inf,1);
    P=(n/P);
    waitbar(P,h,['Saving file...' num2str(ceil(P*100)) '%']);
end
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

function show_dir_ButtonDownFcn(hObject, eventdata, handles)
% addpath(pwd)
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
%              set(handles.pushbutton2,'enable','on')
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
            set(handles.pushbutton2,'enable','on')
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
%             list2=struct2cell(list2)';
%             list2=list2(:,1)
            newlist=[list1;list2];
            set(handles.show_dir,'string',newlist)
            handles.NL=newlist;
            set(handles.pushbutton2,'enable','on')
            guidata(hObject,handles)
            catch
                %skip
            end

function OpsiGauss_ButtonDownFcn(hObject, eventdata, handles)

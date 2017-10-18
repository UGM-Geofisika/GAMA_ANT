function varargout = XcorrG(varargin)
% XCORRG MATLAB code for XcorrG.fig
%      XCORRG, by itself, creates a new XCORRG or raises the existing
%      singleton*.
%
%      H = XCORRG returns the handle to a new XCORRG or the handle to
%      the existing singleton*.
%
%      XCORRG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XCORRG.M with the given input arguments.
%
%      XCORRG('Property','Value',...) creates a new XCORRG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before XcorrG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to XcorrG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help XcorrG

% Last Modified by GUIDE v2.5 06-Mar-2016 09:59:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @XcorrG_OpeningFcn, ...
                   'gui_OutputFcn',  @XcorrG_OutputFcn, ...
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


% --- Executes just before XcorrG is made visible.
function XcorrG_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
addpath(pwd)
guidata(hObject, handles);

function varargout = XcorrG_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function browse_t_Callback(hObject, eventdata, handles)

function browse_t_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function browse_b_Callback(hObject, eventdata, handles)
folder_name = uigetdir('C:\');
cd(folder_name)
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

function show_dir_Callback(hObject, eventdata, handles)

function show_dir_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function r_log2_Callback(hObject, eventdata, handles)

function r_log2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tdlim_Callback(hObject, eventdata, handles)
t_lim = get(hObject,'String');
handles.t_lim=t_lim;
guidata(hObject,handles)

function tdlim_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function x_cor_Callback(hObject, eventdata, handles)

function x_corr_b_Callback(hObject, eventdata, handles)
% Verifying time limit input ============================================ %
if strcmp(get(handles.tdlim,'string'),'') || ...
        isempty(get(handles.tdlim,'string')) 
    warndlg('Time limit input is empty')
elseif isnan(str2double(get(handles.tdlim,'string')))
    warndlg('Time limit input is invalid')
else
try 
sta_list=handles.NL;
sta_list=sortrows(sta_list);
selected_file={};
m=1;
h=waitbar(0,'Lodading data...');
for i=1:length(sta_list)
                v=regexp(sta_list(i),['F_\w*.mat'],'match');
            if  (~isempty(v{1}))
                selected_file{end+1}=sta_list{i};
            end
end
for n1=1:length(selected_file)      
    load([selected_file{n1}])
    date1=strsplit(infodat{1,4},{'-' ' '});jd=date1{1,2};yyyy=date1{1,1};
    bw=strsplit(infodat{1,8},{'-' '.'});
    x=infodat{1,2};x=x(3);
    fn(n1)={[infodat{1,1} '_' x '_' yyyy '_' jd '_' bw{1} bw{2} '_' bw{3} bw{4}]};
    All_data.(fn{n1})=data;
    All_inf(m,1:8)=infodat(1:8);
    newch=All_inf{m,2};
    newch=newch(end);
    All_inf{m,2}=newch;
    m=m+1;
    waitbar(0,h,['Loading data... (' ...
        num2str(ceil((n1/length(selected_file))*100)) '%)'])
end
  p1=1;p2=1;p3=1;p4=1;
  All_infb=sortrows(All_inf,2);
  All_infc=sortrows(All_inf,4);
  All_infd=sortrows(All_inf,8);
for m=2:(length(selected_file))
    a1=All_inf{m-1,1};a2=All_inf{m,1};
    b1=All_infb{m-1,2};b2=All_infb{m,2};b1=b1(end);b2=b2(end);    
    c1=strsplit(All_infc{m-1,4},' ');c2=strsplit(All_infc{m,4},' ');
    c1=c1{1};c2=c2{1};
    d1=All_infd{m-1,8};d2=All_infd{m,8};
    stalist{p1}=a1;
    chalist{p2}=b1(end);
    cc=strrep(c1,'-','_');
    jdlist{p3}=cc;
    dd=strrep(d1,'.','');
    dd=strrep(dd,'-','_');
    bwlist{p4}=dd;
    cs1=strmatch(a1,a2);
    cs2=strmatch(b1,b2);
    cs3=strmatch(c1,c2);
    cs4=strmatch(d1,d2);
    %-------------------%
    if ~isempty(cs1)
        stalist{p1}=a1;
    else
        p1=p1+1;
        stalist{p1}=a2;
    end
    %-------------------%
    if ~isempty(cs2)
        chalist{p2}=b1;
    else
        p2=p2+1;
        chalist{p2}=b2;
    end
    %-------------------%
    if ~isempty(cs3)
        cc=strrep(c1,'-','_');
        jdlist{p3}=cc;
    else
        p3=p3+1;
        cc=strrep(c2,'-','_');
        jdlist{p3}=cc;
    end
    %-------------------%    
    if ~isempty(cs4)
        bw_dot{p4}=d1;
        d1=strrep(d1,'.','');
        d1=strrep(d1,'-','_');
        bwlist{p4}=d1;
    else
        p4=p4+1;
        bw_dot{p4}=d2;
        d2=strrep(d2,'.','');
        d2=strrep(d2,'-','_');
        bwlist{p4}=d2;
    end
end
%-------------------------------------------------------------------------%
waitbar(0,h,'Generating cross-correlation...')
L1=length(bwlist);
L2=length(jdlist);
L3=length(chalist);
L4=length(stalist)-1;
Lp=0;
q=1;
% LL=length(stalist);
for nn=1:(L4)
    Lp=Lp+(nn);
end
for lp1=1:L1
    for lp2=1:L2
        for lp3=1:L3
            p1=1;
            p2=0;
            LL=length(stalist);
            for lp4=1:Lp
                p2=p2+1; 
                %--------------------%
                if p2==(LL) & length(stalist)~=2
                    p1=p1+1;
                    p2=1;
                    LL=LL-1;
                else
                end
                %--------------------%
                try
                sig1=All_data.([stalist{p1} '_' chalist{lp3} '_' jdlist{lp2} '_' bwlist{lp1}]);
                sig2=All_data.([stalist{p1+p2} '_' chalist{lp3} '_' jdlist{lp2} '_' bwlist{lp1}]);                
                load(['F_' stalist{p1} '_' chalist{lp3} '_' jdlist{lp2} '_' bwlist{lp1}]);a1=infodat{1,3};b1=infodat{1,7};
                load(['F_' stalist{p1+p2} '_' chalist{lp3} '_' jdlist{lp2} '_' bwlist{lp1}]);a2=infodat{1,3};b2=infodat{1,7};
                if a1==a2 & b1==b2 
                limtime=(str2double(handles.t_lim)*b1*2)+1;%%%%%
                cutX=3*3600*b1;
                sig1=wkeep(sig1,(length(sig1)-cutX),'r');
                sig2=wkeep(sig2,(length(sig2)-cutX),'r');
                corr=xcorr(sig1,sig2);
                corr=wkeep(corr,limtime,'c');                
                M=max(corr);
                sta_pairs(q)={[stalist{p1} '-' stalist{p1+p2}]};
                julday(q)={regexprep(jdlist{lp2},'_','-')};                
                bandwidth{q}=bw_dot{lp1};
                NS(q)={[num2str(limtime)]};
                ch(q)={[chalist{lp3}]};
                SR{q}=b1;             
                corr_pair(q,1)={[stalist{p1} '_' stalist{p1+p2} '_' chalist{lp3} '_' jdlist{lp2}...
                                '_' bwlist{lp1}]};
%                 corr_pair(q,2)={[stalist{p1} '_' stalist{p1+p2} '_' chalist{lp3} '_' jdlist{lp2}...
%                                 '_' bw_dot{lp1}]};            
                All_pairs.(corr_pair{q,1})=corr/(M);
                q=q+1;
                
                Q=calP(L1,L2,L3,Lp,lp1,lp2,lp3,lp4);
                waitbar((Q/100),h,['Calculating cross-correlation...(' ...
                    num2str(ceil(Q)) '%)']);                
                else 
                    %log report error
                end
                catch
                Q=calP(L1,L2,L3,Lp,lp1,lp2,lp3,lp4);
                waitbar((Q/100),h,['Calculating cross-correlation...(' ...
                    num2str(ceil(Q)) '%)']);
                    %log report error
                end
            end
        end
    end    

end
sta_pairs=sta_pairs';
julday=julday';
bandwidth=bandwidth';
NS=NS';
SR=SR';
ch=ch';
table1=[sta_pairs ch julday bandwidth NS SR];
table2=sortrows(table1,[1 2 4 3]);%<<sorting
% All_pairs=orderfields(All_pairs);%<<sorting
handles.All_pairs=All_pairs;
handles.Pair_inf=table2;
corr_pairX=[table1 corr_pair];
corr_pairX=sortrows(corr_pairX,[1 2 4 3]);%<<sorting
handles.corr_pairX=corr_pairX;
handlesE=[handles.plot_b, handles.save_b, handles.save_m, handles.auto_p,...
         handles.grid_m, handles.time_lag];
set(handles.uitable1,'visible','off')
set(handles.uitable4,'visible','on')
set(findall(handles.axes1, '-property', 'visible'), 'visible', 'on')
set(handles.pop1,'enable','on')
set(handlesE,'enable','on')
set(handlesE,'visible','on')
set(handles.pop1,'string',corr_pairX(:,7))
set(handles.uitable4,'data',table2)
close(h)
guidata(hObject,handles)
catch
   errordlg({'It needs at least a pair seismic data' ...
       'from different station at the same time record.'},'Invalid input');
   close(h)
end
end
%-------------------------------------------------------------------------%
function [Q]=calP(L1,L2,L3,Lp,lp1,lp2,lp3,lp4)
    P1=((lp1-1)/L1)*100;
    P2=(((lp2-1)/L2)/L1)*100;
    P3=((((lp3-1)/L3)/(L1*L2))*100);
    P4=(((lp4/Lp)/(L1*L2*L3))*100);
    Q=P1+P2+P3+P4;

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
            %verifiying existing file in the list-------------------------%
            if ~isempty(list1)
                newlist=list1;
                for n2=1:length(list2)
                    verval=1;
                    verX=strfind(list1,list2{n2});
                    for n1=1:length(list1)                        
                        if ~isempty(verX{n1})  
                            verval=0;
                        else
                            %skip
                        end
                    end
                    if verval==1
                        newlist=[newlist;list2(n2)];
                    else
                        %skip
                    end
                end                
            else
                newlist=[list1;list2];
            end
            %-------------------------------------------------------------%

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
            [a b c]=uigetfile('*','Select file... (you can select multiple files)','multiselect','on');
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
            %verifiying existing file in the list-------------------------%
            if ~isempty(list1)
                newlist=list1;
                for n2=1:length(list2)
                    verval=1;
                    verX=strfind(list1,list2{n2});
                    for n1=1:length(list1)                        
                        if ~isempty(verX{n1})  
                            verval=0;
                        else
                            %skip
                        end
                    end
                    if verval==1
                        newlist=[newlist;list2(n2)];
                    else
                        %skip
                    end
                end                
            else
                newlist=[list1;list2];
            end
            %-------------------------------------------------------------%
            set(handles.show_dir,'string',newlist)
            handles.NL=newlist;
            set(handles.add_b,'enable','on')
            guidata(hObject,handles)
            catch
                %skip
            end            

function add_b_Callback(hObject, eventdata, handles)
sta_list=handles.NL;
sta_list=sortrows(sta_list);
selected_file={};
m=1;
for i=1:length(sta_list)
                v=regexp(sta_list(i),['F_\w*.mat'],'match');
            if  (~isempty(v{1}))
                selected_file{end+1}=sta_list{i};
            end
end
handlesE=   [handles.x_corr_b, handles.uitable1, handles.uitable4,...
             handles.text4, handles.text5, handles.tdlim];
set(handles.uitable4,'visible','off')
set(handles.uitable1,'visible','on')
set(handles.pop1,'visible','on')
set(handles.plot_b,'visible','on')
set(handlesE,'enable','on')
h=waitbar(0,'Loading file... ');
for n1=1:length(selected_file)   
   
    load([selected_file{n1}])
%     date1=strsplit(infodat{1,4},{'-' ' '});jd=date1{1,2};yyyy=date1{1,1};
%     bw=strsplit(infodat{1,8},{'-' '.'});
%     x=infodat{1,2};x=x(3);
%     fn(n1)={[infodat{1,1} '_' x '_' yyyy '_' jd '_' bw{1} bw{2} '_' bw{3} bw{4}]};
%     All_data.(fn{n1})=data;
    All_inf(m,1:8)=infodat(1:8);
    m=m+1;    
    set(handles.uitable1,'data',All_inf)    
    Q=n1/length(selected_file);
waitbar(Q,h,['Loading file... (' num2str(ceil(Q*100)) '%)']);   
end
close(h)

function pop1_Callback(hObject, eventdata, handles)

function pop1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plot_b_Callback(hObject, eventdata, handles)
n=get(handles.pop1,'value');
All_pairs=handles.All_pairs;
Pair_inf=handles.Pair_inf;
corr_pairX=handles.corr_pairX;
data=All_pairs.(corr_pairX{n,7});
ndat=length(data);
t_lim=str2num(handles.t_lim);
X=linspace(-t_lim,t_lim,ndat);
titleX=(['Station pair: ' Pair_inf{n,1} '; Channel: ' Pair_inf{n,2}...
        '; Julian day: ' Pair_inf{n,3} '; Freq bandwidth: ' Pair_inf{n,4}]);
%=========================================================================%
set(handles.axes1,'nextplot','replacechildren')
if  (get(handles.grid_m,'Value') == get(handles.grid_m,'Max'))
    plot(X, data, 'Parent', handles.axes1, 'Tag', 'ThePlotTag', 'HitTest', 'off');grid minor;
else
    plot(X, data, 'Parent', handles.axes1, 'Tag', 'ThePlotTag', 'HitTest', 'off');grid off;    
end
% plot(handles.axes1,X,data);
set(handles.axes1,'FontSize',8)
set(handles.axes1,'ylim',[-1.4 1.4]);
set( get(handles.axes1,'title'),'String',titleX,'fontsize',9,'fontweight','bold')
set( get(handles.axes1,'xlabel'),'String','Time (seconds)','fontsize',8 )
set( get(handles.axes1,'ylabel'),'String','Normalized Amplitude','fontsize',8 )
%-------------------------------------------------------------------------%
if  (get(handles.auto_p,'Value') == get(handles.auto_p,'Max'))
    [Yp,Xp] = findpeaks(data,'SortStr','descend');
    [Yn,Xn] = findpeaks((data*-1),'SortStr','descend');
    GbY=[Yp;Yn]; [Ys, I]=sort(GbY,'descend');
    GbX=[Xp;Xn]; [Xs]=sort(GbX,'descend'); 
    Xloc=GbX(I(1));
    sr=Pair_inf{n,6};
    ns=str2num(Pair_inf{n,5});
    Tloc=(Xloc/sr)-((ns/sr)/2);
%     save('test','Xloc','sr','ns','Tloc')
    % Ym=Ys(1);
    markerline=[-1,1];
    set(handles.axes1,'nextplot','add')
    plot([Tloc Tloc],[-1.3,1.3],'color','r','linestyle',':','linewidth',...
        1.4,'Parent', handles.axes1, 'Tag', 'ThePlotTag', 'HitTest', 'off');
    set(handles.time_lag,'string',['Time lag: ' num2str(Tloc) ' second(s)'])
else
    %skip
end

%=========================================================================%
handles.new=handles.axes1;
guidata(hObject,handles)

function reset_b_Callback(hObject, eventdata, handles)
blankx={};
% Hblank= [handles.ucornerx, handles.lcornerx, handles.center_freq, ...
%         handles.gauss_dev];
set(handles.uitable1,'data',blankx)
set(handles.uitable4,'data',blankx)
set(handles.show_dir,'string',blankx)
set(handles.tdlim,'string',[])
set(handles.pop1,'string','-','value',1)
handles.NL=blankx;
% 
 try    handles=rmfield(handles,'td_lim');end
 try    handles=rmfield(handles,'All_pairs');end
 try    handles=rmfield(handles,'All_inf');end
 try    handles=rmfield(handles,'corr_pair');end
 try    handles=rmfield(handles,'pop_str');end
%   
handlesX=   [handles.uitable1,handles.uitable4, handles.plot_b,...
            handles.save_b, handles.add_b, handles.save_m, handles.pop1,...
            handles.tdlim, handles.x_corr_b, handles.text4,...
            handles.text5, handles.grid_m, handles.auto_p, handles.time_lag];
handlesX2=  [handles.grid_m, handles.auto_p];
set(handlesX,'enable','off')
set(handlesX2,'value',0)
set(handles.time_lag,'string','Time lag:')
set(findall(handles.axes1, '-property', 'visible'), 'visible', 'off')
guidata(hObject,handles)

% ------------------------------------------------------------------------%
function file_m_Callback(hObject, eventdata, handles)

function tool_m_Callback(hObject, eventdata, handles)

function cnm_Callback(hObject, eventdata, handles)
MergeG  

function filter_m_Callback(hObject, eventdata, handles)
FilterG

function x_corr_m_Callback(hObject, eventdata, handles)
    
function stack_m_Callback(hObject, eventdata, handles)
StackG_V2

function dispersion_m_Callback(hObject, eventdata, handles)
DispersionG

function mapping_m_Callback(hObject, eventdata, handles)
MappingG

function open_m_Callback(hObject, eventdata, handles)
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

% --------------------------------------------------------------------
function save_m_Callback(hObject, eventdata, handles)
folder_name=uigetdir(pwd,'Select directory to save');
Pair_inf=handles.Pair_inf;
All_pairs=handles.All_pairs;
corr_pairX=handles.corr_pairX;
cd(folder_name);

h=waitbar(0,'Saving file...');
for n=1:size(Pair_inf,1)    
    sr=Pair_inf{n,6};    
    fn=['X_' corr_pairX{n,7} '_' num2str(sr)];
%     fn=strrep(fn,'.','');
    data=All_pairs.(corr_pairX{n,7});
    infodat=Pair_inf(n,:);
    save(fn,'data','infodat')
    P=size(Pair_inf,1);
    P=(n/P);
    waitbar(P,h,['Saving file...' num2str(ceil(P*100)) '%']);
end
close(h)

% --------------------------------------------------------------------
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

function save_b_Callback(hObject, eventdata, handles)
folder_name=uigetdir(pwd,'Select directory to save');
Pair_inf=handles.Pair_inf;
All_pairs=handles.All_pairs;
corr_pairX=handles.corr_pairX;
cd(folder_name);

h=waitbar(0,'Saving file...');
for n=1:size(Pair_inf,1)    
    sr=Pair_inf{n,6};
    fn=['X_' corr_pairX{n,7} '_' num2str(sr)];
%     fn=strrep(fn,'.','');
    data=All_pairs.(corr_pairX{n,7});
    infodat=Pair_inf(n,:);
    save(fn,'data','infodat')
    P=size(Pair_inf,1);
    P=(n/P);
    waitbar(P,h,['Saving file...' num2str(ceil(P*100)) '%']);
end
close(h)

% --------------------------------------------------------------------

function axes1_ButtonDownFcn(hObject, eventdata, handles)
seltype = get(gcf,'selectiontype');
% newFig = figure(2);
% %Create a copy of the axes
% newA = copyobj(handles.new,newFig)
% set(gcf,'position', [100 400 780 250]) 
% set(gca,'position', [10 3 140 12]) 
% % saveas(gcf,'test.fig')
% close(gcf); %and close it
% % print(newFig,'-dpng','image.png');
% 
% % seltype = get(gcf,'selectiontype');
% del_row=get(handles.show_dir,'Value');
% 
hcmenu = uicontextmenu;
item1 = uimenu(hcmenu,'Label','Save figure as...','Callback', ...
    {@opsi4,hObject,eventdata,handles});
if strmatch(seltype,'alt')
    set(handles.axes1,'uicontextmenu',hcmenu)
end
%=========================================================================%
function opsi4(varargin)            
handles=varargin{5};
hObject=varargin{3};

[filename, pathname]=uiputfile({'*.fig'; '*.jpeg'},'Save as...');  
newFig = figure(2);
%Create a copy of the axes
newA = copyobj(handles.new,newFig);
set(gcf,'position', [100 400 780 240]) 
set(gca,'position', [10 3 140 12]) 
cd(pathname)
saveas(gcf,filename)
close(gcf); 
guidata(hObject,handles)

function grid_m_Callback(hObject, eventdata, handles)
a=get(hObject,'Value');
if a==1
    set(handles.grid_m,'string','Grid on')
else
    set(handles.grid_m,'string','Grid off')
end

function auto_p_Callback(hObject, eventdata, handles)
        

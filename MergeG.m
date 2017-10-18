function varargout = MergeG(varargin)
% MERGEG MATLAB code for MergeG.fig
%      MERGEG, by itself, creates a new MERGEG or raises the existing
%      singleton*.
%
%      H = MERGEG returns the handle to a new MERGEG or the handle to
%      the existing singleton*.
%
%      MERGEG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MERGEG.M with the given input arguments.
%
%      MERGEG('Property','Value',...) creates a new MERGEG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MergeG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MergeG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MergeG

% Last Modified by GUIDE v2.5 05-Mar-2016 01:30:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MergeG_OpeningFcn, ...
                   'gui_OutputFcn',  @MergeG_OutputFcn, ...
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


% --- Executes just before MergeG is made visible.
function MergeG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MergeG (see VARARGIN)

% Choose default command line output for MergeG
handles.output = hObject;
addpath(pwd)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MergeG wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MergeG_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function browse_text_Callback(hObject, eventdata, handles)

function browse_text_CreateFcn(hObject, eventdata, handles)
% Load file(s) from directory =========================================== %
function browse_button_Callback(hObject, eventdata, handles)
addpath(pwd)
folder_name = uigetdir('C:\');
addpath(folder_name)
set(handles.browse_text,'string',folder_name)
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
set(handles.r_log2,'string',rep1)
guidata(hObject,handles)

function show_dir_Callback(hObject, eventdata, handles)

function show_dir_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% Delete file input ===================================================== %
function delete_btn_Callback(hObject, eventdata, handles)
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
 guidata(hObject,handles)

function figure1_ButtonDownFcn(hObject, eventdata, handles)

function pushbutton3_Callback(hObject, eventdata, handles)
sta_list=handles.NL;
nX=0;
try
vlog=length(handles.log)+1;
catch
vlog=1;
end
fsamp={};
WB=waitbar(0,'Please wait...');
% close(h)
for n=1:length(sta_list)    
try
    sta_list=sortrows(sta_list);
    c=sta_list{n};
    X=rdmseed(c);
    X2=struct2cell(X);
    nX=nX+1;
    ss=X2{4,1,1};
    ss=strsplit(ss,' ');
    sta(nX)=ss(1);
    ch(nX)=X2(6,1,1);
    fsamp{nX}=sum(cat(1,X.NumberSamples));
    fsampN=cell2mat(fsamp);    
    sr(nX)=X2(11,1,1);
    start_t(nX)=X2(25,1,1);
    X3=sr{nX};
    d(nX)=floor(fsampN(nX)/(86400*X3));dr(nX)=rem(fsampN(nX),86400*X3);if d(nX)==0 d2='';else d2=([num2str(d(nX)) 'd']); end
    h(nX)=floor(dr(nX)/(3600*X3));hr(nX)=rem(dr(nX),3600*X3);if h(nX)==0 h2='';else h2=([num2str(h(nX)) 'h']); end
    m(nX)=floor(hr(nX)/(60*X3));mr(nX)=rem(hr(nX),60*X3);if m(nX)==0 m2='';else m2=([num2str(m(nX)) 'm']); end
    s(nX)=mr(nX)/X3;if s(nX)==0 s2='';else s2=([num2str(s(nX)) 's']);end
    dur{nX}=([d2 h2 m2 s2]);
    C = strsplit(start_t{nX},{' ','-',':'});
    s3=s(nX)+str2num(C{1,5});rs3=rem(s3,60);s4=floor(s3/60);if rs3<10 rs3=(['0' num2str(rs3)]); else rs3=sprintf('%0.4f',rs3);end
    m3=m(nX)+str2num(C{1,4})+s4;rm3=rem(m3,60);m4=floor(m3/60);if rm3<10 rm3=(['0' num2str(rm3)]); else rm3=num2str(rm3);end
    h3=h(nX)+str2num(C{1,3})+m4;rh3=rem(h3,24);h4=floor(h3/24);if rh3<10 rh3=(['0' num2str(rh3)]); else rh3=num2str(rh3);end
    jd=d(nX)+str2num(C{1,2})+h4;%rd3=rem(d3,)
    yr=C{1,1};
    end_t{nX}=([yr '-' num2str(jd) ' ' rh3 ':' rm3 ':' rs3]);
    sp=start_t{nX};    
    sp=strsplit(sp,' ');
    sp1=strsplit(sp{1},'-');
    spY=sp1{1};spD=sp1{2};
    sp2=strsplit(sp{2},':');
    spH=sp2{1};spM=sp2{2};spS=sp2{3};spS=spS(1:2);
    parts(n)={['M_' sta{nX} '_' ch{nX} '_' spY '_' spD '_' spH spM spS]};handles.parts=parts;
    ad=X.t;ad=ad(1,1);
    ad2=X.SampleRate;ad2=ad2(1,1);
    All_parts.(parts{n})=cat(1,X.d);handles.All_parts=All_parts;
    All_time.(parts{n})=ad;handles.All_time=All_time;
    All_sr.(parts{n})=ad2;handles.All_sr=All_sr;      
catch
    switch c
        case '.'
            %skip
        case '..'
            %skip
        otherwise
        cl=clock;
        err1=([date ' ' num2str(cl(1,4)) ':' num2str(cl(1,5)) ':'...
                num2str(floor(cl(1,5))) ' Load file: ''' c ''' is not a miniSEED file']);
        try    
        logrep=[{err1} logrep];
        catch
        logrep={err1};
        end
        handles.log=logrep;
        set(handles.r_log2,'string',handles.log,'value',vlog)
    %     vlog=vlog+1;
        disp(c)
    end
end
    Percent=round((n/length(sta_list))*100);
    dp=num2str(Percent);   
    waitbar(n/length(sta_list),WB,['Converting data... (' dp '%)']);
end
close(WB)
sta=sta';
ch=ch';
fsamp=fsamp';
sr=sr';
start_t=start_t';
end_t=end_t';
dur=dur';
table1=[sta,ch,fsamp,start_t,end_t,dur,sr];
%Sort_table---------------------------------------------------------------%
table1=sortrows(table1,[1 2 4]);
handles.table1=table1;
set(handles.uitable1,'visible','on')
set(handles.pop1,'visible','on')
set(handles.uipanel3,'visible','on')
set(handles.save_b,'visible','on')
set(handles.text5,'enable','on')
set(handles.decif,'enable','on')
set(handles.mergeB,'enable','on')
set(handles.uitable1,'enable','on')
guidata(hObject,handles)
set(handles.uitable1,'data',table1);

function r_log2_Callback(hObject, eventdata, handles)

function r_log2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Indat_pnl_ResizeFcn(hObject, eventdata, handles)

function decif_Callback(hObject, eventdata, handles)
handles.dff = get(hObject,'String');
if iscell(handles.dff)
    handles.dff=handles.dff{1};
else
%skip
end
% set(handles.mergeB,'enable','on')
 guidata(hObject,handles)
% 
% set(handles.mergeB,'enable','on')

function mergeB_Callback(hObject, eventdata, handles)
choice=1; %default chioce
if ~isfield(handles,'dff')
choice=questdlg('Do you want to proceed without decimation?', ...
	'Warning', ...
	'Yes','No','No');
% Handle response
switch choice
    case 'Yes'         
        choice=1;
    case 'No'         
        choice=2;
end
else
    %skip
end
if choice==1;
        try
            decif=str2num(handles.dff);
        catch
            decif=1;
        end        
parts=handles.parts;
All_parts=handles.All_parts;
All_time=handles.All_time;
All_sr=handles.All_sr;
table1=handles.table1;
p=1;
chain={};file_n2={};sta2={};cha2={};t2={};Sr={};Ns={};dur2={};
end_t={};day2={};
table2=table1;
WB=waitbar(0,'Sorting data...');
if size(table1,1)==1
    date1=strsplit(table1{1,4},{' '});date1=strrep(date1{1,1},'-','_');  
    chain{p}=[table1{1,1} '_' table1{1,2} '_' date1];
else    
    for n=2:size(table1,1)
        date1=strsplit(table1{n,4},{' '});date1=strrep(date1{1,1},'-','_');
        date2=strsplit(table1{n-1,4},{' '});date2=strrep(date2{1,1},'-','_');
        stat1=table1{n,1};stat2=table1{n-1,1};
        ch1=table1{n,2};ch2=table1{n-1,2};
        chain{p}=[table1{n-1,1} '_' table1{n-1,2} '_' date2];
        aa=strmatch(stat1,stat2,'exact');
        bb=strmatch(ch1,ch2,'exact');
        cc=strmatch(date1,date2,'exact');
    if ~isempty(aa) & ~isempty(bb) & ~isempty(cc)    
        chain{p}=[table1{n-1,1} '_' table1{n-1,2} '_' date2];        
    elseif ~isempty(aa) & ~isempty(bb) & isempty(cc)
        p=p+1;
        chain{p}=[table1{n-1,1} '_' table1{n-1,2} '_' date1]; 
    elseif ~isempty(aa) & isempty(bb) & isempty(cc) 
        p=p+1;
        chain{p}=[table1{n-1,1} '_' table1{n,2} '_' date1]; 
    else
        p=p+1;
        chain{p}=[table1{n,1} '_' table1{n,2} '_' date1]; 
    end
    end
end
wb=0;
P=1;
full_tab=cell(1,7);
P=1;
for n=1:length(chain)
    selected_file={};    
%     waitbar(wb/length(chain),WB,...
%     ['Merging data... (' num2str(ceil((wb/length(chain))*100)) '%)']);       
for i=1:length(parts)
                v=regexp(parts(i),['M_' chain{n} '\w*'],'match');
            if  (~isempty(v{1}))
                selected_file{end+1}=parts(i);
            end
end
clear part1
clear part2
clear part2T
clear part2SR
for i=1:length(selected_file)    
    a=selected_file{i};
    a2=selected_file{1};
    b=All_parts.([a{1}]);
    c=All_time.([a{1}]);
    c2=All_time.([a2{1}]);
    d=All_sr.([a{1}]);
    
    part1(i)={['P_' num2str(i)]};
    part2.(part1{i})=cat(1,b); 
    part2T.(part1{i})=cat(1,c);
    tt(n)=c2;
    part2SR.(part1{i})=cat(1,d);
end
pp=1;
sta={};ch={};St={};Et={};sr={};Ns={};dur={};sr={};
pp=1;
nn=1;
%=========================================================================%
if length(part1)==1%<<--if only 1 file is found
   sr=table2{1,7}/decif;
   Ns=table2{1,3}/decif;
   tableX(1,1:2)=table2(1,2);
   tableX{1,3}=Ns;
   tableX(1,4:6)=table2(1,4:6);
   tableX{1,7}=sr;
   data=part2.(part1{1});
   data_n(pp)={[chain{n} '_' num2str(pp) 'b']};   
   All_data.(data_n{pp})=data;
   table_pop.(chain{n})=tableX;
   %Adding zero data (left)-----------------------------------------------%
   t=part2T.(part1{1});
   [y, mo, d, h, mn, s]=datevec(t);
   s1=h*60*60;
   s2=mn*60;
   Nz0=(s1+s2+s)*table2{1,7};
   Nz0=zeros(Nz0,1);        
   data_z(1)={[chain{n} '_' num2str(1) 'a']};        
   All_zero.(data_z{1})=Nz0;
   %Adding zero data (right)----------------------------------------------%
   et2=table2{1,5};
   dayx=strsplit(chain{n},'_');dayx=str2num(dayx{4})+1;
   Eday={[num2str(dayx) ' 00:00:00']};
   val_tE=regexp(et2,Eday{1});
        if isempty(val_tE)
            ET2=strsplit(et2,{'-' ' ' ':'});
            he=ET2{3};me=ET2{4};se=ET2{5};
            s3=str2num(he)*3600;
            s2=str2num(me)*60;
            se=str2num(se);
            Nz=((3600*24)-(s3+s2+se))*table2{1,7};
            Nz=zeros(Nz,1);
            data_z(pp+1)={[chain{n} '_' num2str(pp) 'c']};        
            All_zero.(data_z{pp+1})=Nz;     
        end
    %Creating daily data--------------------------------------------------%
    try
        new_table=cat(1,new_table,tableX);
    catch
        new_table=tableX;
    end
    
    try
    data_list=[data_n data_z];
    catch
    data_list=data_n;
    end
    data_list=sortrows(data_list');
    selected_field={};
    %---------------------------------------------------------------------%
    for r=1:length(data_list)
        aa=isfield(All_data,[data_list{r}]);
        if aa==1
        data_m=All_data.(data_list{r});     
        try 
            data_M=cat(1,data_M,data_m);
        catch
            data_M = data_m;
        end
        end
    end
    meanD=mean(data_M);
    %---------------------------------------------------------------------%
    clear data_M
    waitbar(wb/length(chain),WB, ...
        ['Decimating and saving daily data... (' ...
        num2str(ceil((wb/length(chain))*100)) '%)'])    
    for z=1:length(data_list)
        try
            new_data=All_data.(data_list{z});        
            new_data=new_data-meanD;
            All_data=rmfield(All_data,[data_list{z}]);
        catch
            new_data=All_zero.(data_list{z});
            All_zero=rmfield(All_zero,[data_list{z}]);
        end
        
        try
            DATA=cat(1,DATA,new_data);
        catch
            DATA=new_data;
        end
    end    
    sr_inf=tableX{1,7};
    %
    bb=strmatch('1d',tableX{1,6},'exact');
    if ~isempty(bb)
        data_name(n)={['M_' chain{n} '_' num2str(sr_inf)]};
        full_tab(P,:)=tableX(1,:);
        P=P+1;
    else
        data_name(n)={['Mx_' chain{n} '_' num2str(sr_inf)]};
    end
    %
    DATA=decimate(DATA,decif);
    Data_storage.(data_name{n})=DATA;
    table2=table2((length(part1)+1:end),:);   
    clear tableX
    clear DATA; clear data; clear data_n; clear data_z; clear data_list
%=========================================================================% 
else    
        t=part2T.(part1{1});
        [y, mo, d, h, mn, s]=datevec(t);
        s1=h*60*60;
        s2=mn*60;
        Nz0=(s1+s2+s)*table2{1,7};
        Nz0=zeros(Nz0,1);        
        data_z(1)={[chain{n} '_0001a']};        
        All_zero.(data_z{1})=Nz0;
        %
for m=1:length(part1)-1
    et=table2{m,5};st=table2{m+1,4};
    sta1=table2{m,1};sta2=table2{m+1,1};
    ch1=table2{m,2};ch2=table2{m+1,2};
    sr1=table2{m,7};sr2=table2{m+1,7};    
    val_t=strmatch(et,st);
    val_sta=strmatch(sta1,sta2);
    val_ch=strmatch(ch1,ch2);
    val_sr=strmatch(sr1,sr2);       
    if ~isempty(val_sta) & ~isempty(val_ch) & ~isempty(val_sr) & ~isempty(val_t)
    sta{pp}=sta1;
    ch{pp}=ch1;
    sr{pp}=sr1;
    St{pp}=table2{nn,4};
    Et{pp}=table2{m+1,5};
    ncode=sprintf('%04d',pp);
    try
        data2=part2.(part1{m+1}); 
        data_n(pp)={[chain{n} '_' ncode 'b']};
        data=cat(1,data,data2);
        All_data.(data_n{pp})=data;
        Ns{pp}=Ns{pp}+table2{m+1,3};
        dur{pp}=Ns{pp}/sr{pp};
    catch
        data1=part2.(part1{m});
        data2=part2.(part1{m+1});
        data_n(pp)={[chain{n} '_' ncode 'b']};
        data=cat(1,data1,data2);
        All_data.(data_n{pp})=data;
        Ns{pp}=table2{m,3}+table2{m+1,3};
        dur{pp}=Ns{pp}/sr{pp};
    end
    elseif ~isempty(val_sta) & ~isempty(val_ch) & ~isempty(val_sr) & isempty(val_t)
        disp(num2str(m))
        if m==1
        sta{1}=table2{1,1};
        ch{1}=table2{1,2};
        St{1}=table2{1,4};
        Et{1}=table2{1,5};
        sr{1}=table2{1,7};
        %
        data=part2.(part1{1});
        data_n(pp)={[chain{n} '_0001b']};
        All_data.(data_n{pp})=data;
        %
        et1=table2{m,5};
        ET1=strsplit(et1,{'-' ' ' ':'});
        de=ET1{2};he=ET1{3};me=ET1{4};se=ET1{5};
        st2=table2{m+1,4};
        ST2=strsplit(st2,{'-' ' ' ':'});
        ds=ST2{2};hs=ST2{3};ms=ST2{4};ss=ST2{5};
        s4=(str2num(ds)-str2num(de))*3600*24;
        s3=(str2num(hs)-str2num(he))*3600;
        s2=(str2num(ms)-str2num(me))*60;
        s1=(str2num(ss)-str2num(se));
        Nz=(s4+s3+s2+s1)*sr{pp};
        Nz=zeros(uint32(Nz),1);
        ncode=sprintf('%04d',pp+1);
        data_z(pp(end)+1)={[chain{n} '_' ncode 'a']};        
        All_zero.(data_z{pp(end)+1})=Nz;
        %
        Ns{1}=table2{1,3}; 
        dur{1}=Ns{1}/sr{1};
        pp=pp+1;
        nn=nn+1;
        ncode=sprintf('%04d',pp);
        %Additional--------
        sta{pp}=sta1;
        ch{pp}=ch1;
        sr{pp}=sr1;
        St{pp}=table2{nn,4};
        Et{pp}=table2{m+1,5};
        data2=part2.(part1{m+1});
        %
        et1=table2{m,5};
        ET1=strsplit(et1,{'-' ' ' ':'});
        de=ET1{2};he=ET1{3};me=ET1{4};se=ET1{5};
        st2=table2{m+1,4};
        ST2=strsplit(st2,{'-' ' ' ':'});
        ds=ST2{2};hs=ST2{3};ms=ST2{4};ss=ST2{5};
        s4=(str2num(ds)-str2num(de))*3600*24;
        s3=(str2num(hs)-str2num(he))*3600;
        s2=(str2num(ms)-str2num(me))*60;
        s1=(str2num(ss)-str2num(se));
        Nz=(s4+s3+s2+s1)*sr{pp};
        Nz=zeros(uint32(Nz),1);
        data_z(pp)={[chain{n} '_' ncode 'a']};        
        All_zero.(data_z{pp})=Nz;
        %
        data_n(pp)={[chain{n} '_' ncode 'b']};
        data=data2;
        All_data.(data_n{pp})=data;
        Ns{pp}=table2{m+1,3};
        dur{pp}=Ns{pp}/sr{pp};       
        else
        nn=m+1;
        pp=pp+1;   
        ncode=sprintf('%04d',pp);
        sta{pp}=sta1;
        ch{pp}=ch1;
        sr{pp}=sr1;
        St{pp}=table2{nn,4};
        Et{pp}=table2{m+1,5};
        data2=part2.(part1{m+1});
        %
        et1=table2{m,5};
        ET1=strsplit(et1,{'-' ' ' ':'});
        de=ET1{2};he=ET1{3};me=ET1{4};se=ET1{5};
        st2=table2{m+1,4};
        ST2=strsplit(st2,{'-' ' ' ':'});
        ds=ST2{2};hs=ST2{3};ms=ST2{4};ss=ST2{5};
        s4=(str2double(ds)-str2double(de))*3600*24;
        s3=(str2double(hs)-str2double(he))*3600;
        s2=(str2double(ms)-str2double(me))*60;
        s1=(str2double(ss)-str2double(se));
        Nz=(s4+s3+s2+s1)*sr{pp};
        Nz=zeros(uint32(Nz),1);
        data_z(pp)={[chain{n} '_' ncode 'a']};        
        All_zero.(data_z{pp})=Nz;
        %
        data_n(pp)={[chain{n} '_' ncode 'b']};
        data=data2;
        All_data.(data_n{pp})=data;
        Ns{pp}=table2{m+1,3};
        dur{pp}=Ns{pp}/sr{pp};
        end 
        clear data
    else
        %should not be happened
    end       
end
        et2=table2{m+1,5};
        dayx=strsplit(chain{n},'_');dayx=str2num(dayx{4})+1;
        Eday={[num2str(dayx) ' 00:00:00']};
        val_tE=regexp(et2,Eday{1});
        if isempty(val_tE)
            ET2=strsplit(et2,{'-' ' ' ':'});
            he=ET2{3};me=ET2{4};se=ET2{5};
            s3=str2num(he)*3600;
            s2=str2num(me)*60;
            se=str2num(se);
            Nz=((3600*24)-(s3+s2+se))*sr{pp};
            Nz=zeros(uint32(Nz),1);            
            data_z(pp+1)={[chain{n} '_' ncode 'c']};        
            All_zero.(data_z{pp+1})=Nz;     
        end        
    table2=table2((length(part1)+1:end),:);
    dur2={};
for q=1:length(dur)
    dur_x=dur{q};
    dd=floor(dur_x/(86400));dr=rem(dur_x,86400);if dd==0 dd2='';else dd2=([num2str(dd) 'd']);end
    hh=floor(dr/3600);hr=rem(dr,3600);if hh==0 hh2='';else hh2=([num2str(hh) 'h']);end
    mm=floor(hr/60);if mm==0 mm2='';else mm2=([num2str(mm) 'm']);end
    ss=rem(hr,60);if ss==0 ss2='';else ss2=([num2str(ss) 's']);end      
    dur1={[dd2 hh2 mm2 ss2]}; 
    dur2{q}=dur1{1};
end
    sr=cell2mat(sr);sr=sr/decif;sr=num2cell(sr);
    Ns=cell2mat(Ns);Ns=Ns/decif;Ns=num2cell(uint32(Ns));
    sta=sta';ch=ch';Ns=Ns';St=St';Et=Et';dur2=dur2';sr=sr';
    tableX=[sta ch Ns St Et dur2 sr];
    table_pop.(chain{n})=tableX;
    try
        new_table=cat(1,new_table,tableX);
    catch
        new_table=tableX;
    end
    %
    try
    data_list=[data_n data_z];
    catch
    data_list=data_n;
    end
    %
    zn=1;
    for zz=1:length(data_list)
        if ~isempty(data_list{zz})
            data_list{zn}=data_list{zz};
            zn=zn+1;
        else
            %skip
        end
    end
    data_list(zn:end)='';    
    data_list=sortrows(data_list');
    selected_field={};
    for i=1:length(data_list)
        v=regexp(data_list(i),[chain{n} '\w*'],'match');
        if  (~isempty(v{1}))
            selected_field{end+1}=data_list{i};
        end
    end
    for r=1:length(selected_field)
        aa=isfield(All_data,[selected_field{r}]);
        if aa==1
        data_m=All_data.(selected_field{r});     
        try 
            data_M=cat(1,data_M,data_m);
        catch
            data_M = data_m;
        end
        end
    end
    meanD=mean(data_M);
    clear data_M
    waitbar(wb/length(chain),WB, ...
    ['Decimating and saving daily data... (' ...
    num2str(ceil((wb/length(chain))*100)) '%)']) 
    for z=1:length(selected_field)
        try
            new_data=All_data.(selected_field{z});        
            new_data=new_data-meanD;
            All_data=rmfield(All_data,[selected_field{z}]);
        catch
            new_data=All_zero.(selected_field{z});
            All_zero=rmfield(All_zero,[selected_field{z}]);
        end
        %
        try
            DATA=cat(1,DATA,new_data);
        catch
            DATA=new_data;
        end
    end
    sr_inf=tableX{1,7};    
    bb=strmatch('1d',tableX{1,6},'exact');
    if ~isempty(bb)
        data_name(n)={['M_' chain{n} '_' num2str(sr_inf)]};
        full_tab(P,:)=tableX(1,:);
        P=P+1;
    else
        data_name(n)={['Mx_' chain{n} '_' num2str(sr_inf)]};
    end
    %
    DATA=decimate(DATA,decif);
    Data_storage.(data_name{n})=DATA;    
    clear tableX
    clear DATA; clear data; clear data_n; clear data_z; clear data_list
end
wb=wb+1; 
end
waitbar(1,WB,'Merging is completed')
handles.table2=new_table;
handles.FN=Data_storage;
handles.file_n2=data_name;
handles.tt=tt;
handles.table_pop=table_pop;%<<<
handles.chain=chain;%<<<
handles.full_tab=full_tab;%<<<

set(handles.plot_b,'visible','on')
set(handles.pop1,'enable','on')
set(handles.plot_b,'enable','on')
set(handles.uitable1,'data',new_table)%
set(handles.pop1,'string',data_name)%
set(handles.save_b,'enable','on')
set(handles.save_m,'enable','on')

guidata(hObject,handles)
close(WB)
else
end

function plot_b_Callback(hObject, eventdata, handles)
try
handles.axes1=handles.AXEZ;
end
pos1 = getpixelposition(handles.axes1);
try
delete(handles.axes1)
end
handles.axes1=axes('unit','pixel','Position',pos1);
% handle
% setpixelposition(axes1,pos1);
data_name=handles.file_n2;
Data_storage=handles.FN;
tt=handles.tt;
chain=handles.chain;
table_pop=handles.table_pop;
n=get(handles.pop1,'value');
data=Data_storage.(data_name{n});
dmax=max(abs(data));
data=data/dmax;
srX=strsplit(data_name{n},'_');srX=str2num(srX{end});
Ns=length(data);
x1=0;
x2=Ns/srX;
Xline=linspace(x1,x2,Ns);
% 
st=datestr(tt(n),'dd-mmm-yyyy HH:MM:SS');
new_t='00:00:00';
st=strsplit(st,' ');%st=st{1};
SS={[st{1} ' ' new_t]};
SS2=st{1};
ts1 = timeseries(data,Xline);
ts1.Name = '';
ts1.TimeInfo.Units = 'seconds';
ts1.TimeInfo.StartDate=SS;
ts1.TimeInfo.Format = 'dd-mmm-yyyy HH:MM:SS';
% figure()
XX=plot(ts1);hold on
%filling the middle zero areas--------------------------------------------%
tableX=table_pop.(chain{n});
for k=1:size(tableX,1)-1
    end1=strsplit(tableX{k,5},{' ' ':'});
    h1=str2num(end1{2});m1=str2num(end1{3});s1=str2num(end1{4});
    Ne=((h1*3600)+(m1*60)+(s1))*tableX{k,7};
    Ne=Ne/Ns;
    start1=strsplit(tableX{k+1,4},{' ' ':'});
    h1=str2num(start1{2});m1=str2num(start1{3});s1=str2num(start1{4});
    Nst=((h1*3600)+(m1*60)+(s1))*tableX{k+1,7};
    Nst=Nst/Ns;
    N=patch([Ne Nst Nst Ne],[-0.5 -0.5 0.5 0.5],'red');
    set(N,'facealpha',0.5)
    set(N,'EdgeColor','none');
end
%filling the left side zero area------------------------------------------%
Etime=strsplit(tableX{1,4},{'-' ' '});
yr=Etime{1};day1=Etime{2};Xtime2=Etime(3);
stA={[yr '-' day1 ' 00:00:00']};
stA2={[yr '-' day1]};
val_t1=regexp(tableX{1,4},stA);
if isempty(val_t1{1})
    Xtime2=strsplit(Xtime2{1},{':'});
    h1=str2num(Xtime2{1});m1=str2num(Xtime2{2});s1=str2num(Xtime2{3});
    Nst=((h1*3600)+(m1*60)+(s1))*tableX{1,7};
    Nst=Nst/Ns;
    N=patch([0 Nst Nst 0],[-0.5 -0.5 0.5 0.5],'red');
    set(N,'facealpha',0.5)
    set(N,'EdgeColor','none');
end
%filling the right side zero area-----------------------------------------%
Etime=strsplit(tableX{end,5},{'-' ' '});
yr=Etime{1};day1=str2num(Etime{2});Xtime2=Etime(3);
stA={[yr '-' num2str(day1) ' 00:00:00']};
val_t1=regexp(tableX{end,5},stA);
if isempty(val_t1{1})
    Xtime2=strsplit(Xtime2{1},{':'});
    h1=str2num(Xtime2{1});m1=str2num(Xtime2{2});s1=str2num(Xtime2{3});
    Net=((h1*3600)+(m1*60)+(s1))*tableX{1,7};
    Net=Net/Ns;
    N=patch([Net 1 1 Net],[-0.5 -0.5 0.5 0.5],'red');
    set(N,'facealpha',0.5)
    set(N,'EdgeColor','none');
end
set(handles.axes1,'ylim',[-1.1 1.1],'fontsize',8)
set( get(handles.axes1,'ylabel'),'String','Normalized data','fontsize',8 )
set( get(handles.axes1,'xlabel'),'String','Time','fontsize',8 )
set( get(handles.axes1,'title'),'String',['Station: ' tableX{1,1}...
    ' | Channel: ' tableX{1,2} ' | Date: ' SS2 ' | Samp. rate: '...
    num2str(tableX{1,7}) 'Hz'],'fontsize',8,'fontweight','bold')
hold off
handles.AXEZ=handles.axes1;
guidata(hObject,handles)

% Saving function ======================================================= % 
function save_b_Callback(hObject, eventdata, handles)
opsiS=questdlg({'This command will save any daily (full) data'...
    'and ignore the incomplete ones' 'Do you want to proceed?'}, ...
    'Saving file(s)','Yes','No','Yes');
if strcmp(opsiS,'Yes')
folder_name = uigetdir('C:\','Select directory to save');
cd (folder_name);
chain=handles.chain;
Data_storage=handles.FN;
full_tab=handles.full_tab;
data_name=handles.file_n2;
h=waitbar(0,'Saving file...');
P=1;
for i=1:length(data_name)
        v=regexp(data_name(i),['M_' chain{i} '\w*'],'match');
        if  (~isempty(v{1}))
            infodat=full_tab(P,:);
            data_namex=strsplit(data_name{i},'_');
            dx=data_namex{3};
            dx=dx(end);
            data_namex{3}=dx;data_namex=data_namex(1:5);
            data_name2=strjoin(data_namex,'_');
            data=Data_storage.(data_name{i});
            save(data_name2,'data','infodat')
            P2=i/length(data_name);
            waitbar(P2,h,['Saving data... (' num2str(ceil(P2*100)) ')%']);
            P=P+1;
        end        
end
close(h)
else
    %skip
end

function pushbutton7_Callback(hObject, eventdata, handles)
FilterG;

function decif_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mergeB_CreateFcn(hObject, eventdata, handles)

function edit6_Callback(hObject, eventdata, handles)

function edit6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pop1_Callback(hObject, eventdata, handles)

function pop1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function axes1_CreateFcn(hObject, eventdata, handles)

function file_m_Callback(hObject, eventdata, handles)

function Untitled_4_Callback(hObject, eventdata, handles)

function cnm_m_Callback(hObject, eventdata, handles)

function filter_m_Callback(hObject, eventdata, handles)
% close(gcf)
FilterG

function stack_m_Callback(hObject, eventdata, handles)
% close(gcf)
StackG_V2

function dispersion_m_Callback(hObject, eventdata, handles)
DispersionG
    
function mapping_m_Callback(hObject, eventdata, handles)
MappingG
    
% Load/open file from menubar =========================================== %
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
set(handles.r_log2,'string',rep1)
set(handles.pushbutton3,'enable','on')
guidata(hObject,handles)

% Saving from menubar =================================================== %
function save_m_Callback(hObject, eventdata, handles)
opsiS=questdlg({'This command will save any daily (full) data'...
    'and ignore the incomplete ones' 'Do you want to proceed?'}, ...
    'Saving file(s)','Yes','No','Yes');
if strcmp(opsiS,'Yes')
folder_name = uigetdir('C:\','Select directory to save');
cd (folder_name);
chain=handles.chain;
Data_storage=handles.FN;
full_tab=handles.full_tab;
data_name=handles.file_n2;
h=waitbar(0,'Saving file...');
P=1;
for i=1:length(data_name)
        v=regexp(data_name(i),['M_' chain{i} '\w*'],'match');
        if  (~isempty(v{1}))
            infodat=full_tab(P,:);
            data_namex=strsplit(data_name{i},'_');
            dx=data_namex{3};
            dx=dx(end);
            data_namex{3}=dx;data_namex=data_namex(1:5);
            data_name2=strjoin(data_namex,'_');
            data=Data_storage.(data_name{i});
            save(data_name2,'data','infodat')
            P2=i/length(data_name);
            waitbar(P2,h,['Saving data... (' num2str(ceil(P2*100)) ')%']);
            P=P+1;
        end        
end
close(h)
else
    %skip
end

% Quit current GUI ====================================================== %
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

% Key stroke function in files display ================================== %
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

% Additional function ====================================================%
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
             set(handles.pushbutton3,'enable','on')
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
            set(handles.r_log2,'string',handles.log)
            set(handles.pushbutton3,'enable','on')
            guidata(hObject,handles)
            catch
                %skip
            end
            
        function opsi3(varargin)
            handles=varargin{5};
            hObject=varargin{3};
            [a b c]=uigetfile('*','Select file... (you can select multiple files)','multiselect','on');            
            try
            cd(b)
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
            set(handles.r_log,'string',handles.log)
            set(handles.pushbutton3,'enable','on')
            guidata(hObject,handles)
            catch
            end
% ======================================================================= %
            
function Untitled_14_Callback(hObject, eventdata, handles)

function Untitled_15_Callback(hObject, eventdata, handles)

function Untitled_13_Callback(hObject, eventdata, handles)

function X_corr_Callback(hObject, eventdata, handles)
% close(gcf)
XcorrG

% Reset function ======================================================== %
function pushbutton10_Callback(hObject, eventdata, handles)
blankx={};
set(handles.uitable1,'data',blankx)
set(handles.show_dir,'string',blankx)
set(handles.decif,'string',[])
set(handles.pop1,'string','-','value',1)
handles.NL=blankx;
 try    handles=rmfield(handles,'parts');end
 try    handles=rmfield(handles,'All_parts');end
 try    handles=rmfield(handles,'All_time');end
 try    handles=rmfield(handles,'All_sr');end
 try    handles=rmfield(handles,'table1');end
 try    handles=rmfield(handles,'dff');end
 try    handles=rmfield(handles,'FN');end
 try    handles=rmfield(handles,'file_n2');end
 try    handles=rmfield(handles,'table_pop');end
 try    handles=rmfield(handles,'chain');end
 set(handles.uitable1,'enable','off')
 set(handles.text5,'enable','off')
 set(handles.mergeB,'enable','off')
 set(handles.decif,'enable','off') 
 set(handles.save_b,'enable','off')
 set(handles.pop1,'enable','off')
 set(handles.plot_b,'enable','off')
 set(handles.save_m,'enable','off')
 set(findall(handles.axes1, '-property', 'visible'), 'visible', 'off')
%  delete (handles.axes1)
%  set(handles.axes1,'visible','off')
%  set(handles.uipanel3,'enable','on')
%  set(handles.
guidata(hObject,handles)

function axes1_ButtonDownFcn(hObject, eventdata, handles)
% seltype = get(gcf,'selectiontype');

function axes2_ButtonDownFcn(hObject, eventdata, handles)
% seltype = get(gcf,'selectiontype');

function varargout = StackG_V2(varargin)
% STACKG_V2 MATLAB code for StackG_V2.fig
%      STACKG_V2, by itself, creates a new STACKG_V2 or raises the existing
%      singleton*.
%
%      H = STACKG_V2 returns the handle to a new STACKG_V2 or the handle to
%      the existing singleton*.
%
%      STACKG_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STACKG_V2.M with the given input arguments.
%
%      STACKG_V2('Property','Value',...) creates a new STACKG_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StackG_V2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StackG_V2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StackG_V2

% Last Modified by GUIDE v2.5 29-Oct-2015 23:11:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StackG_V2_OpeningFcn, ...
                   'gui_OutputFcn',  @StackG_V2_OutputFcn, ...
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


function StackG_V2_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
addpath(pwd)
handles.posx1=get(handles.uitable1,'position');
set([handles.uitable1,handles.uitable2],'data',{})
guidata(hObject, handles);

function varargout = StackG_V2_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function stack_b_Callback(hObject, eventdata, handles)
n=get(handles.pop1,'value');
All_dat=handles.All_dat;
Tablist=handles.Tablist;
tab_n=handles.tab_n;
current_tab=Tablist.(tab_n{n});
all_day=current_tab(:,3);
all_day=sort(all_day);
if length(all_day)==1;
    year1=strsplit(all_day{1},'-');year1=year1{1};
    yearlist{1}=year1;
else    
    p1=1;
    for n1=2:length(all_day)
        year1=strsplit(all_day{n1-1},'-');year1=year1{1};
        year2=strsplit(all_day{n1},'-');year2=year2{1};
        if  year1==year2
                yearlist{p1}=year1;
        else
                p1=p1+1;
                yearlist{p1}=year2;
        end
    end    
    for n1=1:length(yearlist)
        file_n={};
        for n2=1:length(all_day)
            v=regexp(all_day(n2),[yearlist(n1) '\w*'],'match');
            if  (~isempty(v{1}))
                file_n{end+1}=all_day{n2};
            end
        end
        a=strsplit(file_n{1},'-');
        b=strsplit(file_n{end},'-');
        trace_lim{1}=str2num(a{2});
        trace_lim{2}=str2num(b{2});
        Lim_traces.(['traces_' yearlist{n1}])=trace_lim;
        All_traces.(['traces_' yearlist{n1}])=file_n;
    end
end
%Xtick
Xn=0;
for n1=1:length(yearlist)
    X=Lim_traces.(['traces_' yearlist{n1}]);
    x1=X{1};x2=X{2};
    N=x2-x1;
    NN.(['traces_' yearlist{n1}])=N;
    Xn=Xn+N;
end
Xs=ceil(Xn/10);
for n1=1:length(yearlist)
    b={};
    p=2;
    N=NN.(['traces_' yearlist{n1}]);
    b{1}=0;
    for n2=1:N
        a=rem(n2,Xs);
        if a==0
            b{p}=n2;
            p=p+1;
        else
            %skip
        end        
    end    
    XTn.(['traces_' yearlist{n1}])=b;
end
B=[];
B2=[];
for n1=1:length(yearlist)    
    N=[];
    b=XTn.(['traces_' yearlist{n1}]);
    try
    c=rem(NN.(['traces_' yearlist{n1-1}]),Xs);
    N=NN.(['traces_' yearlist{n1-1}]);
    catch
        %skip
    end
    b=cell2mat(b)+n1;d=b(1)-1;
%     b=[d b];
    b2=[d];
    try        
    b=b+(N+1)+(n1-1);
    b2=b2+(N+1)+(n1-1);
    catch
    b=b+1;
    b2=b2+1;
    end
    B=[B b];
    B2=[B2 b2];
end
% xticklabel
A=[];
XT={};
XT2={};
for n1=1:length(yearlist)
    
    clim=Lim_traces.(['traces_' yearlist{n1}]);
    c=linspace(clim{1},clim{2},(clim{2}-clim{1}+1));
    b=XTn.(['traces_' yearlist{n1}]);
    b=cell2mat(b);
    a=[];
    a(1)=c(1);
    try
        for n2=1:length(b)
            a(n2+1)=c((Xs*n2)+1);
        end
    catch
        %skip
    end    
    A=[A a];
    Ac=num2cell(a);
    C=[yearlist(n1) Ac];
    C2=yearlist(n1);
    XT=[XT Ac];
    XT2=[XT2 C2];
end
% Plotting ============================================================== %
a=Tablist.(tab_n{n});%a=strrep(a{1,4},'-','_');%<----value
a1=a{1,1};  %station pair
a2=a{1,2};  %channel
a3=a{1,4};  %freq. bandwidth
a4=a{1,6};  %sample rate
a5=a{1,5};  %number sample
newfig=figure('numbertitle','off','name', ...
    ['Station pair: ' a1 ' | Channel: ' a2 ' | Freq. bandwidth: ' a3]); 
%ax = axes('Parent',f)
set(gcf,'position', [100 150 1000 580])
AA=axes('Position',[0.075,0.2,0.7,0.7]);
BB=axes('Position',[0.84,0.2,0.11,0.7]);
CC=axes('Position',[0.075,0.075,0.875,0.04]);
set([AA BB CC],'yticklabel','','xticklabel','');
whitebg(gcf,[0 0 0])
%-------------------------------------------------------------------------%
titleA={['Station pair: ' a1 ' | Channel: ' a2 ' | Freq. bandwidth: ' a3]};
titleB={'Stacked data'};
xlabelA={'Days'};
xlabelB={'Normalized ampl.'};
xx=(str2num(a5)/a4)/2;
Lx=linspace(-xx,xx,str2num(a5));
p=1;
f=1;
for n1=1:length(yearlist)
    clim=Lim_traces.(['traces_' yearlist{n1}]);
    q=1; 
    axis ij
    plot(p,Lx,'color','r','parent',AA);axis(AA,'ij')
    if ishold(AA)
        %skip
    else
        hold (AA);
    end
    p=p+1;   
    for n2=clim{1}:clim{2}
        file_n2={['X_' a1 '_' a2 '_' yearlist{n1} '_' num2str(n2) '_' a3 '_' num2str(a4)]};
        file_n2=regexprep(file_n2,'-','_');
        file_n2{1}=strrep(file_n2{1},'.','');
        try
            data=All_dat.(tab_n{n}).(file_n2{1});                      
            prestack(:,f)=data;
            f=f+1;
            for k=1:str2num(a5);
                if  data(k)>=0;
                    fp(k)=data(k);
                else 
                    fp(k)=0;
                end
            end
            data(1)=0;
            data(str2num(a5))=0;
            fp(1)=0;
            fp(str2num(a5))=0;            
            pl{p}=plot((data/3)+p,Lx,'g','parent',AA);
            hh=patch ((fp/3)+p,Lx,'g','parent',AA);
            set(hh,'EdgeColor','none');
            set(AA,'xtick',B)
            set(AA,'xticklabel',XT)         
            p=p+1;
        catch
            q=q+1;
            p=p+1;
            disp(['err' num2str(q)])
        end
    end   
end
hx = get(AA,'XLabel');
set(hx,'Units','data'); 
pos = get(hx,'Position'); 
ypos= pos(2); 
        for z=1:length(B2)
            t(z) = text(B2(z),xx+((1/25)*xx),XT2(1,z),'parent',AA);
        end
set(AA,'xlim',[0 p],'ylim',[-xx xx])        
set(t,'Rotation',90,'HorizontalAlignment','right','fontsize',8)

% Plotting stacked data-------------------------------------------------- %
stacked=sum(prestack,2);
maxS=max(abs(stacked));stacked=(stacked/maxS)*(2/3);
%~~~~~~~~~~~~~~~%
for k=1:str2num(a5);
    if  stacked(k)>=0;
        fp(k)=stacked(k);
    else 
        fp(k)=0;
    end
end
stacked(1)=0;
stacked(str2num(a5))=0;
fp(1)=0;
fp(str2num(a5))=0;  
%~~~~~~~~~~~~~~~%         
plot(stacked,Lx,'g','parent',BB);axis(BB,'ij');hold(BB);
patch (fp,Lx,'g','parent',BB,'edgecolor','none');axis ij;
set(BB,'xlim',[-1 1],'ylim',[-xx xx])

% Plotting peak auto detect---------------------------------------------- %
if  (get(handles.auto_p,'Value') == get(handles.auto_p,'Max'))
    [Yp,Xp] = findpeaks(stacked,'SortStr','descend');
    [Yn,Xn] = findpeaks((stacked*-1),'SortStr','descend');
    GbY=[Yp;Yn]; [Ys, I]=sort(GbY,'descend');
    GbX=[Xp;Xn]; [Xs]=sort(GbX,'descend'); 
    Xloc=GbX(I(1));
    Tloc=(Xloc/a4)-((str2num(a5)/a4)/2);
    Ym=Ys(1);
    set(BB,'nextplot','add')
    
    plot([-1.5,1.5],[Tloc Tloc],'color','r','linestyle',':','linewidth',...
        2,'Parent',BB, 'Tag', 'ThePlotTag', 'HitTest', 'off');
    plot(Ym+0.15,Tloc,'<','MarkerSize',10,'MarkerFaceColor','r', ...
        'parent',BB);
    plot(-Ym-0.15,Tloc,'>','MarkerSize',10,'MarkerFaceColor','r', ...
        'parent',BB);
    
%     set(handles.time_lag,'string', ...
%       ['Time lag: ' num2str(Tloc) ' second(s)'])    
else
    %skip
end
%-------------------------------------------------------------------------%

% hx1=get(AA,'ylabel');set(hx1,'Units','data');
% hx2=get(BB,'yLabel');set(hx2,'Units','data');
% hx3=get(AA,'title');set(hx3,'Units','data');
% hx4=get(BB,'title');set(hx4,'Units','data'); 
% hx5=get(AA,'xlabel');set(hx5,'Units','data');
% hx6=get(BB,'xLabel');set(hx6,'Units','data');
% 
% pos1=get(hx1,'Position'); 
% pos2=get(hx2,'Position');
% pos3=get(hx3,'Position'); 
% pos4=get(hx4,'Position');
% pos5=get(hx5,'Position'); 
% pos6=get(hx6,'Position');
% 
% t2(1)=text(pos1(1),pos1(2),'Time lag (second)','fontweight','bold','parent',AA);
% t2(2)=text(pos2(1)+0.52,pos2(2),'Time lag (second)','fontweight','bold','parent',BB);
% t3(1)=  text(pos3(1),pos3(2)-10,titleA,'fontweight','bold',...
%         'HorizontalAlignment','center','parent',AA,'fontsize',11);
% t3(2)=  text(pos4(1),pos4(2)-10,titleB,'fontweight','bold',...
%         'HorizontalAlignment','center','parent',BB,'fontsize',11);
% t3(3)=  text(pos5(1),pos5(2)+18,xlabelA,'fontweight','bold',...
%         'HorizontalAlignment','center','parent',AA,'fontsize',10);
% t3(4)=  text(pos6(1),pos6(2),xlabelB,'fontweight','bold',...
%         'HorizontalAlignment','center','parent',BB,'fontsize',10);    
    
% set(t2,'Rotation',90,'HorizontalAlignment','center','fontsize',10)
% 
titA=get(AA,'title');
titB=get(BB,'title');
labelAx=get(AA,'xlabel');
labelBx=get(BB,'xlabel');
labelAy=get(AA,'ylabel');
labelBy=get(BB,'ylabel');
% handleX=[titA, titB, labelAx, labelBx, labelAy, labelBy];
% set(handleX,'unit','pixel')
ptitA=get(titA,'position');%ptitA(2)=ptitA(2)+2;
ptitB=get(titB,'position');%ptitB(2)=ptitB(2)+2;
plabelAx=get(labelAx,'position');
plabelBx=get(labelBx,'position');
plabelAy=get(labelAy,'position');
plabelBy=get(labelBy,'position');
set(titA,'position',ptitA,'string',titleA,'fontweight','bold',...
   'fontsize',11)
set(titB,'position',ptitB,'string',titleB,'fontweight','bold',...
   'fontsize',11)
set(labelAx,'position',plabelAx,'string',xlabelA,'fontweight','bold',...
   'fontsize',9)
set(labelBx,'position',plabelBx,'string',xlabelB,'fontweight','bold',...
   'fontsize',9)
set(labelAy,'position',plabelAy,'string','Time lag','fontweight','bold',...
   'fontsize',9)
set(labelBy,'position',plabelBy,'string','Time lag','fontweight','bold',...
   'fontsize',9)
% Time lag, distance, velocity ------------------------------------------ %
dis=Tablist.(tab_n{n});dis=dis{1,7};
if get(handles.auto_p,'value')==get(handles.auto_p,'max')
    vel=str2num(dis)/Tloc;
    text(0.5, 0.5, ['Delay Time = ' num2str(Tloc) ...
    ' second(s)  |  Velocity = '...
    num2str(vel) ' km/sec  |  Distance = ' dis ' km'], ...
    'Color','g','FontSize',10,...
    'FontWeight','bold','horizontalAlignment', 'center');
    set(CC,'xtick',[],'ytick',[]);
else
    text(0.5, 0.5, ['Delay Time = ' '-' ' second(s)  |  Velocity = '...
    '-' ' km/sec  |  Distance = ' dis ' km'],'Color','g','FontSize',10,...
    'FontWeight','bold','horizontalAlignment', 'center');
    set(CC,'xtick',[],'ytick',[]);
end
% for n=1:length(pl)
%     pp=pl{n};
% set(pp,'color','r')
% end
%-------------------------------------------------------------------------%

function add_b_Callback(hObject, eventdata, handles)
if isfield(handles,'NL') & isfield(handles,'dcoor')
sta_list=handles.NL;
selected_file={};
m=1;
h=waitbar(0,'Verifying files and sorting data...');
for i=1:length(sta_list)
                v=regexp(sta_list(i),['X_\w*.mat'],'match');
            if  (~isempty(v{1}))
                selected_file{end+1}=sta_list{i};
            end
end
coor=handles.coor;
if handles.idf==1
    %Convert degree to UTM-------------------------------------------------%
    stacoor=coor(:,1);
    for m=1:size(coor,1)
    [East,North]=deg2utm(coor{m,2},coor{m,3});
    latX{m}=East;
    lonX{m}=North;    
    end
    coor=[stacoor latX' lonX'];
    %---------------------------------------------------------------------%    
else
    %skip
end
m=1;
for n1=1:length(selected_file)     
    load([selected_file{n1}])
    sta=strsplit(infodat{1,1},'-');sta1=sta{1};sta2=sta{2};
    ind1=getnameidx(coor,sta1);
    ind2=getnameidx(coor,sta2);
    coor1=coor(ind1,2:3);
    coor2=coor(ind2,2:3);
    coorX=[coor1;coor2];
    x=(coorX{2,1}-coorX{1,1})/1000;y=(coorX{2,2}-coorX{1,2})/1000;
    dist=sqrt((x^2)+(y^2));    
    All_inf(m,1:6)=infodat(1:6);
    All_inf{m,7}=sprintf('%0.2f',dist);
    m=m+1;        
end
  p1=1;p2=1;p3=1;p4=1;
  All_infa=sortrows(All_inf,1);
  All_infb=sortrows(All_inf,2);
  All_infc=sortrows(All_inf,4);
  All_infd=sortrows(All_inf,6);
for m=2:(length(selected_file)-1)
    a1=All_infa{m-1,1};a2=All_infa{m,1};
    b1=All_infb{m-1,2};b2=All_infb{m,2}; 
    c1=All_infc{m-1,4};c2=All_infc{m,4};
    d1=All_infd{m-1,6};d2=All_infd{m,6};    
    aa=strrep(a1,'-','_');
    pairlist{p1}=aa;
    chalist{p2}=b1(1);
    cc=strrep(c1,'.','');
    cc=strrep(cc,'-','_');
    bwlist{p3}=cc;
    srlist{p4}=d1;
    cs1=strmatch(a1,a2);
    cs2=strmatch(b1,b2);
    cs3=strmatch(c1,c2);
    cs4=strmatch(d1,d2);    
    if ~isempty(cs1)
        aa=strrep(a1,'-','_');
        pairlist{p1}=aa;
    else
        p1=p1+1;
        aa=strrep(a2,'-','_');
        pairlist{p1}=aa;
    end
    %
    if ~isempty(cs2)
        chalist{p2}=b1(1);
    else
        p2=p2+1;
        chalist{p2}=b2(1);
    end
    %    
    if ~isempty(cs3)
        bw_dot{p3}=c1;
        cc=strrep(c1,'-','_');
        cc=strrep(cc,'.','');
        bwlist{p3}=cc;
    else
        p3=p3+1;
        bw_dot{p3}=c2;
        cc=strrep(c2,'-','_');
        cc=strrep(cc,'.','');
        bwlist{p3}=cc;
    end
    %
    if ~isempty(cs4)
        srlist{p4}=d1;
    else
        p4=p4+1;
        srlist{p4}=d2;
    end    
end
p=1;
% waitbar(1/3,h,['Sorting files... (1/3)']);
for lp1=1:length(pairlist)
    for lp2=1:length(chalist)
        for lp3=1:length(bwlist)
            for lp4=1:length(srlist)                
                tab_n(p)=  {['X_' pairlist{lp1} '_' chalist{lp2} '_' bwlist{lp3}...
                            '_' num2str(srlist{lp4})]};
                tab_n2(p)=  {['X_' pairlist{lp1} '_' chalist{lp2} '_\w*_\w*_' bwlist{lp3}...
                            '_' num2str(srlist{lp4})]}; 
                p=p+1;
            end
        end
    end
end
p=1;
waitbar(0,h,['Loading data...']);
I=length(sta_list);
K=length(tab_n2);
q2=1;
for k=1:K
    selected_file={}; 
    q=1;
    for i=1:I
                v=regexp(sta_list(i),[tab_n2(k) '.mat'],'match');
            if  (~isempty(v{1}))
                selected_file{end+1}=sta_list{i};
                load([selected_file{q}])
                max_t=(str2num(infodat{1,5})-1)/infodat{1,6};
                tab_inf(q,1:6)=infodat(1:6);
                tab_inf{q,7}=All_inf{q2,7};
                tab_inf{q,8}=num2str(max_t/2);
                a=strsplit(selected_file{q},'.');a=a{1};
                tab_dat.(a)=data;
                q=q+1; 
                q2=q2+1;
                Q=calP(I,K,i,k);
                waitbar((Q/100),h,['Loading data...(' ...
                    num2str(ceil(Q)) '%)']); 
            end    
    end
    All_dat.(tab_n{p})=tab_dat;
    Tablist.(tab_n{p})=tab_inf;    
    p=p+1;
    clear tab_dat
    clear tab_inf
end
waitbar(1,h,['Saving handles...']);
handles.All_dat=All_dat;
handles.Tablist=Tablist;
handles.tab_n=tab_n;
set(handles.pop1,'string',tab_n,'value',1)
set(handles.uitable1,'data',Tablist.(tab_n{1}))
hE=[handles.uitable1, handles.pop1, handles.stack_b, handles.auto_p,...
    handles.save_b, handles.save_m handles.text4 handles.text5 ...
    handles.map_b];
% set(hE,'visible','on');
set(hE,'enable','on');
guidata(hObject,handles)
close(h)
else
    if ~isfield(handles,'NL')
        msgbox('No input data found','Failed to load data','warn')
    else
        msgbox('No coordinate data found','Failed to load coordinates','warn')
    end
end
%Progress calculation-----------------------------------------------------%
function [Q]=calP(I,K,i,k)
    P1=((k-1)/K)*100;
    P2=(((i)/I)/K)*100;
%     P3=((((lp3-1)/L3)/(L1*L2))*100);
%     P4=(((lp4/Lp)/(L1*L2*L3))*100);
    Q=P1+P2;
%-------------------------------------------------------------------------%    

function pop1_Callback(hObject, eventdata, handles)
n=get(handles.pop1,'value');
Tablist=handles.Tablist;
tab_n=handles.tab_n;
set(handles.uitable1,'data',Tablist.(tab_n{n}))

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
set(handles.log_r,'string',rep1)
guidata(hObject,handles)

function log_r_Callback(hObject, eventdata, handles)

function log_r_CreateFcn(hObject, eventdata, handles)
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
%Additional_function======================================================%
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
            set(handles.show_dir,'string',newlist,'value',1)
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
            set(handles.show_dir,'string',newlist,'value',1)
            handles.NL=newlist;
            set(handles.add_b,'enable','on')
            guidata(hObject,handles)
            catch
                %skip
            end
%=========================================================================%
            
function coor_b_Callback(hObject, eventdata, handles)
choice = questdlg('Which type of coordinate data you want to load?', ...
	'Coordinate type', ...
	'Degree','UTM','Cancel','Degree');
% Handle response
switch choice
    case 'Degree'        
        handles.idf = 1;
    case 'UTM'    
        handles.idf = 2;
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
handles.coor=coor;
set(handles.uitable2,'data',coor2)
if handles.idf==1
    set(handles.uitable2,'columnname', ...
        {'Station' 'Latitude' 'Longitude'},'columnwidth',{60 70 70})
elseif handles.idf==2
    set(handles.uitable2,'columnname', ...
        {'Station' 'Easting' 'Northing' 'Long. zone' 'Lat. zone'}, ...
        'columnwidth',{60 70 70 70 70})
end
set([handles.text4, handles.uitable2],'visible','on')
set([handles.uitable2, handles.add_b, handles.map_b],'enable','on')
guidata(hObject,handles)
catch
end
else
    %skip the process
end

function reset_b_Callback(hObject, eventdata, handles)
blankx={};
% Hblank= [handles.ucornerx, handles.lcornerx, handles.center_freq, ...
%         handles.gauss_dev];
set(handles.uitable1,'data',blankx)
set(handles.uitable2,'data',blankx)
set(handles.show_dir,'string',blankx)
% set(handles.tdlim,'string',[])
set(handles.pop1,'string','-','value',1)
% handles.NL=blankx;
% 
 try    handles=rmfield(handles,'tab_n');end
 try    handles=rmfield(handles,'tab_n2');end
 try    handles=rmfield(handles,'All_dat');end
 try    handles=rmfield(handles,'Tablist');end
 try    handles=rmfield(handles,'All_traces');end
 try    handles=rmfield(handles,'NL');end
 try    handles=rmfield(handles,'dcoor');end
%   
handlesX=   [handles.uitable1,handles.uitable2, handles.stack_b,...
            handles.save_b, handles.add_b, handles.save_m, handles.pop1,...
            handles.auto_p, handles.map_b];
            
handlesX2=  [handles.auto_p];
set(handlesX,'enable','off')
set(handlesX2,'value',0)
% set(handles.time_lag,'string','Time lag:')
% set(findall(handles.axes1, '-property', 'visible'), 'visible', 'off')
guidata(hObject,handles)

function auto_p_Callback(hObject, eventdata, handles)

function save_b_Callback(hObject, eventdata, handles)
folder_name=uigetdir(pwd,'Select directory to save');
Tablist=handles.Tablist;
All_dat=handles.All_dat;
tab_n=handles.tab_n;
cd(folder_name)
h=waitbar(0,'Saving file...');
for n=1:length(tab_n)
    A={};
    B={};
    s_data=All_dat.(tab_n{n});
    s_data=struct2cell(s_data);
    for m=1:length(s_data)
        data(:,m)=s_data{m};
    end
    n_data=sum(data,2);
    tab_nx=strsplit(tab_n{n},'_');tab_nx{1}='S';
    tab_n3=strjoin(tab_nx,'_');
    s_name=[tab_n3 '.mat'];
    A=Tablist.(tab_n{n});
    B=A(1,1:2);
    B(1,3:7)=A(1,4:8);
    inf_dat=B;
    save(s_name,'n_data','inf_dat')
    P=length(tab_n);
    P=(n/P);
    waitbar(P,h,['Saving file...' num2str(ceil(P*100)) '%']);
end
close(h)
% --------------------------------------------------------------------
function file_m_Callback(hObject, eventdata, handles)

function Untitled_2_Callback(hObject, eventdata, handles)

function cnm_m_Callback(hObject, eventdata, handles)
MergeG

function filter_m_Callback(hObject, eventdata, handles)
FilterG

function x_corr_m_Callback(hObject, eventdata, handles)
XcorrG

function stack_m_Callback(hObject, eventdata, handles)

function disperion_m_Callback(hObject, eventdata, handles)
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
    

function save_m_Callback(hObject, eventdata, handles)
folder_name=uigetdir(pwd,'Select directory to save');
Tablist=handles.Tablist;
All_dat=handles.All_dat;
tab_n=handles.tab_n;
cd(folder_name)
h=waitbar(0,'Saving file...');
for n=1:length(tab_n)
    A={};
    B={};
    s_data=All_dat.(tab_n{n});
    s_data=struct2cell(s_data);
    for m=1:length(s_data)
        data(:,m)=s_data{m};
    end
    n_data=sum(data,2);
    tab_nx=strsplit(tab_n{n},'_');tab_nx{1}='S';
    tab_n3=strjoin(tab_nx,'_');
    s_name=[tab_n3 '.mat'];
    A=Tablist.(tab_n{n});
    B=A(1,1:2);
    B(1,3:7)=A(1,4:8);
    inf_dat=B;
    save(s_name,'n_data','inf_dat')
    P=length(tab_n);
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
    
function hide_b_Callback(hObject, eventdata, handles)
set(handles.uitable1,'position',[50 2.77 118.4 30])
Xpos1=get(handles.pop1,'position');
Xpos2=get(handles.stack_b,'position');
Xpos3=get(handles.auto_p,'position');
Xpos4=get(handles.text5,'position');
set(handles.pop1,'position',[(Xpos1(1)-49) Xpos1(2:4)])
set(handles.stack_b,'position',[(Xpos2(1)-49) Xpos2(2:4)])
set(handles.auto_p,'position',[(Xpos3(1)-49) Xpos3(2:4)])
set(handles.text5,'position',[53 Xpos4(2:4)])
tab_pos=get(handles.uitable1,'position');
set(handles.uitable1,'position',[53 tab_pos(2) 118.4 tab_pos(4)])
handles.showc_b=uicontrol('parent',gcf,'units','characters', ...
    'position',[53 0.54 24 1.7],'style','pushbutton', ...
    'string','Show coordinates>>','foregroundcolor','b');
set([handles.hide_b handles.uitable2 handles.text4],'visible','off')
guidata(handles.showc_b,handles)
set(handles.showc_b,'callback',{@show_files,hObject,eventdata,handles})
% 
    function show_files(varargin)
        hObject=varargin{3};
        handles=varargin{5};
        set([handles.hide_b handles.uitable2 handles.text4],'visible','on')
        set(handles.uitable1,'position',handles.posx1)
        delete(handles.showc_b)
        Xpos1=get(handles.pop1,'position');
        Xpos2=get(handles.stack_b,'position');
        Xpos3=get(handles.auto_p,'position');
        Xpos4=get(handles.text5,'position');

        set(handles.pop1,'position',[(Xpos1(1)+49) Xpos1(2:4)])
        set(handles.stack_b,'position',[(Xpos2(1)+49) Xpos2(2:4)])
        set(handles.auto_p,'position',[(Xpos3(1)+49) Xpos3(2:4)])
        set(handles.text5,'position',[102 Xpos4(2:4)])
        guidata(hObject,handles)

function map_b_Callback(hObject, eventdata, handles)
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
%Creating network---------------------------------------------------------%
Lp=0;
for nn=1:(size(coor,1)-1)
    Lp=Lp+(nn);
end
LL=size(coor,1);
q=1;
q1=1;
q2=0;
for k=1:Lp
    q2=q2+1;
	if q2==(LL) & size(coor,1)~=2
        q1=q1+1;
        q2=1;
        LL=LL-1;
    else
    end    
    v1(q:(q+1))=[coor{q1,2} coor{(q1+q2),2}];
    v2(q:(q+1))=[coor{q1,3} coor{(q1+q2),3}];
    q=q+3;
v1(end+1)=NaN(1);
v2(end+1)=NaN(1);
end
my=mean(cell2mat(coor(:,2)));
mx=mean(cell2mat(coor(:,3)));
webmap('World Topographic Map','WrapAround',false)
wmcenter(my,mx)
wmline(v1,v2, 'Width', 0.5, 'FeatureName', 'network')
for n=1:size(coor,1)
    h2 = wmmarker(coor{n,2},coor{n,3},'FeatureName',coor{n,1});
end

% general framework for simulating navigation in a feature (i.e. sensory
% cue) based environment
% Components:
% 1. environment definition
% 3. environment update rule
% 2. agent definition
% 4. agent-environment update rule
% 4-2. agent learning rule (optional)
% rng(0)
setnavpath

% 1. define and initialize sensory environment
env_generate_nn

%% load initial agent params
clc
nvparams10620
rsd = rand(1,4);
mpr.win = rsd/sum(rsd)*35; mpr.win(1:2) = 0;
w_in = mpr.win;
w_h = w_in
lrt = 1; % learning rate
rt_h = []; nd_h = [];
%
avr = 0;
while 1
    fsin = []; ntr = [];rtr = [];
    for ti = 1:10
    % 2. define and initialize navigation agent
    ss_in = nan(size(w_in));
    loc0 = [(rand-.5)*cpm.xrn (rand-.5)*cpm.yrn];
    agent_generate_lr
    
    % 3. iteratively simulate agent and environment interactions
    run_nav_update_lr

    fsin = [fsin;ss_in];
    ntr = [ntr navt]
    rtr = [rtr rwd];
    end
    
    % update input weights
    fsm = nanmean(fsin);
    ndm = nanmedian(ntr);
    learn_update_a
    
    nd_h = [nd_h;ntr];
    rt_h = [rt_h;rtr];
    w_h = [w_h;w_in];
    
    dwh = diff(w_h,[],1);
    ddi = max(1,(size(dwh,1)-3));
    dwe = dwh(ddi:end,:);
    if mean(abs(dwe(:)))<.02
        break
    end
end
rtm = cal_matmean(rt_h,2,1);
ndm = cal_matmean(nd_h,2,1);
figure(39);clf; hold all
yyaxis left; plot_bci([],rtm.ci,rtm.mean,'b','b','')
yyaxis right; plot_bci([],ndm.ci,ndm.mean,'r','r','')

% yyaxis left; matsct([],rt_h,[],'b')
% yyaxis right; matsct([],nd_h,[],'r')
%% test learned weights
% w_in = w_h(end,:);
loc0 = [(rand-.5)*xrn (rand-.5)*yrn];
% loc0 = [300 500];
agent_generate_lr
run_nav_update_lr
[length(st_h) sum(st_h) rwd]

ea_visualizer
drawnow limitrate
%% 5. save navigation data if needed
reply = input('Save navmodel data?','s');
if ~isempty(reply)
    clear agt
    % compile agent data
    agt.mod = mpr;
    agt.nn_h = mout.nnh;
    agt.loc_h = loc_h;
    agt.ang_h = ang_h;
    agt.st_h = st_h;
    
    formatOut = 'ddhhmm';%'mmddyyhh';
    dstr = datestr(now,formatOut);
    savname = ['navmod' dstr];
    if isempty(dir(savname))
        save([dtpath savname],'envfile','cpm','agt')
        savfigr(plpath,savname)
    else
        save([dtpath savname '_2'],'envfile','cpm','agt')
        savfig(plpath,[savname '_2'])
    end
end



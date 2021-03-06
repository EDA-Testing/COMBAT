function ret = mcmc_conn(obj)
%MCMC_CONN 此处显示有关此函数的摘要
%   此处显示详细说明
%obj
obj.hobj.new_ss
tmp = obj.hobj.if_cond_gen_blk{1};

oblk = tmp{1, 'fullname'};
oblk = cell2mat(oblk);

sr = tmp{1, 'sigRange'};
sr = sr{1};

oport = 1 : numel(sr);
try
    Sample = get_param([obj.hobj.parent '/' oblk], 'SampleTime');
catch
    Sample = '1';
end
if strcmp(Sample,'-1')
    sample_time_DTC = '1';
elseif strcmp(Sample,'1')
    sample_time_DTC = '-1';
elseif strcmp(Sample,'0.1')
    sample_time_DTC = '1';
else
    sample_time_DTC = '1';
end
[DTC,DTC_h]=obj.mutant.add_new_block_in_model(obj.hobj.parent, 'simulink/Discrete/Delay');
[Sink,sink_h]=obj.mutant.add_new_block_in_model(obj.hobj.parent, 'simulink/Sinks/Display');
set_param([obj.hobj.parent '/' DTC],'SampleTime',sample_time_DTC);
[DTC_1,DTC_1_h]=obj.mutant.add_new_block_in_model(obj.hobj.parent, 'simulink/Discrete/Delay');
set_param([obj.hobj.parent '/' DTC_1],'SampleTime',sample_time_DTC);
try
    obj.mutant.add_conn(obj.hobj.parent, oblk, oport, DTC, 1);
catch
    obj.l.info('未知错误');
    ret = false;
end
obj.mutant.add_conn(obj.hobj.parent,DTC,1,obj.hobj.new_ss, 1);
obj.mutant.add_conn(obj.hobj.parent,obj.hobj.new_ss, 1,DTC_1,1);
% obj.mutant.add_conn(obj.hobj.parent,DTC, 1,Sink, 1);
% obj.r.live_blocks;
% add_blk = obj.r.live_blocks.fullname;
% for i=1:size(obj.r.live_blocks,1)
%     obj.r.live_blocks.fullname(i);
%     A=cell2mat(obj.r.live_blocks.fullname(i));
%     a=strsplit(A,'/');
%     if size(a,2)>1||~strcmp(obj.r.live_blocks.blocktype{i},'SubSystem')
%         add_blk(i)={1};
%     end
% end
% add_blk=add_blk(cellfun(@(p)~isequal(p,1),add_blk));
% blk_count = size(add_blk,1);
% slect_count = ceil(blk_count*rand());
% try
%     filter_input = get_param([obj.hobj.parent '/' add_blk{slect_count}],'PortHandles').Inport;
%     ports = size(filter_input,2);
%     f = ports+1;
%     add_block("simulink/Sources/In1",[obj.hobj.parent '/' add_blk{slect_count} '/' 'input1']);
%     obj.mutant.add_conn(obj.hobj.parent,DTC, 1,add_blk{slect_count}, f);
% catch 
%     slect_count = ceil(blk_count*rand());
%     filter_input = get_param([obj.hobj.parent '/' add_blk{slect_count}],'PortHandles').Inport;
%     ports = size(filter_input,2);
%     f = ports+1;
%      add_block("simulink/Sources/In1",[obj.hobj.parent '/' add_blk{slect_count} '/' 'input1']);
% %  input = get_param([obj.hobj.parent '/' add_blk_final{slect_count}],'Ports');
% %     input(1) = f;
% %     set_param([obj.hobj.parent '/' add_blk_final{slect_count}],'Ports',input);
%     obj.mutant.add_conn(obj.hobj.parent,DTC, 1,add_blk{slect_count}, f);
% end
%% add new subsystem

% [new_sys,new_sys_h] = obj.mutant.add_new_block_in_model(obj.hobj.parent, "simulink/Ports & Subsystems/Subsystem");
% [suorce,suorce_h] = obj.mutant.add_new_block_in_model([obj.hobj.parent '/' new_sys], "simulink/Sources/In1");
% [out,out_h] = obj.mutant.add_new_block_in_model([obj.hobj.parent '/' new_sys], "simulink/Sinks/Out1");
% %model2 = load('model_math.mat');
% model2 = load('model_ac.mat');
% model_mcmc = model2.modelmath;
% %            model_mcmc_add = {};
% %            obj.mutant.add_new_block_in_model([obj.hobj.parent '/' obj.hobj.new_ss], "simulink/Discontinuities/Hit Crossing")
% mcmcsize = ceil(40*rand());
% for i = 1:mcmcsize
%     model_mcmc_add{i,1} = obj.mutant.add_new_block_in_model([obj.hobj.parent '/' new_sys], convertCharsToStrings(model_mcmc{ceil(20*rand())}));
% end
% for j = 1:mcmcsize-1
%     obj.mutant.add_conn([obj.hobj.parent '/' new_sys], model_mcmc_add{j}, 1, model_mcmc_add{j+1}, 1);
% end
% model_source_pp = load('model_source.mat');
% model_source =  model_source_pp.modelsource;
% model_source_size = ceil(15*rand());
% [mcmc_suorce,mcmc_suorce_h] = obj.mutant.add_new_block_in_model([obj.hobj.parent '/' new_sys], convertCharsToStrings(model_source{model_source_size}));
% obj.mutant.add_conn([obj.hobj.parent '/' new_sys],mcmc_suorce, 1, model_mcmc_add{1}, 1);
% obj.mutant.add_conn([obj.hobj.parent '/' new_sys], model_mcmc_add{mcmcsize}, 1, out, 1);
%% connect new_sys and DTC

% obj.mutant.add_conn(obj.hobj.parent, DTC, 1, new_sys, 1);
% obj.mutant.add_conn(obj.hobj.parent, new_sys, 1, Sink, 1);
obj.mutant.add_conn(obj.hobj.parent, DTC, 1, Sink, 1);
ret = true;
end


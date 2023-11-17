%% MVO优化narx神经网络
clear
clc
% Error_test=100
% while Error_test>0.054
% clearvars -except Error_test
Universes_no=30;
Max_iteration=200;
lb=[1 1 1];
ub=[5 5 10];
dim=3;
[Best_score,Best_pos,cg_curve]=MVO(Universes_no,Max_iteration,lb,ub,dim);
subplot(1,1,1);
semilogy(cg_curve,'Color','r')
title('Convergence curve')
xlabel('Iteration');
ylabel('Best score obtained so far');

load MVO_NARX1.mat
[narx_c,input_testStatei,layer_testStatei] = ...
    closeloop(narx,input_trainStatef,layer_trainStatef);
[output_test,input_testStatef,layer_testStatef] = ...
    narx_c(Input_test,input_testStatei,layer_testStatei);
Error_test = mse(Target_test,output_test);

% end

 %% 
% clc
% clear
% W=xlsread('输入1.xlsx')
% Input=W(1:105,7:9);
% Target=W(1:105,6);
% sizetest = size(Input);
% for i = 1:sizetest(1)
%     PreInput(i).test = Input(i,:)';
% end
% Input = struct2cell(PreInput');
% Target = num2cell(Target');
% N_train = 75;             % 训练数据个数
% N_test  = 105; 
% %% 划分数据集
% Input_train  = Input(1:N_train);        % 将input数据集中前2000个数据作为训练数据——输入
% Input_test   = Input(N_train+1:N_test);   % 将input数据集中第3001个数据到第4001个数据作为测试数据——输入
% Target_train = Target(1:N_train);       % 同上，训练数据——输出
% Target_test  = Target(N_train+1:N_test);  % 同上，测试数据——输出
% save 输入8.mat
%%  5000r数据预处理
% W=xlsread('输入.xlsx')
% Input_train=W(:,2:4);
% Target_train=W(:,1);
% % 数据预处理（将数据转化为narx神经网络可以使用的数据形式）
% sizetest = size(Input_train);
% for i = 1:sizetest(1)
%     PreInput(i).test = Input_train(i,:)';
% end
% Input_train = struct2cell(PreInput');
% Target_train = num2cell(Target_train');
% X = xlsread('输入1.xlsx')
% Input_test = X(:,1:3);
% Target_test = X(:,4);
% sizetest1 = size(Input_test);
% for i =1:sizetest1(1)
%     PreInput1(i).test = Input_test(i,:)';
% end
% Input_test = struct2cell(PreInput1');
% Target_test = num2cell(Target_test');
% save 输入3.mat
% save 输入2.mat
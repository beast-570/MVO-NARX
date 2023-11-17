function fitness = error_test(Parent)
%% 读取数据
% clc 
% clear
% W=xlsread('输入.xlsx')
% Input=W(:,2:4);
% Target=W(:,1);
inputDelays=Parent(1);
feedbackDelays=Parent(2);
hiddenSize=Parent(3);

load 输入8.mat

%% 数据预处理（将数据转化为narx神经网络可以使用的数据形式）
% sizetest = size(Input);
% for i = 1:sizetest(1)
%     PreInput(i).test = Input(i,:)';
% end
% Input = struct2cell(PreInput');
% Target = num2cell(Target');
% N_train = 65;             % 训练数据个数
% N_val   = 85;             % 验证数据个数
% N_test  = length(Target); 
% %% 划分数据集
% Input_train  = Input(1:N_train);        % 将input数据集中前2000个数据作为训练数据——输入
% Input_val    = Input(N_train+1:N_val);  % 将input数据集中第2001个数据到第3000个数据作为验证数据——输入
% Input_test   = Input(N_val+1:N_test);   % 将input数据集中第3001个数据到第4001个数据作为测试数据——输入
% Target_train = Target(1:N_train);       % 同上，训练数据——输出
% Target_val   = Target(N_train+1:N_val); % 同上，验证数据——输出
% Target_test  = Target(N_val+1:N_test);  % 同上，测试数据——输出
%%
% 创建一个开环的NARX神经网络，其中的'open'可以省略，默认自动生成开环结构
narx = narxnet(1:round(inputDelays),1:round(feedbackDelays),round(hiddenSize),'open');
% % 训练NRAX神经网络
% 在训练NARX之前需要对数据进行处理，这里采用MATLAB自带的preparets函数
[input_train,input_trainStatei,layer_trainStatei,target_train] = ...
    preparets(narx,Input_train,{},Target_train);
% [Xs,Xi,Ai,Ts]=preparets(net,X,{},T)
narx = train(narx,input_train,target_train,input_trainStatei,layer_trainStatei);
% net=train(net,Xs,Ts,Xi,Ai)
[output_train,input_trainStatef,layer_trainStatef] = ...
    narx(input_train,input_trainStatei,layer_trainStatei);
% [Y,Xf,Af]=net(Xs,Xi,Ai)
Error_train = mse(target_train,output_train);   % 训练误差
save MVO_NARX1.mat
% % 将开环的NARX转化为闭环
[narx_c,input_testStatei,layer_testStatei] = ...
    closeloop(narx,input_trainStatef,layer_trainStatef);
[output_test,input_testStatef,layer_testStatef] = ...
    narx_c(Input_test,input_testStatei,layer_testStatei);
Error_test = mse(Target_test,output_test);
% % 验证NARX神经网络
% [output_val,input_valStatef,layer_valStatef] = ...
%     narx_c(Input_val,input_valStatei,layer_valStatei);
% Error_val = mse(Target_val,output_val);         % 验证误差
% save 闭环网络1.mat
% save 闭环网络3.mat
% % 测试NARX神经网络
% output_test = narx_c(Input_test,input_valStatef,layer_valStatef);
% Error_test = mse(Target_test,output_test);     % 测试误差.
fitness = Error_test;
plot(cell2mat(output_test),'-o','Color',[0.9098 0.0667 0.0588],'MarkerFaceColor',[0.9098 0.0667 0.0588],'Linewidth',0.6);    hold on
plot(cell2mat(Target_test),'-d','Color',[0.1059 0.4157 0.6471],'MarkerFaceColor',[0.1059 0.4157 0.6471],'Linewidth',0.6);
legend('Measured value','Predicted value','location','NorthWest');
xlabel('Predicting samples');
ylabel('Displacement(μm)')
%% 平均绝对误差MAE
% MAE = mean(abs(cell2mat(Target_test) - cell2mat(output_test)))
% RMSE = sqrt(mean((cell2mat(output_test)-cell2mat(Target_test)).^2));
% mvo = mvo_narx(1,:)-mvo_narx(2,:)
% GA = cell2mat(Target_test)-cell2mat(output_test)
% plot(PSO,'-hred'); hold on
% legend('PSO-NARX')
% xlabel('Predicting samples')
% ylabel('Residual error(μm)')
% % plot(narx,'-*black')
% ylim([-2,2])
end

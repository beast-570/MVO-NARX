function fitness = error_test(Parent)
%% ��ȡ����
% clc 
% clear
% W=xlsread('����.xlsx')
% Input=W(:,2:4);
% Target=W(:,1);
inputDelays=Parent(1);
feedbackDelays=Parent(2);
hiddenSize=Parent(3);

load ����8.mat

%% ����Ԥ����������ת��Ϊnarx���������ʹ�õ�������ʽ��
% sizetest = size(Input);
% for i = 1:sizetest(1)
%     PreInput(i).test = Input(i,:)';
% end
% Input = struct2cell(PreInput');
% Target = num2cell(Target');
% N_train = 65;             % ѵ�����ݸ���
% N_val   = 85;             % ��֤���ݸ���
% N_test  = length(Target); 
% %% �������ݼ�
% Input_train  = Input(1:N_train);        % ��input���ݼ���ǰ2000��������Ϊѵ�����ݡ�������
% Input_val    = Input(N_train+1:N_val);  % ��input���ݼ��е�2001�����ݵ���3000��������Ϊ��֤���ݡ�������
% Input_test   = Input(N_val+1:N_test);   % ��input���ݼ��е�3001�����ݵ���4001��������Ϊ�������ݡ�������
% Target_train = Target(1:N_train);       % ͬ�ϣ�ѵ�����ݡ������
% Target_val   = Target(N_train+1:N_val); % ͬ�ϣ���֤���ݡ������
% Target_test  = Target(N_val+1:N_test);  % ͬ�ϣ��������ݡ������
%%
% ����һ��������NARX�����磬���е�'open'����ʡ�ԣ�Ĭ���Զ����ɿ����ṹ
narx = narxnet(1:round(inputDelays),1:round(feedbackDelays),round(hiddenSize),'open');
% % ѵ��NRAX������
% ��ѵ��NARX֮ǰ��Ҫ�����ݽ��д����������MATLAB�Դ���preparets����
[input_train,input_trainStatei,layer_trainStatei,target_train] = ...
    preparets(narx,Input_train,{},Target_train);
% [Xs,Xi,Ai,Ts]=preparets(net,X,{},T)
narx = train(narx,input_train,target_train,input_trainStatei,layer_trainStatei);
% net=train(net,Xs,Ts,Xi,Ai)
[output_train,input_trainStatef,layer_trainStatef] = ...
    narx(input_train,input_trainStatei,layer_trainStatei);
% [Y,Xf,Af]=net(Xs,Xi,Ai)
Error_train = mse(target_train,output_train);   % ѵ�����
save MVO_NARX1.mat
% % ��������NARXת��Ϊ�ջ�
[narx_c,input_testStatei,layer_testStatei] = ...
    closeloop(narx,input_trainStatef,layer_trainStatef);
[output_test,input_testStatef,layer_testStatef] = ...
    narx_c(Input_test,input_testStatei,layer_testStatei);
Error_test = mse(Target_test,output_test);
% % ��֤NARX������
% [output_val,input_valStatef,layer_valStatef] = ...
%     narx_c(Input_val,input_valStatei,layer_valStatei);
% Error_val = mse(Target_val,output_val);         % ��֤���
% save �ջ�����1.mat
% save �ջ�����3.mat
% % ����NARX������
% output_test = narx_c(Input_test,input_valStatef,layer_valStatef);
% Error_test = mse(Target_test,output_test);     % �������.
fitness = Error_test;
plot(cell2mat(output_test),'-o','Color',[0.9098 0.0667 0.0588],'MarkerFaceColor',[0.9098 0.0667 0.0588],'Linewidth',0.6);    hold on
plot(cell2mat(Target_test),'-d','Color',[0.1059 0.4157 0.6471],'MarkerFaceColor',[0.1059 0.4157 0.6471],'Linewidth',0.6);
legend('Measured value','Predicted value','location','NorthWest');
xlabel('Predicting samples');
ylabel('Displacement(��m)')
%% ƽ���������MAE
% MAE = mean(abs(cell2mat(Target_test) - cell2mat(output_test)))
% RMSE = sqrt(mean((cell2mat(output_test)-cell2mat(Target_test)).^2));
% mvo = mvo_narx(1,:)-mvo_narx(2,:)
% GA = cell2mat(Target_test)-cell2mat(output_test)
% plot(PSO,'-hred'); hold on
% legend('PSO-NARX')
% xlabel('Predicting samples')
% ylabel('Residual error(��m)')
% % plot(narx,'-*black')
% ylim([-2,2])
end

%%ʹ��SVM��Ϊ����������һ��ѡȡѵ�����Լ�
clear all;close all;clc;


alpha=26;
Zn=5;
Fn=Zn;
XYn=1;
%׼����ݣ����淶��ݸ�ʽ
%load 'D:\EM_Github\matlab\LBP-FOP\FOP\feature\CASME2\5_5\EVM_different_alpha\alpha14\LBP_FOP_block55_X1Y1Z4F4.mat';
%load 'D:\EM_Github\matlab\LBP-FOP\FOP\feature\CASME2\5_5\different_alpha\no_evm\LBP_FOP_block55_X1Y1Z8F8.mat'
%feature_path='D:\EM_Github\matlab\LBP-FOP\FOP\feature\CASME2\5_5\different_alpha\no_tim\alpha26\wujiaocha_LBP_FOP_block55_X1Y1Z6F6.mat';
%feature_path='D:\EM_Github\matlab\LBP-FOP\FOP\feature\CASME2\5_5\different_alpha_right_tz_order\5_5\no_evm\FGLBP_block55_X1Y1Z5F5XY1.mat';
feature_path=['.\feature\alpha',num2str(alpha),'\FGLBP_block55_X1Y1Z',num2str(Zn),'F',num2str(Fn),'XY',num2str(XYn),'.mat'];
%feature_path=['D:\EM_Github\matlab\LBP-FOP\FOP\feature\CASME2\5_5\different_alpha_right_tz_order\5_5\no_evm\FGLBP_block55_X1Y1Z',num2str(Zn),'F',num2str(Fn),'XY',num2str(XYn),'.mat'];

load (feature_path)





load '.\CASME2_label.mat';

%feature(1475*3+1:end,:)=[];
%feature(1475*1+1:1475*3,:)=[];
size(feature)
feature(:,248)=[];

feature(:,229)=[];
feature(:,225)=[];
feature(:,224)=[];

feature(:,194)=[];
feature(:,171)=[];
feature(:,170)=[];
feature(:,93)=[];
feature(:,81)=[];

label(224)=[];
label(220)=[];
label(219)=[];
%feature=select_feature2(feature,label,0.0000001);
feature = feature';
size(label)
size(feature)
xlsfile='.\CASME2-coding-20190701_246test.xlsx'
[~,subject]=xlsread(xlsfile,1,'A2:A248');
Subject_number=tabulate(subject);
N=length(Subject_number);
result_datas=[];
index_begin=1;

d=0
    for c =0.35
        
        
      

            index_begin=1;
            rate = 0;
            F1=0;
            for i = 1:N
                index_end=index_begin+cell2mat(Subject_number(i,2))-1;
    
                train_feature_a=feature(1:index_begin-1,:);
                train_feature_b=feature(index_end+1:end,:);
                train_label_a=label(1:index_begin-1);
                train_label_b=label(index_end+1:end);    
  %  size(train_feature_a)
   % size(train_feature_b)
                train_feature=cat(1,train_feature_a,train_feature_b);
    
                train_label=cat(1,train_label_a,train_label_b);
                if i ==1
                    train_feature=feature(index_end+1:end,:);
                    train_label=label(index_end+1:end);
                end
                if i==N
                    train_feature=feature(1:index_begin-1,:);
                    train_label=label(1:index_begin-1);
                end

    
        
   % train_feature = feature(train,:);
    %train_label = label(train);
    %���Լ�
   % test_feature = feature(test,:);
    %test_label = label(test);
                test_feature=feature(index_begin:index_end,:);
                test_label=label(index_begin:index_end);

    %svmģ��
                size(train_label);
                size(train_feature);
                cmd=generator_para(c);
    %cmd=['-s 0 -t 1 -d 2-c 2 -g 1.4'];
                model = svmtrain(train_label,train_feature,cmd);
    %��֤���?
                [predicted_label, accuracy, prob_estimates] = svmpredict(test_label, test_feature, model, 'b');
                %[A,~] = confusionmat(test_label,predicted_label, test_feature);
                
                rate = rate + accuracy(1);

                index_begin=index_end+1;
            end
            rate = rate/(N*100)
            
            result_data=[cmd,'-acc' ,num2str(rate,'%.6f')];
            result_datas=[result_datas;result_data];
        end

result_datas



fs=100e6;
% 滤波器参数
lowpass_num=[-0.000148487009174339,-0.000207592141342220,-0.000343332639181425,-0.000527950245819245,-0.000769034954813781,-0.00107294825020376,-0.00144410511785232,-0.00188427380736064,-0.00239176688190762,-0.00296068114858685,-0.00358020059154691,-0.00423425841809692,-0.00490112728195982,-0.00555337210566580,-0.00615804379519772,-0.00667728130439033,-0.00706915340108873,-0.00728860253771280,-0.00728908009787788,-0.00702432619431167,-0.00645009917392650,-0.00552618169437109,-0.00421872380417272,-0.00250198734114009,-0.000360255667000829,0.00221012653065130,0.00520020327271374,0.00858674794811448,0.0123324986689238,0.0163859903256302,0.0206824912025500,0.0251452230993617,0.0296872708120844,0.0342140097514942,0.0386258079177014,0.0428212223950214,0.0467001401835523,0.0501673407283212,0.0531355772674840,0.0555287672651871,0.0572847091437019,0.0583572046223329,0.0587178881604993,0.0583572046223329,0.0572847091437019,0.0555287672651871,0.0531355772674840,0.0501673407283212,0.0467001401835523,0.0428212223950214,0.0386258079177014,0.0342140097514942,0.0296872708120844,0.0251452230993617,0.0206824912025500,0.0163859903256302,0.0123324986689238,0.00858674794811448,0.00520020327271374,0.00221012653065130,-0.000360255667000829,-0.00250198734114009,-0.00421872380417272,-0.00552618169437109,-0.00645009917392650,-0.00702432619431167,-0.00728908009787788,-0.00728860253771280,-0.00706915340108873,-0.00667728130439033,-0.00615804379519772,-0.00555337210566580,-0.00490112728195982,-0.00423425841809692,-0.00358020059154691,-0.00296068114858685,-0.00239176688190762,-0.00188427380736064,-0.00144410511785232,-0.00107294825020376,-0.000769034954813781,-0.000527950245819245,-0.000343332639181425,-0.000207592141342220,-0.000148487009174339];
bandpass_Num=[0.00135636719699521,0.00209514634800672,0.00293629674639312,0.00323202789681209,0.00266540004869025,0.00119209904285051,-0.000887215620035785,-0.00301963803339111,-0.00463587520711638,-0.00542177541352284,-0.00548137549161791,-0.00527957042799919,-0.00535407120553497,-0.00592567413597648,-0.00662228085885741,-0.00650917974256977,-0.00448969339086862,5.74604542744832e-05,0.00671748711041402,0.0138859707230599,0.0192146415490252,0.0205758460530610,0.0171450682457291,0.0100806359473261,0.00233910493866534,-0.00245403441996640,-0.00172257422932891,0.00449405791618826,0.0129312538207709,0.0179463185561184,0.0137155885865647,-0.00297792260069524,-0.0305340844753492,-0.0620005503802850,-0.0867376505801054,-0.0939255086831824,-0.0767228070744115,-0.0354711447553450,0.0214343425181376,0.0795730672930372,0.122879788503027,0.138878840809953,0.122879788503027,0.0795730672930372,0.0214343425181376,-0.0354711447553450,-0.0767228070744115,-0.0939255086831824,-0.0867376505801054,-0.0620005503802850,-0.0305340844753492,-0.00297792260069524,0.0137155885865647,0.0179463185561184,0.0129312538207709,0.00449405791618826,-0.00172257422932891,-0.00245403441996640,0.00233910493866534,0.0100806359473261,0.0171450682457291,0.0205758460530610,0.0192146415490252,0.0138859707230599,0.00671748711041402,5.74604542744832e-05,-0.00448969339086862,-0.00650917974256977,-0.00662228085885741,-0.00592567413597648,-0.00535407120553497,-0.00527957042799919,-0.00548137549161791,-0.00542177541352284,-0.00463587520711638,-0.00301963803339111,-0.000887215620035785,0.00119209904285051,0.00266540004869025,0.00323202789681209,0.00293629674639312,0.00209514634800672,0.00135636719699521];
s_100_lowpass = conv(s_100,lowpass_num);
s_100_lowpass=s_100_lowpass(fix(length(lowpass_num)/2-0.5)+1:length(s_100)+fix(length(lowpass_num)/2-0.5));
s_100_lowpass_8 = resample(s_100,339,2500);
s_100_lowpass_8=s_100_lowpass_8';
%以上进行下下采样操作，把采样频率变成的信号16倍左右,算法移植忽略上述操作
%%

% 系统参数
fs=fs*339/2500;%采样频率
fo=13.56e6/16;%副载波频率
L_sim=16;%用于计算归SNR
bit_fs_cont = 8;
threshold_snr = -5;
nnn=fix(fs/fo+0.5);%一次计算周期所需信号的步进点数
N1=L_sim*nnn;%标准副载波信号长度
N=0:N1-1;
P_N=(bit_fs_cont-1)*fix(fs/fo+0.5)-fix(fix(fs/fo+0.5)/2);%指示计算信号相位和能量的长度变量

subcarrier_temp=cos(2*pi*fo/fs*N)-sin(2*pi*fo/fs*N)*1j;%用于计算副载波信号相位和幅度信息

s_100_lowpass_8_bandpass = conv(s_100_lowpass_8,bandpass_Num);
s_100_lowpass_8_bandpass=s_100_lowpass_8_bandpass(fix(length(bandpass_Num)/2-0.5)+1:length(s_100_lowpass_8)+fix(length(bandpass_Num)/2-0.5));

%调试变量
tempdata=[0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,...
0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,1,0,1,1,1,0,1,1,0,0,0,0,0,0,1,0,0,...
0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,0,1,0,0,0,0,0,...
0,0,1,1,1,0,1,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0];
%%
s_TR1_sig = awgn(s_100_lowpass_8_bandpass,-5,'measured');%模拟不同的SNR的信号

%%
%寻找TR1
j=1;
snr_sy=zeros(fix(length(s_TR1_sig)/N1),N1+1);
TR1_index = length(s_TR1_sig);
for i=1:N1/2:length(s_TR1_sig)-N1
    
    snr_sy(j,2:end)=s_TR1_sig(i:i+N1-1);
    
    conv_s=sum(snr_sy(j,2:end).*subcarrier_temp);
    amp=abs(conv_s)/(N1/2);
    angel=angle(conv_s);
    signal_1 = amp*cos(2*pi*fo/fs*N+angel);
    
    Ps = amp^2*(N1/2);
    Pn = sum((snr_sy(j,2:end)-signal_1-mean(snr_sy(j,2:end))).^2);
    snr_sy(j,1)=10*log10(Ps/Pn);
    if j>5
        if(min(snr_sy(j-4:j,1))>threshold_snr)
            TR1_index = i+N1
            snr_sy=snr_sy(1:j,:);
            break;
        end
    end
    j=j+1;
end

%%
%获取SOF
j=1;
temp_ps_angle=zeros(fix(length(s_TR1_sig)/nnn),2);

%获取相位跳变的位置
sof_index = TR1_index;
for i=TR1_index:nnn:length(s_TR1_sig)-P_N
    
    singal=s_TR1_sig(i:i+P_N-1);
    
    conv_s=sum(singal.*subcarrier_temp(1:P_N));
    temp_ps_angle(j,1)=abs(conv_s);
    temp_ps_angle(j,2)=angle(conv_s);
    
    if j>8
        state_bool = get_state_inverters(temp_ps_angle(j-8:j,:));
        if state_bool==1
            sof_index = i;
            
            temp_ps_angle=temp_ps_angle(1:j,:);
            
            break
        end
    end
    j=j+1;
end

%%
%获取sof_bits:

sof_bits=zeros(12,3);
data_bits=zeros(fix(length(s_TR1_sig)/nnn),3);


if TR1_index<length(s_TR1_sig)-P_N
    
    last_bit_angle=[0, temp_ps_angle(end,2),0]; %初始化
    temp_index = sof_index;
    
    for i=1:12
        singal = s_TR1_sig(temp_index:temp_index+P_N-1);

        bit_angle = get_bit(singal,subcarrier_temp(1:P_N),last_bit_angle);
        last_bit_angle = bit_angle;
        sof_bits(i,:) = bit_angle;
        temp_index=temp_index+bit_fs_cont*nnn;
        if i==10
         temp_index=temp_index+bit_fs_cont*nnn;
        end
    end

    %获取相位跳变的位置
    j=1;
    temp_index = temp_index-(4+bit_fs_cont)*nnn;
    for i=temp_index:nnn:length(s_TR1_sig)-P_N

        singal=s_TR1_sig(i:i+P_N-1);

        conv_s=sum(singal.*subcarrier_temp(1:P_N));
        temp_ps_angle(j,1)=abs(conv_s);
        temp_ps_angle(j,2)=angle(conv_s);

        if j>8
            state_bool = get_state_inverters(temp_ps_angle(j-8:j,:));
            if state_bool==1
                sof_index = i;                
                break
            end
        end
        j=j+1;
    end

    %%
    %解调数据
    nj=1;
    stopflag = 1;
    while(stopflag)

        %start
        
        temp_index=sof_index;
        singal=s_TR1_sig(temp_index:temp_index+P_N-1);
        conv_s=sum(singal.*subcarrier_temp(1:P_N));
        last_bit_angle(1)=0;
        last_bit_angle(2)=angle(conv_s); 
        last_bit_angle(3)=abs(conv_s); 
        temp_index=temp_index+bit_fs_cont*nnn;
        data_bits(nj,:) = last_bit_angle;

        nj=nj+1;
        %data
        for i=1:9
            singal = s_TR1_sig(temp_index:temp_index+P_N-1);

            bit_angle = get_bit(singal,subcarrier_temp(1:P_N),last_bit_angle);      
            data_bits(nj,:) = bit_angle;            

            %判断是否为EOF
            if i==9
                if data_bits(nj,1) ==0 && sum(data_bits(nj-9:nj,1))==0
                    stopflag = 0;%为EOF，退出解调
                    data_bits=data_bits(1:nj,:);
                    break;
                end
            end

            last_bit_angle = bit_angle;
            nj=nj+1;
            temp_index=temp_index+bit_fs_cont*nnn;

        end

        %获取相位跳变的位置
        j=1;
        temp_index = temp_index-(3+bit_fs_cont)*nnn;
        for i=temp_index:nnn:length(s_TR1_sig)-P_N

            singal=s_TR1_sig(i:i+P_N-1);

            conv_s=sum(singal.*subcarrier_temp(1:P_N));
            temp_ps_angle(j,1)=abs(conv_s);
            temp_ps_angle(j,2)=angle(conv_s);

            if j>8
                state_bool = get_state_inverters(temp_ps_angle(j-8:j,:));
                if state_bool==1
                    sof_index = i;
                    break
                end
            end
            j=j+1;
        end    
    end
    
end


 

%调试
if nj==150 && sum(tempdata(13:end)'-data_bits(:,1))==0
    result='success'
else
    result='fail'
end

%%
%中间变量
test_bits=[sof_bits;data_bits];
%二进制数据转换为十进制数据，存储在hexdate变量中
 aa=[1,2,4,8,16,32,64,128]';
 binto8 = reshape(data_bits(:,1),10,[]);
 [asiz,bsize]=size(binto8);

 for i=1:1:bsize
      hexdate(i) = sum(aa.*binto8(2:9,i));
 end
test_hexdate = dec2hex(hexdate);







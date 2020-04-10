function bit_angle = get_bit(singal,subcarrier_temp,last_bit_angle)
%   get_bit 解调信号，获取bit信息
    if length(singal)~=length(subcarrier_temp)
        error('length(singal)~=length(IQ_complex)');
    end

    if isreal(subcarrier_temp)
        error('subcarrier_temp must be complex singal');
    end
    bit_angle(1) = last_bit_angle(1);
    conv_s=sum(singal.*subcarrier_temp);
    bit_angle(2) = angle(conv_s);
    bit_angle(3) = abs(conv_s);
    an = abs(bit_angle(2)-last_bit_angle(2));
     if an > pi
        an=2*pi-an;
     end
     
     if an>76/180*pi
       if(bit_angle(1)==0)
           bit_angle(1) = 1;
       else
           bit_angle(1)=0;
       end
     end

end


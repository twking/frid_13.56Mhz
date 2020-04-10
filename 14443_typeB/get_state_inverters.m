function state_bool = get_state_inverters( Ps_angle )
%get_state_inverters 获取相位是否跳变这个状态
%   state_bool=1时，相位发生逆转
%   state_bool=0时，相位没有发生逆转
state_bool = 0;
l = length(Ps_angle);
if mod(l,2) ~= 1
    error('error:mod(length(Ps_angle),2) ~= 1');
end

[Ps_min,min_index] = min(Ps_angle(:,1));%获取 Power of signal min value of index 

if(min_index==fix(l/2)+1) 
 an = abs(Ps_angle(end,2)-Ps_angle(1,2));
 if an > pi
    an=2*pi-an;
 end
 if an>99/180*pi
    state_bool = 1;
 end
 
end

end


function Fd = getFd(satpos,satvel,dempos,lambda)
%GETFD �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
range=norm(satpos-dempos);
Fd=2*satvel*(dempos-satpos)'/range/lambda;
end


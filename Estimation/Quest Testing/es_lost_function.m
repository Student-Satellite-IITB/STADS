function L = es_lost_function(b_m, m_r, v_a, q_bi)
%This function calculates the lost function for a given quaternion after
%converting it into the rotation matrix
%   input: (b,r,a,q)
%   output: L

%%
m_A = quat2rotm(q_bi');
L = 0;
v_p = size(b_m);
for i_rw=1 : v_p(1)
    L = 0.5 * v_a(i_rw) * norm(b_m(i_rw, :)' - m_A * m_r(i_rw, :)') ^ 2;
    
end
    
end


function J = mission_cost(x_scaled, scale, P)
%MISSION_COST Objective: departure dv plus a heavily weighted Saturn arrival v_inf.
%   The weight (1e4) makes the arrival hyperbolic excess speed, i.e. the
%   orbit-insertion cost, the dominant term.
m = evaluate_mission(x_scaled.*scale, P);
J = abs(m.x(1)) + 1e4*norm(m.v_inf_arr);
end

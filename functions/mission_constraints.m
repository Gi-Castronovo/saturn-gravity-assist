function [c, ceq] = mission_constraints(x_scaled, scale, P)
%MISSION_CONSTRAINTS Every arc must reach the orbit of the next planet (c <= 0).
%   Constraints are normalised by 1 AU. Unfeasible or failed evaluations
%   return a large violation so that the optimiser moves away from them.
ceq = [];
try
    m = evaluate_mission(x_scaled.*scale, P);
    if ~m.feasible || ~isreal(m.constraints)
        c = 10*ones(5, 1);
    else
        c = m.constraints/P.AU;
    end
catch
    c = 10*ones(5, 1);
end
end

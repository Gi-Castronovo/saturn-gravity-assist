function leg = transfer_arc(r0, v0, r1, mu)
%TRANSFER_ARC Heliocentric conic from a flyby at radius r0 to the orbit of radius r1 > r0.
%   v0 = [v_r, v_t] heliocentric velocity after the flyby [km/s].
%   Returns the conic elements, the true anomalies of departure and of the
%   first (outbound) crossing of r1, the arrival velocity [v_r, v_t] and the
%   aphelion radius (negative for hyperbolic arcs), used in the constraints.

v  = norm(v0);
a  = mu/(2*mu/r0 - v^2);                     % vis-viva (a < 0: hyperbola)
e  = sqrt(1 - (r0*v0(2))^2/(mu*a));          % from h^2 = mu*p
p  = a*(1 - e^2);

% True anomaly at departure, from the orbit equation and the radial velocity
nu_dep = atan2(v0(1)*sqrt(p/mu)/e, (p - r0)/(r0*e));

cos_nu = (p/r1 - 1)/e;
if abs(cos_nu) <= 1
    nu_arr = acos(cos_nu);                   % outbound crossing (v_r > 0)
else
    nu_arr = 2*pi;                           % r1 not reached: flagged by the constraints
end

leg = struct('a', a, 'e', e, 'p', p, 'r_peri', a*(1 - e), 'r_apo', a*(1 + e), ...
             'nu_dep', nu_dep, 'nu_arr', nu_arr, ...
             'v_arr', sqrt(mu/p)*[e*sin(nu_arr), 1 + e*cos(nu_arr)]);
end

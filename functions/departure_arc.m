function leg = departure_arc(r0, dv, r1, mu)
%DEPARTURE_ARC Heliocentric arc after a tangential retrograde impulse on a circular orbit.
%   The spacecraft leaves the orbit of radius r0 with a tangential velocity
%   change dv < 0 (km/s, relative to the circular velocity of the planet, i.e.
%   the departure hyperbolic excess speed), so r0 becomes the APHELION of the
%   transfer ellipse. The arc ends at the first crossing of the inner orbit r1,
%   on the inbound branch (before perihelion).
%
%   leg: a, e, p, r_peri, r_apo, nu_dep, nu_arr [rad], v_arr = [v_r, v_t] [km/s]

v_aph = sqrt(mu/r0) + dv;
a     = -mu/(v_aph^2 - 2*mu/r0);             % vis-viva
r_per = 2*a - r0;
e     = (r0 - r_per)/(r0 + r_per);
p     = a*(1 - e^2);

cos_nu = (p/r1 - 1)/e;
if abs(cos_nu) <= 1
    nu_arr = 2*pi - acos(cos_nu);            % inbound crossing (v_r < 0)
else
    nu_arr = 2*pi;                           % r1 not reached: flagged by the constraints
end

leg = struct('a', a, 'e', e, 'p', p, 'r_peri', r_per, 'r_apo', r0, ...
             'nu_dep', pi, 'nu_arr', nu_arr, ...
             'v_arr', sqrt(mu/p)*[e*sin(nu_arr), 1 + e*cos(nu_arr)]);
end

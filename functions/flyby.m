function fb = flyby(v_in, h_p, planet, v_planet)
%FLYBY Unpowered gravity assist in the patched-conics approximation.
%   v_in     : heliocentric velocity before the flyby, [v_r, v_t] [km/s]
%   h_p      : pericentre altitude [km]
%   planet   : struct with fields mu, radius (see PLANET_DATA)
%   v_planet : circular velocity of the planet, along the local horizontal [km/s]
%
%   The relative velocity v_inf is rotated by the turn angle
%   delta = 2*asin(1/e), with e = 1 + r_p*v_inf^2/mu. The side of the flyby
%   is chosen so that v_inf rotates towards the planet velocity, i.e. the
%   heliocentric energy always increases.
%
%   fb: v_out [v_r, v_t], v_inf_in, v_inf_out (vectors), v_inf (magnitude),
%       e, turn [deg], r_p, dv = |v_out| - |v_in|

v_inf_in = [v_in(1), v_in(2) - v_planet];   % relative velocity [radial, tangential]
v_inf    = norm(v_inf_in);
r_p      = planet.radius + h_p;

e     = 1 + r_p*v_inf^2/planet.mu;
turn  = 2*asind(1/e);

alpha_in = atan2d(v_inf_in(1), v_inf_in(2)); % angle between v_inf and the planet velocity
alpha_out = alpha_in - sign(alpha_in)*turn;  % rotate towards the planet velocity
if alpha_in == 0, alpha_out = -turn; end

v_inf_out = v_inf*[sind(alpha_out), cosd(alpha_out)];
v_out     = v_inf_out + [0, v_planet];

fb = struct('v_in', v_in, 'v_out', v_out, 'v_inf_in', v_inf_in, 'v_inf_out', v_inf_out, ...
            'v_inf', v_inf, 'e', e, 'turn', turn, 'r_p', r_p, 'h_p', h_p, ...
            'v_planet', v_planet, 'dv', norm(v_out) - norm(v_in));
end

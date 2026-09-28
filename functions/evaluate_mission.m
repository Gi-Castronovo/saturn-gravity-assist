function m = evaluate_mission(x, P)
%EVALUATE_MISSION Propagates the Earth-Venus-Earth-Mars-Jupiter-Saturn sequence.
%   x = [dv_dep, h_venus, h_earth, h_mars, h_jupiter]   ([km/s], [km])
%   P = planet_data()
%
%   m.legs(k)      : heliocentric arcs, with orientation (omega) and time of flight
%   m.flybys(k)    : gravity assists at Venus, Earth, Mars and Jupiter
%   m.constraints  : leg 1: r_peri - r_venus; legs 2-5: r_target - r_apo  (<= 0 to reach the target)
%   m.v_inf_arr    : hyperbolic excess velocity at Saturn [v_r, v_t]
%   m.feasible     : true if the last arc reaches the orbit of Saturn

mu  = P.mu_sun;
seq = {'earth', 'venus', 'earth', 'mars', 'jupiter', 'saturn'};
h   = x(2:5);

% Leg 1: Earth -> Venus. The Earth is at phi = 0, the ellipse aphelion.
leg = departure_arc(P.earth.r_orbit, x(1), P.venus.r_orbit, mu);
leg.omega = -pi;                                  % phi = omega + nu, and nu = pi at the Earth
legs = add_leg(leg, 'earth', 'venus', mu);
m.constraints = zeros(5, 1);
m.constraints(1) = leg.r_peri - P.venus.r_orbit;

phi = leg.omega + leg.nu_arr;                     % heliocentric longitude of the encounter
v   = leg.v_arr;
flybys = [];

for k = 2:5
    body   = P.(seq{k});
    target = P.(seq{k+1});

    fb = flyby(v, h(k-1), body, sqrt(mu/body.r_orbit));
    fb.planet = seq{k};
    fb.phi    = phi;
    flybys = [flybys, fb]; %#ok<AGROW>

    leg = transfer_arc(body.r_orbit, fb.v_out, target.r_orbit, mu);
    leg.omega = phi - leg.nu_dep;                 % orientation of the new conic
    legs = [legs, add_leg(leg, seq{k}, seq{k+1}, mu)]; %#ok<AGROW>
    m.constraints(k) = target.r_orbit - leg.r_apo;

    phi = leg.omega + leg.nu_arr;
    v   = leg.v_arr;
end

m.x         = x;
m.legs      = legs;
m.flybys    = flybys;
m.v_arr     = v;
m.v_inf_arr = [v(1), v(2) - sqrt(mu/P.saturn.r_orbit)];
m.feasible  = m.constraints(end) <= 0;
m.tof_total = sum([legs.tof]);
end

function leg = add_leg(leg, from, to, mu)
leg.from = from;
leg.to   = to;
leg.tof  = time_of_flight(leg.a, leg.e, leg.nu_dep, leg.nu_arr, mu);
end

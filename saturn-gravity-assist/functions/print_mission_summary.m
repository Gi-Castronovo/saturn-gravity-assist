function print_mission_summary(m)
%PRINT_MISSION_SUMMARY Command-window report of the optimised trajectory.
names = @(s) [upper(s(1)) s(2:end)];

fprintf('\n=== Design variables ===\n');
fprintf('Departure v_inf (tangential, retrograde): %.4f km/s\n', m.x(1));
for k = 1:numel(m.flybys)
    fprintf('Pericentre altitude %-8s: %12.1f km\n', names(m.flybys(k).planet), m.flybys(k).h_p);
end

fprintf('\n=== Gravity assists ===\n');
fprintf('%-8s %10s %10s %8s %10s %10s\n', 'Planet', 'r_p [km]', 'v_inf', 'e', 'turn [deg]', 'dv [km/s]');
for k = 1:numel(m.flybys)
    f = m.flybys(k);
    fprintf('%-8s %10.0f %10.3f %8.3f %10.2f %10.3f\n', names(f.planet), f.r_p, f.v_inf, f.e, f.turn, f.dv);
end

fprintf('\n=== Heliocentric arcs ===\n');
fprintf('%-18s %12s %8s %12s\n', 'Arc', 'a [km]', 'e', 'TOF [days]');
for k = 1:numel(m.legs)
    L = m.legs(k);
    fprintf('%-18s %12.4e %8.4f %12.2f\n', [names(L.from) ' -> ' names(L.to)], L.a, L.e, L.tof/86400);
end
fprintf('Total time of flight: %.2f days (%.2f years)\n', m.tof_total/86400, m.tof_total/86400/365.25);

fprintf('\n=== Arrival at Saturn ===\n');
fprintf('Heliocentric velocity: v_r = %.4f km/s, v_t = %.4f km/s\n', m.v_arr);
fprintf('Hyperbolic excess speed: %.4f km/s\n', norm(m.v_inf_arr));
end

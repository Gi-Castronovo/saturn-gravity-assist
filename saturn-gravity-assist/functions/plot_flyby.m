function fig = plot_flyby(fb, planet)
%PLOT_FLYBY Velocity triangle and planet-centred hyperbola of a gravity assist.
%   Axes: x = local radial direction, y = local horizontal (planet velocity).
%   The pericentre lies opposite to the velocity change v_inf_out - v_inf_in
%   (the gravitational pull), which fixes the geometry without special cases.

name = [upper(fb.planet(1)) fb.planet(2:end)];
fig  = figure('Name', ['Flyby ' name]);
tiledlayout(1, 2, 'TileSpacing', 'compact');

% --- Velocity triangle -------------------------------------------------
nexttile; hold on; grid on; axis equal;
vp = [0, fb.v_planet];
quiver(0, 0, vp(1), vp(2), 0, 'Color', [.6 .6 .6], 'LineWidth', 2, 'DisplayName', 'V_{planet}');
quiver(vp(1), vp(2), fb.v_inf_in(1),  fb.v_inf_in(2),  0, 'c--', 'LineWidth', 1.5, 'DisplayName', 'v_\infty^-');
quiver(vp(1), vp(2), fb.v_inf_out(1), fb.v_inf_out(2), 0, 'r--', 'LineWidth', 1.5, 'DisplayName', 'v_\infty^+');
quiver(0, 0, fb.v_in(1),  fb.v_in(2),  0, 'c', 'LineWidth', 2, 'DisplayName', 'V^- (heliocentric)');
quiver(0, 0, fb.v_out(1), fb.v_out(2), 0, 'r', 'LineWidth', 2, 'DisplayName', 'V^+ (heliocentric)');
xlabel('radial velocity [km/s]'); ylabel('tangential velocity [km/s]');
title(sprintf('%s: turn %.1f^\\circ, \\DeltaV = %.2f km/s', name, fb.turn, fb.dv));
legend('Location', 'best');

% --- Planet-centred hyperbola -------------------------------------------
nexttile; hold on; grid on; axis equal;
u_in  = fb.v_inf_in/norm(fb.v_inf_in);
u_out = fb.v_inf_out/norm(fb.v_inf_out);
r_hat = (u_in - u_out)/norm(u_in - u_out);       % pericentre direction
v_hat = (u_in + u_out)/norm(u_in + u_out);       % velocity direction at pericentre

nu_inf = acos(-1/fb.e);                          % true anomaly of the asymptotes
nu = linspace(-0.97*nu_inf, 0.97*nu_inf, 400);
p  = fb.r_p*(1 + fb.e);
r  = p./(1 + fb.e*cos(nu));
xy = r'.*cos(nu') * r_hat + r'.*sin(nu') * v_hat;
xy = xy(r' < 25*fb.r_p, :);                      % keep the part close to the planet

th = linspace(0, 2*pi, 200);
fill(planet.radius*cos(th), planet.radius*sin(th), [.75 .75 .75], 'EdgeColor', 'k', 'DisplayName', name);
plot(xy(:,1), xy(:,2), 'b', 'LineWidth', 2, 'DisplayName', 'Hyperbolic trajectory');
plot(fb.r_p*r_hat(1), fb.r_p*r_hat(2), 'ko', 'MarkerFaceColor', 'y', 'DisplayName', 'Pericentre');
xlabel('radial [km]'); ylabel('along-track [km]');
title(sprintf('r_p = %.0f km, e = %.3f', fb.r_p, fb.e));
legend('Location', 'best');
end

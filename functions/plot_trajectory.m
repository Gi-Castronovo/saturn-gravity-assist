function fig = plot_trajectory(m, P)
%PLOT_TRAJECTORY Heliocentric view of the whole sequence (Sun-centred, x-y plane).

names  = {'venus', 'earth', 'mars', 'jupiter', 'saturn'};
colors = [1 .5 0; 0 .45 .9; .85 .2 .1; .1 .6 .2; .6 .4 .2];
leg_colors = lines(numel(m.legs));

fig = figure('Name', 'Heliocentric trajectory');
hold on; grid on; axis equal;

alpha = linspace(0, 2*pi, 720);
for k = 1:numel(names)
    r = P.(names{k}).r_orbit;
    plot(r*cos(alpha), r*sin(alpha), 'Color', colors(k,:), 'LineWidth', 1, ...
         'DisplayName', [upper(names{k}(1)) names{k}(2:end) ' orbit']);
end
plot(0, 0, 'o', 'MarkerFaceColor', [1 .85 0], 'MarkerEdgeColor', 'k', 'MarkerSize', 9, 'DisplayName', 'Sun');

for k = 1:numel(m.legs)
    L  = m.legs(k);
    nu = linspace(L.nu_dep, L.nu_arr + 2*pi*(L.nu_arr < L.nu_dep), 600);
    r  = L.p ./ (1 + L.e*cos(nu));
    plot(r.*cos(nu + L.omega), r.*sin(nu + L.omega), 'Color', leg_colors(k,:), 'LineWidth', 2, ...
         'DisplayName', sprintf('%s \\rightarrow %s (%.0f d)', cap(L.from), cap(L.to), L.tof/86400));
    plot(r(end)*cos(nu(end) + L.omega), r(end)*sin(nu(end) + L.omega), 'kd', ...
         'MarkerFaceColor', leg_colors(k,:), 'HandleVisibility', 'off');
end
plot(P.earth.r_orbit, 0, 's', 'Color', [.6 .6 .6], 'MarkerFaceColor', [.6 .6 .6], 'DisplayName', 'Departure');

xlabel('x [km]'); ylabel('y [km]');
title(sprintf('E-V-E-M-J-S gravity-assist trajectory (%.1f years)', m.tof_total/86400/365.25));
legend('Location', 'eastoutside');
end

function s = cap(s)
s = [upper(s(1)) s(2:end)];
end

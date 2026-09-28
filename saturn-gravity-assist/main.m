%% MULTI-GRAVITY-ASSIST TRANSFER TO SATURN (patched conics)
% Interplanetary phase of a mission to Enceladus: Earth -> Venus -> Earth ->
% Mars -> Jupiter -> Saturn with unpowered gravity assists.
%
% Model: circular coplanar planetary orbits, patched conics, impulsive
% tangential departure from the Earth's orbit (at the aphelion of the first
% arc), planets assumed to be at the encounter point (no phasing).
%
% Design variables: departure v_inf and the four flyby pericentre altitudes.
% Objective: departure dv + 1e4 * arrival v_inf at Saturn (fmincon, SQP),
% subject to every arc reaching the orbit of the next planet.
%
% Author: Girolamo Castronovo - Sapienza University of Rome, A.Y. 2025/26

clear; clc; close all;
addpath('functions');

SAVE_FIGURES = false;          % true -> export PNGs to /figures
P = planet_data();

%% Design variables: [dv_dep (km/s), h_venus, h_earth, h_mars, h_jupiter (km)]
x0    = [-5,    600,  400,  200,  5e6];
lb    = [-10,   500,  300,  100,  1.5e5];
ub    = [-0.1, 1500, 5000, 5000,  5e6];
scale = [10,   1000, 1000, 1000,  1e7];    % brings every variable close to 1

options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter', ...
    'MaxFunctionEvaluations', 3000, 'StepTolerance', 1e-8, ...
    'ConstraintTolerance', 1e-4, 'OptimalityTolerance', 1e-4);

[x_opt, J_opt] = fmincon(@(x) mission_cost(x, scale, P), x0./scale, [], [], [], [], ...
                         lb./scale, ub./scale, @(x) mission_constraints(x, scale, P), options);
x_opt = x_opt.*scale;
fprintf('\nOptimum (full precision): [%.10g, %.10g, %.10g, %.10g, %.10g]\n', x_opt);

%% Results
m = evaluate_mission(x_opt, P);
print_mission_summary(m);

fig = plot_trajectory(m, P);
save_figure(fig, 'trajectory', SAVE_FIGURES);
for k = 1:numel(m.flybys)
    fig = plot_flyby(m.flybys(k), P.(m.flybys(k).planet));
    save_figure(fig, ['flyby_' m.flybys(k).planet], SAVE_FIGURES);
end

%% ===================== Local functions =====================
function save_figure(fig, name, save_flag)
if save_flag
    if ~exist('figures', 'dir'), mkdir('figures'); end
    ax = findobj(fig, 'Type', 'axes');
    for k = 1:numel(ax), ax(k).Toolbar.Visible = 'off'; end   % keep the axes toolbar out of the PNG
    drawnow;
    exportgraphics(fig, fullfile('figures', [name '.png']), 'Resolution', 200);
end
end

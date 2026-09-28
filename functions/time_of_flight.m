function t = time_of_flight(a, e, nu0, nu1, mu)
%TIME_OF_FLIGHT Time to move from true anomaly nu0 to nu1 (forward in time) on a conic.

if e < 1
    M = @(nu) kepler_ellipse(nu, e);
    n = sqrt(mu/a^3);
    t = mod(M(nu1) - M(nu0), 2*pi)/n;
else
    M = @(nu) kepler_hyperbola(nu, e);
    n = sqrt(mu/(-a)^3);
    t = (M(nu1) - M(nu0))/n;
end
end

function M = kepler_ellipse(nu, e)
E = 2*atan(sqrt((1 - e)/(1 + e))*tan(nu/2));
M = E - e*sin(E);
end

function M = kepler_hyperbola(nu, e)
F = 2*atanh(sqrt((e - 1)/(e + 1))*tan(nu/2));
M = e*sinh(F) - F;
end

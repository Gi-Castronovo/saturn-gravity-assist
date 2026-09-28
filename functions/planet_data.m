function P = planet_data()
%PLANET_DATA Physical and orbital data used by the patched-conics model.
%   Planetary orbits are modelled as circular and coplanar.
%   P.mu_sun              : gravitational parameter of the Sun [km^3/s^2]
%   P.(name).mu           : gravitational parameter of the planet [km^3/s^2]
%   P.(name).r_orbit      : radius of the (circular) heliocentric orbit [km]
%   P.(name).radius       : mean radius of the planet [km]

P.mu_sun = 1.32712440018e11;
P.AU     = 149.6e6;

P.venus   = struct('mu', 3.24859e5,     'r_orbit', 108e6,          'radius', 6051.8);
P.earth   = struct('mu', 3.986004418e5, 'r_orbit', 149597870.707,  'radius', 6371);
P.mars    = struct('mu', 4.2828e4,      'r_orbit', 228e6,          'radius', 3389.5);
P.jupiter = struct('mu', 1.27e8,        'r_orbit', 778e6,          'radius', 71492);
P.saturn  = struct('mu', 3.79e7,        'r_orbit', 1426725400,     'radius', 58232);
end

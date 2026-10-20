function [lon2,lat2] = local_wgs84_fwd(lon1,lat1,az_deg,s_km)
% LOCAL_WGS84_FWD  WGS84 Vincenty direct geodesic
% lon1,lat1 : origin longitude/latitude in degrees
% az_deg    : clockwise from North in degrees
% s_km      : distance in km

a = 6378137.0;
f = 1/298.257223563;
b = (1-f)*a;

lon1 = deg2rad(lon1);
lat1 = deg2rad(lat1);
alpha1 = deg2rad(az_deg);
s = s_km*1000;

sinAlpha1 = sin(alpha1);
cosAlpha1 = cos(alpha1);

tanU1 = (1-f).*tan(lat1);
cosU1 = 1./sqrt(1+tanU1.^2);
sinU1 = tanU1.*cosU1;

sigma1 = atan2(tanU1,cosAlpha1);
sinAlpha = cosU1.*sinAlpha1;
cosSqAlpha = 1-sinAlpha.^2;
uSq = cosSqAlpha.*(a^2-b^2)/(b^2);

A = 1 + uSq/16384 .* ...
    (4096 + uSq.*(-768 + uSq.*(320-175*uSq)));

B = uSq/1024 .* ...
    (256 + uSq.*(-128 + uSq.*(74-47*uSq)));

sigma = s./(b*A);

for iter = 1:100
    cos2SigmaM = cos(2*sigma1 + sigma);
    sinSigma = sin(sigma);
    cosSigma = cos(sigma);

    deltaSigma = B.*sinSigma .* ...
        (cos2SigmaM + B/4 .* ...
        (cosSigma.*(-1+2*cos2SigmaM.^2) - ...
        B/6.*cos2SigmaM.* ...
        (-3+4*sinSigma.^2).* ...
        (-3+4*cos2SigmaM.^2)));

    sigma_new = s./(b*A) + deltaSigma;

    if max(abs(sigma_new-sigma)) < 1e-12
        sigma = sigma_new;
        break;
    end

    sigma = sigma_new;
end

cos2SigmaM = cos(2*sigma1 + sigma);
sinSigma = sin(sigma);
cosSigma = cos(sigma);

tmp = sinU1.*sinSigma - cosU1.*cosSigma.*cosAlpha1;

lat2 = atan2(...
    sinU1.*cosSigma + ...
    cosU1.*sinSigma.*cosAlpha1, ...
    (1-f).*sqrt(sinAlpha.^2 + tmp.^2));

lambda = atan2(...
    sinSigma.*sinAlpha1, ...
    cosU1.*cosSigma - sinU1.*sinSigma.*cosAlpha1);

C = f/16.*cosSqAlpha.*(4+f.*(4-3*cosSqAlpha));

L = lambda - ...
    (1-C).*f.*sinAlpha .* ...
    (sigma + C.*sinSigma.* ...
    (cos2SigmaM + C.*cosSigma.* ...
    (-1+2*cos2SigmaM.^2)));

lon2 = lon1 + L;

lon2 = rad2deg(lon2);
lat2 = rad2deg(lat2);

lon2(lon2 > 180) = lon2(lon2 > 180)-360;
lon2(lon2 < -180) = lon2(lon2 < -180)+360;
end

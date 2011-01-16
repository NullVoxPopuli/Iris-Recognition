% calculate point on circle with given radius, center point and angle (rads)
function [retX, retY] = ptOnCircle(centerX, centerY, radius, theta)
    retX = int16(centerX + radius*cos(theta));
    retY = int16(centerY + radius*sin(theta));
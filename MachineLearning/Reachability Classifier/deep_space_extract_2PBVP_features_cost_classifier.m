function feature_matrix = deep_space_extract_2PBVP_features_cost_classifier...
( stateMat1, stateMat2 )
    
    x_1         = stateMat1(:,1);
    y_1         = stateMat1(:,2);
    z_1         = stateMat1(:,3);
    xdot_1      = stateMat1(:,4);
    ydot_1      = stateMat1(:,5);
    zdot_1      = stateMat1(:,6);
    
    x_2         = stateMat2(:,1);
    y_2         = stateMat2(:,2);
    z_2         = stateMat2(:,3);
    xdot_2      = stateMat2(:,4);
    ydot_2      = stateMat2(:,5);
    zdot_2      = stateMat2(:,6);
    
    delta_x     = x_2 - x_1;
    delta_y     = y_2 - y_1;
    delta_z     = z_2 - z_1;
    delta_xdot  = xdot_2 - xdot_1;
    delta_ydot  = ydot_2 - ydot_1;
    delta_zdot  = zdot_2 - zdot_1;
    
    theta = acos(dot([xdot_1, ydot_1, zdot_1],[xdot_2, ydot_2, zdot_2],2)./(sqrt(xdot_1.^2 + ydot_1.^2 + zdot_1.^2).*sqrt(xdot_2.^2 + ydot_2.^2 + zdot_2.^2)));
    
    feature_matrix = [ ...
       
        x_1, ...
        y_1, ...
        z_1, ...
        xdot_1, ...
        ydot_1, ...
        zdot_1, ...
        x_2, ...
        y_2, ...
        z_2, ...
        xdot_2, ...
        ydot_2, ...
        zdot_2, ...
        xdot_1.^2 + ydot_1.^2 + zdot_1.^2, ...
        xdot_2.^2 + ydot_2.^2 + zdot_2.^2, ...
        sqrt(xdot_1.^2 + ydot_1.^2 + zdot_1.^2), ...
        sqrt(xdot_2.^2 + ydot_2.^2 + zdot_2.^2), ...
        sqrt(delta_x.^2 + delta_y.^2 + delta_z.^2), ...
%         theta, ...
%         theta./sqrt(xdot_1.^2 + ydot_1.^2 + zdot_1.^2), ...
%         theta./sqrt(xdot_2.^2 + ydot_2.^2 + zdot_2.^2), ...
%         sqrt(delta_x.^2 + delta_y.^2 + delta_z.^2) ./ (sqrt(xdot_2.^2 + ydot_2.^2 + zdot_2.^2)-sqrt(xdot_1.^2 + ydot_1.^2 + zdot_1.^2)), ...
%         theta./sqrt(delta_x.^2 + delta_y.^2 + delta_z.^2), ...
%         theta./sqrt(xdot_1.^2 + ydot_1.^2 + zdot_1.^2), ...
%         theta./sqrt(xdot_2.^2 + ydot_2.^2 + zdot_2.^2), ...
%         sqrt(delta_x.^2 + delta_y.^2 + delta_z.^2) ./ (sqrt(xdot_2.^2 + ydot_2.^2 + zdot_2.^2)-sqrt(xdot_1.^2 + ydot_1.^2 + zdot_1.^2)), ...
%         ...
%         delta_x, ...
%         delta_y, ...
%         delta_z, ...
%         delta_xdot, ...
%         delta_ydot, ...
%         delta_zdot, ...
%         ...
%         x_1, ...
%         y_1, ...
%         z_1, ...
%         xdot_1, ...
%         ydot_1, ...
%         zdot_1, ...
%         x_2, ...
%         y_2, ...
%         z_2, ...
%         xdot_2, ...
%         ydot_2, ...
%         zdot_2, ...
%         xdot_1.^2 + ydot_1.^2 + zdot_1.^2, ...
%         xdot_2.^2 + ydot_2.^2 + zdot_2.^2, ...
%         sqrt(xdot_1.^2 + ydot_1.^2 + zdot_1.^2), ...
%         sqrt(xdot_2.^2 + ydot_2.^2 + zdot_2.^2), ...
%         sqrt(delta_x.^2 + delta_y.^2 + delta_z.^2), ...
%         dot([xdot_1, ydot_1, zdot_1],[xdot_2, ydot_2, zdot_2],2),...
%         theta, ...
%         theta./sqrt(delta_x.^2 + delta_y.^2 + delta_z.^2), ...
%         theta./sqrt(xdot_1.^2 + ydot_1.^2 + zdot_1.^2),...
%         theta./sqrt(xdot_2.^2 + ydot_2.^2 + zdot_2.^2), ...
%         xdot_1./xdot_2, ...
%         ydot_1./ydot_2, ...
%         zdot_1./zdot_2, ...
%         xdot_2./xdot_1, ...
%         ydot_2./ydot_1, ...
%         zdot_2./zdot_1, ...
%         xdot_1.*sqrt(xdot_2.^2 + ydot_2.^2 + zdot_2.^2), ...
%         ydot_1.*sqrt(xdot_2.^2 + ydot_2.^2 + zdot_2.^2), ...
%         zdot_1.*sqrt(xdot_2.^2 + ydot_2.^2 + zdot_2.^2), ...
%         xdot_2.*sqrt(xdot_1.^2 + ydot_1.^2 + zdot_1.^2), ...
%         ydot_2.*sqrt(xdot_1.^2 + ydot_1.^2 + zdot_1.^2), ...
%         zdot_2.*sqrt(xdot_1.^2 + ydot_1.^2 + zdot_1.^2), ...
%         delta_x./delta_xdot, ...
%         delta_y./delta_ydot, ...
%         delta_z./delta_zdot, ...
%         1./(delta_x./delta_xdot), ...
%         1./(delta_y./delta_ydot), ...
%         1./(delta_z./delta_zdot), ...
%         sqrt(delta_x.^2 + delta_y.^2 + delta_z.^2) ./ (sqrt(xdot_2.^2 + ydot_2.^2 + zdot_2.^2)-sqrt(xdot_1.^2 + ydot_1.^2 + zdot_1.^2)), ...
%         ...
%         ...
%         ...
%         xdot_1.^2, ...
%         ydot_1.^2, ...
%         zdot_1.^2, ...
%         sqrt(xdot_1.^2 + ydot_1.^2 + zdot_1.^2), ...
%         xdot_2.^2, ...
%         ydot_2.^2, ...
%         zdot_2.^2, ...
%         sqrt(xdot_2.^2 + ydot_2.^2 + zdot_2.^2), ...
%         ...
%         ...
%         ...
%         sqrt(delta_x.^2 + delta_y.^2 + delta_z.^2), ...
%         ...
%         ...
%         ...
%         delta_x./delta_xdot, ...
%         delta_y./delta_ydot, ...
%         delta_z./delta_zdot, ...
%         sqrt(delta_x.^2 + delta_y.^2 + delta_z.^2) ./ (sqrt(xdot_2.^2 + ydot_2.^2 + zdot_2.^2)-sqrt(xdot_1.^2 + ydot_1.^2 + zdot_1.^2)), ...
%         ...
%         ...
%         ...
%         ...
%         ...
%         ...
%         x_1, ...
%         y_1, ...
%         z_1, ...
%         xdot_1, ...
%         ydot_1, ...
%         zdot_1, ...
%         x_1.^2, ...
%         y_1.^2, ...
%         z_1.^2, ...
%         xdot_1.^2, ...
%         ydot_1.^2, ...
%         zdot_1.^2, ...
%         abs(xdot_1), ...
%         abs(ydot_1), ...
%         abs(zdot_1), ...
%         sqrt(x_1.^2 + y_1.^2 + z_1.^2), ...
%         sqrt(xdot_1.^2 + ydot_1.^2 + zdot_1.^2), ...
%         sqrt(x_1.^2 + y_1.^2 + z_1.^2 + xdot_1.^2 + ydot_1.^2 + zdot_1.^2), ...
%         x_1./xdot_1, ...
%         y_1./ydot_1, ...
%         z_1./zdot_1, ...
%         (x_1./xdot_1).^2, ...
%         (y_1./ydot_1).^2, ...
%         (z_1./zdot_1).^2, ...
%         sqrt( (x_1./xdot_1).^2 + (y_1./ydot_1).^2 + (z_1./zdot_1).^2 ), ...
%         sqrt(x_1.^2 + y_1.^2 + z_1.^2) ./ sqrt(xdot_1.^2 + ydot_1.^2 + zdot_1.^2), ...
%         ...
%         ...
%         ...
%         x_2, ...
%         y_2, ...
%         z_2, ...
%         xdot_2, ...
%         ydot_2, ...
%         zdot_2, ...
%         x_2.^2, ...
%         y_2.^2, ...
%         z_2.^2, ...
%         xdot_2.^2, ...
%         ydot_2.^2, ...
%         zdot_2.^2, ...
%         abs(xdot_2), ...
%         abs(ydot_2), ...
%         abs(zdot_2), ...
%         sqrt(x_2.^2 + y_2.^2 + z_2.^2), ...
%         sqrt(xdot_2.^2 + ydot_2.^2 + zdot_2.^2), ...
%         sqrt(x_2.^2 + y_2.^2 + z_2.^2 + xdot_2.^2 + ydot_2.^2 + zdot_2.^2), ...
%         x_2./xdot_2, ...
%         y_2./ydot_2, ...
%         z_2./zdot_2, ...
%         (x_2./xdot_2).^2, ...
%         (y_2./ydot_2).^2, ...
%         (z_2./zdot_2).^2, ...
%         sqrt( (x_2./xdot_2).^2 + (y_2./ydot_2).^2 + (z_2./zdot_2).^2 ), ...
%         sqrt(x_2.^2 + y_2.^2 + z_2.^2) ./ sqrt(xdot_2.^2 + ydot_2.^2 + zdot_2.^2), ...
%         ...
%         ...
%         ...
%         delta_x, ...
%         delta_y, ...
%         delta_z, ...
%         delta_xdot, ...
%         delta_ydot, ...
%         delta_zdot, ...
%         delta_x.^2, ...
%         delta_y.^2, ...
%         delta_z.^2, ...
%         delta_xdot.^2, ...
%         delta_ydot.^2, ...
%         delta_zdot.^2, ...
%         abs(delta_xdot), ...
%         abs(delta_ydot), ...
%         abs(delta_zdot), ...
%         sqrt(delta_x.^2 + delta_y.^2 + delta_z.^2), ...
%         sqrt(delta_xdot.^2 + delta_ydot.^2 + delta_zdot.^2), ...
%         sqrt(delta_x.^2 + delta_y.^2 + delta_z.^2 + delta_xdot.^2 + delta_ydot.^2 + delta_zdot.^2), ...
%         delta_x./delta_xdot, ...
%         delta_y./delta_ydot, ...
%         delta_z./delta_zdot, ...
%         (delta_x./delta_xdot).^2, ...
%         (delta_y./delta_ydot).^2, ...
%         (delta_z./delta_zdot).^2, ...
%         sqrt( (delta_x./delta_xdot).^2 + (delta_y./delta_ydot).^2 + (delta_z./delta_zdot).^2 ), ...
%         sqrt(delta_x.^2 + delta_y.^2 + delta_z.^2) ./ sqrt(delta_xdot.^2 + delta_ydot.^2 + delta_zdot.^2), ...
%         ...
%         ...
%         ...
%         x_1.*x_2, ...
%         y_1.*y_2, ...
%         z_1.*z_2, ...
%         xdot_1.*xdot_2, ...
%         ydot_1.*ydot_2, ...
%         zdot_1.*zdot_2, ...
%         x_1.*y_1, ...
%         x_1.*z_1, ...
%         y_1.*z_1, ...
%         x_2.*y_2, ...
%         x_2.*z_2, ...
%         y_2.*z_2, ...
%         xdot_1.*ydot_1, ...
%         xdot_1.*zdot_1, ...
%         ydot_1.*zdot_1, ...
%         xdot_2.*ydot_2, ...
%         xdot_2.*zdot_2, ...
%         ydot_2.*zdot_2
    ];
end
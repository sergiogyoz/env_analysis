%%%% Simple script showing the polar visualization of a wave function in
%%%% the real domain (Single frequency)

%%%% Author: Annalisa Molini
%%%% Last modified: March 3, 2024

   %% Initialize
    clc;
    clear;
    close all;
    fsize=14;                    % Font size for plots

   %% Time Domain Parameters:
    Fs = 3;                      % Original signal frequency [Hz]
    StopTime = 4.5;              % Length of the sample [s]
    tstep=.01;                   % Time resolution [s]
    t = (0:tstep:StopTime)';     % Time vector [s]
   
   %% Cosine  Wave Generation:
    x = (cos(2*pi*Fs*t)+1)/2;    % Centered
    %x = (cos(2*pi*Fs*t));       % Non-centered

   %% Plot the Signal ersus Time:
    figure('Position', [50, 500, 1400, 350]); 
    tilen = tiledlayout(2,3,'TileSpacing','Compact','Padding','Compact');
    at3=nexttile(2,[1 2]);
    axis tight;

    plot(at3,t,x,'LineWidth',1.5);
    xlabel('time [seconds]');
    ylabel('signal [generic units]');
    set(at3, 'fontsize', fsize);

   %% Looping on the different 'winding frequencies'
   %%%% This is a simple polar transformation, itearating over different
   %%%% 'winding' frequencies


   StopTime = 10*2*pi;              % Length of the sample [s] {Set to have a longer sample - arbitrarily}
   Fstep=0.02;                      % Resolution in the frequency domain [Hz]
   Max_F=6;                         % Max winding frequency [Hz]
   Fs_w=(.1:Fstep:Max_F);           % Winding frequency vector [Hz]
   nfreq=size(Fs_w,2);              % # Winding frequencies in the loop
   x_coord_cm=nan(nfreq,1);
   for i=1:nfreq  
       Fs_rescaled = Fs/Fs_w(i); 
       t2 = (0:tstep:StopTime)';           % seconds, redefined just to have a onger sample
       x = (cos(Fs_rescaled*t2)+1)/2;      % centered case
       %x = (cos(Fs_rescaled*t2));         % non-centered case
       x_coord_cm(i)=mean(x.*(2*cos(t2))); % APPROXIMATE x coord of the center of mass (as the mean of the x coordinates) - centered case
       %x_coord_cm(i)=mean(x.*(cos(t2)));  % APPROXIMATE x coord of the center of mass (as the mean of the x coordinates) - non-centered case
       if Fs_rescaled ==1
           at1=nexttile(1,[2 1]);
           pp=polarplot(t2,x,'LineWidth',2,'Color', 'r');
           hold on
           polarplot(0,x_coord_cm(i),'.r','MarkerSize',25);
           hold off
               pax=gca;
               pax.ThetaAxisUnits = 'radians';
               set(pax, 'fontsize', fsize);
           text(450,1.6,['Fs_w=',num2str(Fs_w(i)),' Hz'],'Color','red','FontSize',14);
           pause();
           clf(pp);
       else 
           at1=nexttile(1,[2 1]);
           pp=polarplot(t2,x,'LineWidth',1.5);
           hold on
           polarplot(0,x_coord_cm(i),'.r','MarkerSize',25);
           hold off
               pax=gca;
               pax.ThetaAxisUnits = 'radians';
               set(pax, 'fontsize', fsize);
           text(450,1.6,['Fs_w=',num2str(Fs_w(i)),' Hz'],'Color','red','FontSize',14);
           pause(.2);
           clf(pp);
       end
       at2=nexttile(5,[1 2]);
       A=plot(at2,Fs_w,x_coord_cm,'r.','MarkerSize',6);
       xlim(at2,[0.1 6]);
       ylim(at2,[-0.6 0.6]);
       xlabel('Fs_{w} [Hz]');
       ylabel('x_{CM}');
       set(at2, 'fontsize', fsize);
       clf(A);
   end 

   

   

%%% Close figure window to stop execution


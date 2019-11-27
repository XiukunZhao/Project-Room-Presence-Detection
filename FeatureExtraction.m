function features  = FeatureExtraction(signal,samplingfrequency,windowsize, shift,uthreshold,lthreshold)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This function divide the signal into overlaping windows and  
%  extract the following 20 features from each of these windows:
%  01. Window Mean value 
%  02. Window coefficient of variation 
%  03. Variation 
%  04. Total number of peaks 
%  05. Max amplitude of positive peaks  
%  06. Max amplitude of negative peaks
%  07. Average of distances between two successive peaks 
%  08. Coefficient of variation of peak distances 
%  09. Average peak widths 
%  10. Coefficient of variation of peak widths 
%  15. Half Energy
%  16. Number of frequencies involved in half of Energy (p)
%  17. Maximum magnitude 
%  18. Frequency of maximum magnitude (in Hz)
%  19. Average distance between two successive frequencies (in Hz)
%  20. Coefficient of variation of frequency distances 
%  Input : 1 - signal :  the signal
%          2 - samplingfrequency : the signal sampling frequency
%          3 - windowsize : size of each window in sample point number
%          4 - shift : step size to move from one window to the next in sample point number
%          5 - uthreshold : upper limit to define peaks
%          6 - lthreshold : lower limit to define peaks
%  Output : WindowNumber x 20 features matrix 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deb = 1;                       % begining of a window 
fin = deb+windowsize;          % end of window 
tempdeb = 1;
tempfin = deb+windowsize;
s = size(signal);
sF  = samplingfrequency;
T = 1/sF;                       % Sampling period
p = 0.997;
windownumber = 0;
%% Counting the number of windows
while tempfin < s(1)
    tempdeb = tempdeb+shift;
    tempfin  = tempdeb+windowsize;
    windownumber = windownumber +  1;
end
features = zeros(windownumber,20);
index = 1;
while fin < s(1)
%% Define the window from the original signal.
    window = signal(deb:fin);
    untrendedsinganl = window-mean(window);
    %q = quantile(untrendedsinganl,p);
    %nq = quantile(-untrendedsinganl,p);
    q = uthreshold;
    nq = lthreshold;
    [~,locs,w,pro] = findpeaks(untrendedsinganl,'MINPEAKHEIGHT',q,'MinPeakDistance',sF);      % Minimum peaks hight +3sigma  Minimum distance between two peaks 1s
    [~,ilocs,iw,ipro] = findpeaks(-untrendedsinganl,'MINPEAKHEIGHT',nq,'MinPeakDistance',sF); % Minimum peaks hight -3sigma  Minimum distance between two peaks 1s
    L = length(window);                     
    t = (0:L-1)*T;
    fftY = fft(untrendedsinganl);
    E = 2*abs(fftY)/L;
    E = E(1:L/2).^2;                    %% take the power of positve freq. half
    P2 = abs(fftY/L);                   %% Double-Sided Spectrum
    P1 = P2(1:L/2+1);                   %% Amplitude of positive frequency 
    P1(2:end-1) = 2*P1(2:end-1);        %% Single-Sided Spectrum
    freq = sF*(0:(L/2))/L;              %% find the corresponding frequency in Hz
    energy  = sum(E);                 
    halfenergy  = 0;
    i  = 1;
    fq = quantile(P1(2:end-1),p);
    [~,flocs,fw,fpro] = findpeaks(P1,'MINPEAKHEIGHT',fq);    %frequency peaks 
    while halfenergy < energy / 2                            %half energy
        halfenergy  = halfenergy + E(i);
        i = i+1;
    end 
    halenergyfreq  = freq(i-1);
    deb = deb+shift;
    fin  = deb+windowsize;
    s11 = size(locs);
    s12 = size(ilocs);
%% Time Domain Feature 
    features(index,1) = mean(window);                                      %01. Window Mean value 
    features(index,2) = std(window)/mean(window);                          %02. Window cv 
    features(index,3) = mean(abs(diff(untrendedsinganl)));                 %03. Variation 
    features(index,4) = s11(1)+s12(1);                                     %04. Total number of peaks 
    peaklocs  = sort(t(cat(1,locs,ilocs)));
    spnl = size(peaklocs);
    disp(spnl);
    sp = size(locs);
    sn = size(ilocs);
    if sp(1) > 0  %check if the window has + peacks 
        features(index,5) = max(untrendedsinganl(locs));                   %05. Max amplitude of positive peaks  
    end
    if sn(1) > 0  %check if the window has - peacks 
        features(index,6) =  min(-untrendedsinganl(ilocs));                %06. Max amplitude of negative peaks 
    end
    if spnl(2) > 1 %check if the window has more than one peacks 
       features(index,7) = mean(diff(peaklocs));                           %07. Average of distances between two successive peaks 
       features(index,8) = std(diff(peaklocs))/mean(diff(peaklocs));       %08. Coefficient of variation of peak distances 
    end
    if sp(1) > 0 
        features(index,9) = mean(cat(1,w,iw));                             %09. Average of peak widths 
        features(index,10) = std(cat(1,w,iw))/mean(cat(1,w,iw));           %10. Coefficient of variation of peak widths 
        features(index,11) = (sum(untrendedsinganl(locs).^2)+sum(untrendedsinganl(ilocs).^2))/sum(untrendedsinganl.^2); %11. Frac of energy stored in peaks
    end
%% Frequency Domain Features
    features(index,15) = halenergyfreq;                                             %15. Half Energy
    features(index,16) = i-1;                                                       %16. Number of frequencies involved in half of Energy (p)
    sl = size(flocs);
    if sl(1) > 0
        features(index,17) = max(P1(flocs));                                        %17. Maximum magnitude 
        features(index,18) = freq(P1==max(P1(flocs)));                              %18. Frequency of maximum magnitude (in Hz)
        if sl(1) >1
            features(index,19) = mean(diff(freq(flocs)));                           %19. Average distance between two successive frequencies (in Hz)
            features(index,20) = std(diff(freq(flocs)))/mean(diff(freq(flocs)));    %20. Coefficient of variation of frequency distances 
        end
    index = index+1;
    end
end 

end 

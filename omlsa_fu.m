function [y_out_time,fs] = omlsa_fu(y_in_orig,fs0)

fs = 16e3;
y_in_time = resample(y_in_orig, fs, fs0);
data_length = size(y_in_time, 1);
frame_length = 512;
frame_move = 128;
frame_overlap = frame_length - frame_move;
N_eff = frame_length / 2 + 1;
loop_i = 1;
frame_in = zeros(frame_length, 1);
frame_out = zeros(frame_length, 1);
frame_result = zeros(frame_length, 1);
y_out_time = zeros(data_length, 1);

win = hamming(frame_length);

win2 = win .^ 2;
W0 = win2(1:frame_move);
for k = frame_move:frame_move:frame_length-1
    swin2 = lnshift(win2,k);
    W0 = W0 + swin2(1:frame_move);
end
W0 = mean(W0) ^ 0.5;
win = win / W0;
Cwin = sum(win.^2) ^ 0.5;
win = win / Cwin;

f_win_length = 1;
win_freq = hanning(2*f_win_length+1); 
win_freq = win_freq / sum(win_freq); 

alpha_eta = 0.92;
alpha_s = 0.9;
alpha_d = 0.85;
beta = 2;

eta_min = 0.0158;
GH0 = eta_min ^ 0.5;
gama0 = 4.6;
gama1 = 3;
zeta0 = 1.67;
Bmin = 1.66;
l_mod_lswitch = 0;
Vwin = 15;
Nwin = 8;

while(loop_i+frame_length<data_length)
    if(loop_i == 1)
        frame_in = y_in_time(1:frame_length);
    else
        frame_in = [frame_in(frame_move+1:end); y_in_time(loop_i:loop_i+frame_move-1)];
    end
    frame_out = [frame_out(frame_move+1:end); zeros(frame_move,1)];
    Y = fft(frame_in.*win);     
    Ya2 = abs(Y(1:N_eff)) .^ 2; 
    Sf = conv(win_freq, Ya2); 
    Sf = Sf(f_win_length+1:N_eff+f_win_length);  
    
    if(loop_i==1)  
        lambda_dav = Ya2; 
        lambda_d = Ya2; 
        gamma = 1;  
        Smin = Sf;  
        S = Sf;  
        St = Sf;  
        GH1 = 1; 
        Smint = Sf;  
        Smin_sw = Sf; 
        Smint_sw = Sf;
        eta_2term = GH1 .^ 2 .* gamma;
    end
    
    gamma = Ya2 ./ max(lambda_d, 1e-10);
    eta = alpha_eta * eta_2term + (1-alpha_eta) * max(gamma-1, 0);  
    eta = max(eta, eta_min);
    v = gamma .* eta ./ (1+eta);  
    GH1 = eta ./ (1+eta).*exp(0.5*expint(v));
    
    S = alpha_s * S + (1-alpha_s) * Sf;
    if(loop_i<(frame_length+14*frame_move))
        Smin = S;
        Smin_sw = S;
    else
        Smin = min(Smin, S);
        Smin_sw = min(Smin_sw, S);
    end
    
    
    gama_min = Ya2 / Bmin ./ Smin;
    zeta = S / Bmin ./ Smin;
    I_f = double(gama_min<gama0 & zeta<zeta0);
    conv_I = conv(win_freq, I_f); 
    conv_I = conv_I(f_win_length+1:N_eff+f_win_length);
        
    Sft = St;
    idx = find(conv_I); 
    if ~isempty(idx)
            conv_Y = conv(win_freq, I_f.*Ya2);  
            conv_Y = conv_Y(f_win_length+1:N_eff+f_win_length);
            Sft(idx) = conv_Y(idx) ./ conv_I(idx);
    end
    St=alpha_s*St+(1-alpha_s)*Sft;  
    
    if(loop_i<(frame_length+14*frame_move))
        Smint = St;
        Smint_sw = St;
    else
        Smint = min(Smint, St);
        Smint_sw = min(Smint_sw, St);
    end

    
    
    gamma_mint = Ya2 / Bmin ./ Smint;
    zetat = S / Bmin ./ Smint;
    qhat = ones(N_eff, 1); 
    phat = zeros(N_eff, 1);  

    idx = find(gamma_mint>1 & gamma_mint<gama1 & zetat<zeta0); 
    qhat(idx) = (gama1-gamma_mint(idx)) / (gama1-1);
    qhat(gamma_mint>=gama1 | zetat>=zeta0) = 0;
    phat = 1 ./ (1+qhat./(1-qhat).*(1+eta).*exp(-v)); 
    phat(gamma_mint>=gama1 | zetat>=zeta0) = 1;
    alpha_dt = alpha_d + (1-alpha_d) * phat; 
    lambda_dav = alpha_dt .* lambda_dav + (1-alpha_dt) .* Ya2;  
    lambda_d = lambda_dav * beta;
    
    
    if l_mod_lswitch==Vwin 
        l_mod_lswitch=0;
        if loop_i == Vwin * frame_move + 1 +frame_overlap;
            SW=repmat(S,1,Nwin);
            SWt=repmat(St,1,Nwin);
        else
            SW=[SW(:,2:Nwin) Smin_sw];       
            Smin=min(SW,[],2);     
            Smin_sw=S;    
            SWt=[SWt(:,2:Nwin) Smint_sw];
            Smint=min(SWt,[],2);
            Smint_sw=St;   
        end
    end
    l_mod_lswitch = l_mod_lswitch + 1;
    
    gamma = Ya2 ./ max(lambda_d, 1e-10);  
    eta = alpha_eta * eta_2term + (1-alpha_eta) * max(gamma-1, 0); 
    eta = max(eta, eta_min);
    v = gamma .* eta ./ (1+eta);  
    GH1 = eta ./ (1+eta).*exp(0.5*expint(v));
     
    G = GH1 .^ phat .* GH0 .^ (1-phat);
    eta_2term = GH1 .^ 2 .* gamma;  
    
    X = [zeros(3,1); G(4:N_eff-1) .* Y(4:N_eff-1); 0];
    X(N_eff+1:frame_length) = conj(X(N_eff-1:-1:2));  
    frame_result = Cwin^2*win.*real(ifft(X));
    
    frame_out = frame_out + frame_result;
    if(loop_i==1)
        y_out_time(loop_i:loop_i+frame_move-1) = frame_out(1:frame_move);
        loop_i = loop_i + frame_length;
    else
        y_out_time(loop_i-frame_overlap:loop_i+frame_move-1-frame_overlap) = frame_out(1:frame_move);
        loop_i = loop_i + frame_move;
    end
end
end
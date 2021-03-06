function pt = pulse_train(stimpars)

global hfig_nidaqsetup
global hfig_stimedit

% create series of pulses

if hfig_nidaqsetup.mode == 0;
    if hfig_stimedit.current_chan ==1
        srate = hfig_stimedit.ch1.stimsrate;
    else
        srate = hfig_stimedit.ch2.stimsrate;
    end
else
    srate = 44100;
end

freq = stimpars.freq;
pdur = stimpars.pdur;
ipi = stimpars.ipi;
ramp = stimpars.ramp;
pnum = stimpars.pnum;
revph = stimpars.revph;
noise = stimpars.noise;
chrpnum = stimpars.chrpnum;
ici = stimpars.ici;

if noise ==0
    
%Create ramp
    on = 0:(ramp * srate / 1000);
    ramp_length = length(on);
    on = sin(on/ramp_length * pi/2).^2; %raised sin half-cycle, "ramp" ms rise-time
    on = on(2:end);
    
    off = 0:round(ramp * srate / 1000);
    off = cos(off/ramp_length * pi/2).^2; %raised cos half-cycle, "ramp" ms fall-time
    off = off(2:end);
    
    ramp_length = length(on);
    
%Create tones
    tone = 0:round(pdur * srate / 1000);
    tone = sin(tone*2*pi* freq/srate);
    tone = tone(2:end);
    
    
%Apply ramps
    tone(1:ramp_length) = tone(1:ramp_length).* on;
    tone((length(tone)-(ramp_length-1)):end) = tone((length(tone)-(ramp_length-1)):end).* off;
    
    
    silence_pts = round(ipi * srate/1000);
    silence = [zeros(1,silence_pts)];
    pulse_int = [silence,tone];
    
    chirp = [];
    
    for i = 1:pnum
        chirp = [chirp, pulse_int];
    end
    
%Create song
    ici = ici - ipi;
    ici_pts = round(ici * srate/1000);
    lead_silence = [zeros(1, ici_pts)];
    ici_silence = [zeros(1, ici_pts), chirp];
    
    
    signal = [];
    
    for k = 1:chrpnum
        [signal] = [signal, ici_silence];
    end
    
    if chrpnum <2
        signal = [chirp, silence];
    else
        signal = [signal(length(lead_silence):end), lead_silence];
    end
    
    pt = signal;
else
    
    %Create ramp
    on = 0:round(ramp * srate / 1000);
    ramp_length = length(on);
    on = sin(on/ramp_length * pi/2).^2; %raised sin half-cycle, "ramp" ms rise-time
    
    off = 0:round(ramp * srate / 1000);
    off = cos(off/ramp_length * pi/2).^2; %raised cos half-cycle, "ramp" ms fall-time
    
    %Create noise
    noise_seq = round(pdur * srate / 1000);
    noise_seq = -1 + (1-(-1)).*rand(noise_seq+1,1);
    noise_seq = transpose(noise_seq);
    
    %Apply ramps
    noise_seq(1:ramp_length) = noise_seq(1:ramp_length).* on;
    noise_seq((length(noise_seq)-(ramp_length-1)):end) = noise_seq((length(noise_seq)-(ramp_length-1)):end).* off;
    
    
    silence_pts = round(ipi * srate/1000);
    silence = [zeros(1,silence_pts)];
    pulse_int = [zeros(1,silence_pts),noise_seq ];
    
    chirp = [];
    
    for i = 1:pnum
        chirp = [chirp, pulse_int];
    end
    
%Create song
    ici = ici - ipi;
    ici_pts = round(ici * srate/1000);
    lead_silence = [zeros(1, ici_pts)];
    ici_silence = [zeros(1, ici_pts), chirp];
    
    
    signal = [];
    
    for k = 1:chrpnum
        [signal] = [signal, ici_silence];
    end
    
    if chrpnum <2
        signal = [chirp, silence];
    else
        signal = [signal(length(lead_silence):end), lead_silence];
    end
    
    pt = signal;
end

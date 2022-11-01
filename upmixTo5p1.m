clear;

load angleMapper
load chmaskPtr5p1.mat
load('mask_test.mat')
load xy2mtb.mat

format long

global M_PI
global ANALYSIS_OVERLAP
global msr
global lr2
global chmaskPtr
global angleMapper
global TBL_SIZE
global analysisWnd
global synthesisWnd
global FFTSIZE
global MAX_OUTPUT_BUFFERS
global mode

mode = 5; % 5.1

M_PI = 3.14159265358979323846;

MAX_OUTPUT_BUFFERS = 2;
TBL_SIZE = 64;
FFTSIZE = 8192;
ANALYSIS_OVERLAP = 4;
msr.mBitRev = zeros(1,FFTSIZE);
msr.mOutputReadSampleOffset = 0;
msr.mOutputBufferCount = 0;
msr.mInputSub = zeros(2,FFTSIZE);
msr.mOutputBufferCount = 0;
msr.mInputPos = 0;
msr.magPhaseDiff2Cartesian = xy2mtb02;
msr.spread = M_PI /2.0;
msr.separation = 0.0;
msr.spatialEnhancement = 1.0;
msr.XYaxis = linspace(-1,1,TBL_SIZE);

msr.fs = 48000;
msr.fc = 70;

TBL_SIZE = 64;
msr.mInput = zeros(2,FFTSIZE);
msr.frameLen = 1536;%1536
msr.fftLen = 2048;
msr.timeDomainOut = zeros(7,FFTSIZE);
msr.ovpLen = msr.frameLen / ANALYSIS_OVERLAP;
msr.smpShift = msr.frameLen - 2*msr.ovpLen;
msr.mOutputBuffer = zeros(7,msr.ovpLen);
msr.mOverlapStage2dash = zeros(7,FFTSIZE / ANALYSIS_OVERLAP);
msr.halfLen = msr.fftLen/2 - 1;
msr.procUpTo = 24000/(msr.fs/msr.fftLen);
msr.freqDomainOut = zeros(5,msr.fftLen);
msr.mInputSamplesNeeded = msr.ovpLen;

[analysisWnd,synthesisWnd] = getAsymmetricWindow(msr.frameLen,msr.ovpLen,msr.smpShift);

% LUTSurroundRefreshParameter;

msr.smoothing = 0.1306122;
msr.mix = 0.17834;
msr.smoothedFunc = 0.5*ones(9,msr.fftLen/2+1);

msr.mTempLBuffer = zeros(1,FFTSIZE);
msr.mTempRBuffer = zeros(1,FFTSIZE);
LLbitReversalTbl(msr.fftLen);

lr2 = initLR2(msr.fs,max(40,msr.fc));
lr2.lp1_xm0 = 0;
lr2.lp2_xm0 = 0;
lr2.hp1_xm0 = 0;
lr2.hp2_xm0 = 0;
lr2.lp1_xm1 = 0;
lr2.lp2_xm1 = 0;
lr2.hp1_xm1 = 0;
lr2.hp2_xm1 = 0;

crossRat = 0.8;
msr.crossBass = max(0,min(crossRat,1));
msr.minuscrossBass = 1- msr.crossBass;

% filename = 'test09.wav';%ÎÄ¼þÃû
% [x, fs] = audioread(strcat(filename));
% x = x(1:fs*3,:);
% msr.fs = fs;
msr.timeDomainOut = zeros(60500,5);
msr.timeDomainOut_right = zeros(5,FFTSIZE);

msr.old = zeros(msr.ovpLen,5);

% xl = x(:, 1); % left
% xr = x(:, 2); % right
xl = SineStereo(:,1);
xr = SineStereo(:,2);
% xr = SineStereo(1:128*29,2);

% xl = 1:128*29;
% xl = zeros(128*29,1);
% xl(1:200:end) = 0:199;
% xl = 2*ones(60500,1);
% xr = ones(60500,1);
% [lpl,lpr,hpl,hpr] = time_domain_filter(xl,xr);
% crossFilt = crossoverFilter(...
%     'NumCrossovers',1,...
%     'CrossoverFrequencies',400,...
%     'CrossoverSlopes',48,...
%     'SampleRate',48000);
% % noise = randn(size(xl));
% [lpl,hpl] = crossFilt(xl);
% [lpr,hpr] = crossFilt(xr);
totalPCMFrameCount = length(xl);
frameCountProvided = 128;
readcount = ceil(totalPCMFrameCount/frameCountProvided);
wave_final = zeros(totalPCMFrameCount,mode+1);
pointerOffset = 0;
for i = 0:readcount-2 
    pointerOffset = frameCountProvided * i;
    inputs0 = xl(pointerOffset+1:pointerOffset+frameCountProvided);
    inputs1 = xr(pointerOffset+1:pointerOffset+frameCountProvided);
    offset = 0;
   
    while (offset<frameCountProvided)
        processing = min(frameCountProvided - offset, msr.ovpLen);
        tmp = LUTSurroundProcessSamples5_1(inputs0,inputs1,frameCountProvided);
        wave_final(pointerOffset+1:pointerOffset+frameCountProvided,:)= tmp;
        offset = offset + processing;
    end
end
%     process(hpl,hpr,msr.frameLen,msr.fftLen);

% msr.timeDomainOut(:,1) =  msr.timeDomainOut(:,1) + lpl*msr.minuscrossBass;
% msr.timeDomainOut(:,2) =  msr.timeDomainOut(:,2) + lpr*msr.minuscrossBass;
% msr.timeDomainOut(:,1) =  lpl*msr.minuscrossBass;
% msr.timeDomainOut(:,2) =  lpr*msr.minuscrossBass;
% msr.timeDomainOut(:,6) = (lpl + lpr)*msr.crossBass;

% plot(xl,'b');
% hold on 
% plot(msr.timeDomainOut(:,1),'r');
% audiowrite('test_wav_ch4.wav',msr.timeDomainOut(:,4),msr.fs);
% audiowrite('test_wav_ch3.wav',msr.timeDomainOut(:,3),msr.fs);
% audiowrite('test_wav_ch2.wav',msr.timeDomainOut(:,2),msr.fs);
% audiowrite('test_wav_ch1.wav',msr.timeDomainOut(:,1),msr.fs);
% 
% audiowrite('test_wav_ch5.wav',msr.timeDomainOut(:,5),msr.fs);
% audiowrite('SineStereo.wav',SineStereo(:,1:2),msr.fs);
audiowrite('SineStereo_proced_mb.wav',wave_final,msr.fs);
% audiowrite('SineMono_proced_mb.wav',tmp0,msr.fs);
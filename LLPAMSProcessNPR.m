function   LLPAMSProcessNPR
global msr
global analysisWnd
global synthesisWnd
global M_PI
global chmaskPtr
global MAX_OUTPUT_BUFFERS
global mode
  % find dimensions
  freqs = msr.halfLen + 2; % two-sided + nyquist point

  for i = 0: msr.frameLen-1
      k = i + msr.mInputPos;
      if (k >= msr.frameLen)
			k = k - msr.frameLen;
      end
      w = analysisWnd(i+1);
      msr.TempLBuffer(msr.mBitRev(i+1)+1) = msr.mInput(1,k+1) * w;
	  msr.mTempRBuffer(msr.mBitRev(i+1)+1) = msr.mInput(2,k+1) * w;
  end
   for i = msr.frameLen:msr.fftLen
       msr.TempLBuffer(msr.mBitRev(i+1)+1) = 0;
       msr.mTempRBuffer(msr.mBitRev(i+1)+1) = 0;
   end

       msr.TempLBuffer = fft(msr.TempLBuffer, msr.fftLen);
       msr.mTempRBuffer = fft(msr.mTempRBuffer, msr.fftLen);
    
       lR = msr.mTempLBuffer(1) * 2.0;
	   rR = msr.mTempRBuffer(1) * 2.0;
        
       magnitudeLeft = abs(lR);
       magnitudeRight = abs(rR);
       magnitudeSum = magnitudeLeft + magnitudeRight; 
       if(magnitudeSum<2.2204460492503131e-016)
             magDiff = 0;
        else
             magDiff = (magnitudeRight - magnitudeLeft)/ magnitudeSum;
       end
        magDiff = max(-1.0, min(1.0, magDiff));
        phaseL = 0;
        if(lR<0)
            phaseL = M_PI;
        end
        phaseR = 0;
        if(rR<0)
            phaseR= M_PI;
        end
         phaseDiff = abs(phaseR - phaseL);
        if (phaseDiff > M_PI) 
            phaseDiff = 2*M_PI - phaseDiff;
        end
        [x,y] = cartesianMap(msr.magPhaseDiff2Cartesian,magDiff,phaseDiff);
        leftCosineTerm = cos(phaseL);
        rightCosineTerm = cos(phaseR);
        centreCosineTerm = 1;
        if (lR + rR)<0
            centreCosineTerm = -1;
        end
       	[u,x] = map_to_grid(x, 21); 
        [v,y] = map_to_grid(y, 21);
        magSqrt = sqrt(magnitudeLeft^2 + magnitudeRight^2);
        opLFwd = lR - rR * msr.smoothedFunc(8,1); 
        opRFwd = rR - lR * msr.smoothedFunc(9,1); 
        
        pmix = msr.mix;
        minusPmix = 1 - pmix;
        magnitude = lerpCompCplx(1,1,magSqrt,chmaskPtr,u,v,x,y);
        msr.timeDomainOut(1,1) = (magnitude * leftCosineTerm) * 1.2;
        magnitude = lerpCompCplx(2,1,magSqrt,chmaskPtr,u,v,x,y);
        msr.timeDomainOut(2,1) = (magnitude * leftCosineTerm) * 1.2;
        magnitude = lerpCompCplx(3,1,magSqrt,chmaskPtr,u,v,x,y);
        msr.timeDomainOut(3,1) = (magnitude * leftCosineTerm) * 1.2;
        magnitude = lerpCompCplx(4,1,magSqrt,chmaskPtr,u,v,x,y);
        msr.timeDomainOut(4,1) = (magnitude * leftCosineTerm) * 1.2;
       
        
    for i = 1:msr.procUpTo-1
      symIdx = msr.fftLen - i; 
      bitRevFwd = msr.mBitRev(i+1); 
      bitRevSym = msr.mBitRev(symIdx); 
      lR = msr.mTempLBuffer(i+1) + msr.mTempLBuffer(symIdx+1); 
      lI = msr.mTempLBuffer(i+1) - msr.mTempLBuffer(symIdx+1); 
      rR = msr.mTempRBuffer(i+1) + msr.mTempRBuffer(1+symIdx); 
      rI = msr.mTempRBuffer(i+1) - msr.mTempRBuffer(symIdx+1); 
      magnitudeLeft = sqrt(lR^2+lI);
      magnitudeRight = sqrt(rR^2+rI);
      minMag = min(magnitudeLeft, magnitudeRight);
      ratMinLeft = minMag/(magnitudeLeft + eps);
      if (abs(ratMinLeft - msr.smoothedFunc(9,i)) < msr.smoothing)
             msr.smoothedFunc(9,i) = ratMinLeft; 
       elseif (ratMinLeft > msr.smoothedFunc(9,i))
             msr.smoothedFunc(9,i) = msr.smoothedFunc(9,i) + msr.smoothing;
       else
             msr.smoothedFunc(9,i) = msr.smoothedFunc(9,i) - msr.smoothing;
       end
         ratMinRight = minMag/(magnitudeRight + eps);
         if (abs(ratMinRight - msr.smoothedFunc(8,i)) < msr.smoothing)
             msr.smoothedFunc(8,i) = ratMinRight; 
         elseif (ratMinRight > msr.smoothedFunc(8,i))
             msr.smoothedFunc(8,i) = msr.smoothedFunc(8,i) + msr.smoothing;
         else
             msr.smoothedFunc(8,i) = msr.smoothedFunc(8,i) - msr.smoothing;
         end
         magnitudeSum = magnitudeLeft + magnitudeRight; 
         if(magnitudeSum<2.2204460492503131e-016)
             magDiff = 0;
         else
             magDiff = (magnitudeRight - magnitudeLeft)/ magnitudeSum;
         end
         magDiff = max(-1.0, min(1.0, magDiff));
         phaseL = atan2(lI,lR);
         phaseR = atan2(rI,rR);
         phaseDiff = abs(phaseR - phaseL);
         if (phaseDiff > M_PI) 
                phaseDiff = 2*M_PI - phaseDiff;
         end
         [x,y] = cartesianMap(msr.magPhaseDiff2Cartesian,magDiff,phaseDiff);
       
         leftSineTerm = sin(phaseL);
         leftCosineTerm = cos(phaseL);

         rightSineTerm = sin(phaseR);
         rightCosineTerm = cos(phaseR);

         centrePhase = atan2((lI + rI),(lR + rR));
         centreCosineTerm = cos(centrePhase); 
         centreSineTerm = sin(centrePhase); 
       
         [u,x] = map_to_grid(x, 21); 
         [v,y] = map_to_grid(y, 21);
         
        magSqrt = sqrt(magnitudeLeft^2 + magnitudeRight^2);
          
        opLFwd = lR - rR * msr.smoothedFunc(8,i); 
        opRFwd = rR - lR * msr.smoothedFunc(9,i); 
        
        opLSym = (lR - lI) - (rR - rI) * msr.smoothedFunc(8,i);
        opRSym = (rR - rI) - (lR - lI) * msr.smoothedFunc(9,i);
        %end mainloop
        
        magnitude = lerpCompCplx(1,i,magSqrt,chmaskPtr,u,v,x,y);
        real = magnitude * leftCosineTerm;
        imag = magnitude * leftSineTerm;
        msr.timeDomainOut(1,bitRevFwd+1) = (real + imag) * 1.2;
        msr.timeDomainOut(1,bitRevSym+1) = (real - imag) * 1.2;
       
      magnitude = lerpCompCplx(2,i,magSqrt,chmaskPtr,u,v,x,y);
        real = magnitude * leftCosineTerm;
        imag = magnitude * leftSineTerm;
        msr.timeDomainOut(2,bitRevFwd+1) = (real + imag) * 1.2;
        msr.timeDomainOut(2,bitRevSym+1) = (real - imag) * 1.2;

         magnitude = lerpCompCplx(3,i,magSqrt,chmaskPtr,u,v,x,y);
        real = magnitude * leftCosineTerm;
        imag = magnitude * leftSineTerm;
        msr.timeDomainOut(3,bitRevFwd+1) = (real + imag) * 1.2;
        msr.timeDomainOut(3,bitRevSym+1) = (real - imag) * 1.2;

        magnitude = lerpCompCplx(4,i,magSqrt,chmaskPtr,u,v,x,y);
        real = magnitude * leftCosineTerm;
        imag = magnitude * leftSineTerm;
        msr.timeDomainOut(4,bitRevFwd+1) = (real + imag) * minusPmix + opLFwd * pmix;
        msr.timeDomainOut(4,bitRevSym+1) = (real - imag) * minusPmix + opLSym * pmix;
        
        magnitude = lerpCompCplx(5,i,magSqrt,chmaskPtr,u,v,x,y);
        real = magnitude * leftCosineTerm;
        imag = magnitude * leftSineTerm;
        msr.timeDomainOut(5,bitRevFwd+1) = (real + imag) * minusPmix + opRFwd * pmix;
        msr.timeDomainOut(5,bitRevSym+1) = (real - imag) * minusPmix + opRSym * pmix; 
          
    end
       
     for j = 0:6 - 2
        msr.timeDomainOut(j+1,:) = fft(msr.timeDomainOut(j+1,:));
     end
     
      msr.mOutputBufferCount = msr.mOutputBufferCount + 1;

        if (msr.mOutputBufferCount > MAX_OUTPUT_BUFFERS)
              'return';
              return;
        end
%          msr.timeDomainOut(bdx+1:bdx+msr.frameLen,6) = (lp(:,1) + lp(:,2))*msr.crossBass;
    
%        k = i + msr.mInputPos + msr.smpShift;
% 		if (k >= msr.frameLen)
% 			k = k - msr.frameLen;
%         plot(msr.timeDomainOut_right(1,1:384));
        for kk = 0:msr.ovpLen-1  
            mm = kk + msr.mInputPos + msr.smpShift;
            if(mm >= msr.frameLen)
                mm = mm - msr.frameLen;
            end
          
%           msr.mOverlapStage2dash(1,kk+1) = msr.timeDomainOut_right(1,1+msr.smpShift + msr.ovpLen + kk);
            msr.mOutputBuffer(1,kk+1) = msr.mOverlapStage2dash(1,kk+1) + (msr.timeDomainOut_right(1,1+kk + msr.smpShift) * synthesisWnd(kk+1)) + msr.mInputSub(1,mm+1) * msr.minuscrossBass;%20%的低频混到左声道去
            msr.mOverlapStage2dash(1,kk+1) = msr.timeDomainOut_right(1,1+msr.smpShift + msr.ovpLen + kk) * synthesisWnd(1+kk + msr.ovpLen);
            msr.mOutputBuffer(2,kk+1) = msr.mOverlapStage2dash(2,kk+1) + (msr.timeDomainOut_right(2,1+kk + msr.smpShift) * synthesisWnd(kk+1)) + msr.mInputSub(1,mm+1) * msr.minuscrossBass;%20%的低频混到左声道去
            msr.mOverlapStage2dash(2,kk+1) = msr.timeDomainOut_right(2,1+msr.smpShift + msr.ovpLen + kk) * synthesisWnd(1+kk + msr.ovpLen);
            
           for ll = 3:5
                msr.mOutputBuffer(ll,kk+1) = msr.mOverlapStage2dash(ll,kk+1) + (msr.timeDomainOut_right(ll,1+kk + msr.smpShift) * synthesisWnd(kk+1));
                msr.mOverlapStage2dash(ll,kk+1) = msr.timeDomainOut_right(ll,1+msr.smpShift + msr.ovpLen + kk) * synthesisWnd(1+kk + msr.ovpLen);
           end
            msr.mOutputBuffer(6,kk+1) = (msr.mInputSub(1,mm+1) + msr.mInputSub(2,mm+1)) * msr.crossBass;
        end
        
        
        msr.mInputSamplesNeeded = msr.ovpLen;
  end

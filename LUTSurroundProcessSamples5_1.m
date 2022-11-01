function components = LUTSurroundProcessSamples5_1(inLeft, inRight, inSampleCount)
% numOut = 6;  
global mode
global msr; 
global MAX_OUTPUT_BUFFERS    
    components = zeros(inSampleCount,mode+1);
    outSampleCount = 0;
    maxOutSampleCount = inSampleCount; 
    while (inSampleCount > 0)        
        copyCount = min(msr.mInputSamplesNeeded, inSampleCount);
        in_idx = 0;
        while (in_idx < copyCount) 
            [msr.mInputSub(1,msr.mInputPos+in_idx+1),msr.mInputSub(2,msr.mInputPos+in_idx+1),...
                msr.mInput(1,msr.mInputPos+in_idx+1),msr.mInput(2,msr.mInputPos+in_idx+1)]...
                = processLR2(inLeft(in_idx+1), inRight(in_idx+1)); 
            in_idx = in_idx + 1; 
        end
        inSampleCount = inSampleCount - copyCount; 
        msr.mInputPos = msr.mInputPos + copyCount; 
        if (msr.mInputPos >= msr.frameLen) 
            msr.mInputPos = msr.mInputPos - msr.frameLen; 
        end
        msr.mInputSamplesNeeded = msr.mInputSamplesNeeded - copyCount; 
        if (msr.mInputSamplesNeeded == 0) 
            LLPAMSProcessNPR;
        end
    end
   
    while ((msr.mOutputBufferCount > 0) && (outSampleCount < maxOutSampleCount))
        %getBuf
        copyCount = min(msr.ovpLen - msr.mOutputReadSampleOffset, maxOutSampleCount - outSampleCount);
        idx_in = 0;
        idx_out = 0;
        % is while
        while idx_out<copyCount
            for ch = 0:mode
%                 msr.mOutputBuffer(msr.mOutputReadSampleOffset * numOut+idx_in+1)*1.12202;
                components(idx_out+1,ch+1)=...
                    msr.mOutputBuffer(ch+1,idx_out+ msr.mOutputReadSampleOffset + 1);
                idx_in = idx_in + 1;
            end
            idx_out = idx_out + 1;
        end
        %expandOutputBufferOp
        outSampleCount = outSampleCount + copyCount;
        msr.mOutputReadSampleOffset = msr.mOutputReadSampleOffset + copyCount;
        if (msr.mOutputReadSampleOffset >= msr.ovpLen) 
            msr.mOutputBufferCount = msr.mOutputBufferCount - 1;
            msr.mOutputReadSampleOffset = 0;        
            if (msr.mOutputBufferCount > 0) 	
%                 moveToEnd = msr.mOutputBuffer(1); 
                for i = 1:MAX_OUTPUT_BUFFERS-1
%                     msr.mOutputBuffer(i) = msr.mOutputBuffer(i+1);
                end
%                 msr.mOutputBuffer(MAX_OUTPUT_BUFFERS) = 0; 
                for i = 0:MAX_OUTPUT_BUFFERS-1
                    if (~msr.mOutputBuffer(i+1))		
%                         msr.mOutputBuffer(i+1) = moveToEnd;
                        break; 
                    end
                end
            end
        end     
    end   

end

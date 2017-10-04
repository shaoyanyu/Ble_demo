//
//  BleDataBuffer.m
//  BleDemo
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BleDataBuffer.h"

//char SERL_COMM_FRAME_HEAD =0;               /* Frame head */
//char SERL_COMM_FRAME_DATA	= 1;               /* Frame data */
//char SERL_COMM_FRAME_TAIL	= 2;               /* Frame tail */
//char SERL_COMM_FRAME_ESCAPE =	3;               /* get a escape char: 0xDB */
//char SERL_COMM_FRAME_HEAD_HALF = 4;               /* Get one 0xFF */
/*
char RECEIVE_FRAME_STATE = 2;

char JIA = 0;
char zhen = 1;

int INPUT_QUEUE_SIZE = 128;
int OUTPUT_QUEUE_SIZE = 128;
int MESSAGE_MAX_SIZE = 128;

int serialNumber = 0;
int commandType = 0x03;

char mInputQueue[128];
int mInputQueueHead;
int mInputQueueTail;


int mFrameData[128];
int validDataLen;
int mFrameDataIndex;
int mBcc;
int mPad;
*/

@implementation BleDataBuffer

-(id)init
{
    if(self=[super init])
    {
        SERL_COMM_FRAME_HEAD = 0;               /* Frame head */
        SERL_COMM_FRAME_DATA	= 1;               /* Frame data */
        SERL_COMM_FRAME_TAIL	= 2;               /* Frame tail */
        SERL_COMM_FRAME_ESCAPE =	3;               /* get a escape char: 0xDB */
        SERL_COMM_FRAME_HEAD_HALF = 4;               /* Get one 0xFF */
        
        RECEIVE_FRAME_STATE = SERL_COMM_FRAME_TAIL;
        
        JIA = 0;
        ZHEN = 1;
        
        INPUT_QUEUE_SIZE = 128;
        OUTPUT_QUEUE_SIZE = 128;
        MESSAGE_MAX_SIZE = 128;
        
        serialNumber = 0;
        commandType = 0x03;
        
        
        mInputQueueHead = 0;
        mInputQueueTail = 0;
        
        mFrameDataIndex = -1;
        mBcc = 0;
        mPad = 0;
    }
    return self;
}


-(void)receiveData:(char[]) data length:(int)length
{
    for (int i = 0; i < length; i++) {
        if ((mInputQueueTail + 1 == mInputQueueHead)
            || (((mInputQueueTail + 1) >= INPUT_QUEUE_SIZE) && mInputQueueHead == 0)) {
            NSLog(@"dc-debug ble input queue full.");
        } else {
            mInputQueue[mInputQueueTail] = data[i];
            if (mInputQueueTail >= (INPUT_QUEUE_SIZE - 1)) {
                mInputQueueTail = 0;
                
            } else {
                
                mInputQueueTail++;
            }
        }
    }
    
}


-(int) fetchInputQueue:(char[])Output length:(int)len
{
    int tail;
    int ret = 0;
    int validDataFromHeadToTail = 0;
    int validDataLen;
    
    tail = mInputQueueTail;
    if (tail >= mInputQueueHead) {
        validDataLen = tail - mInputQueueHead;
        if (validDataLen >= len) {
            //System.arraycopy(mInputQueue, mInputQueueHead, Output, 0, len);
            for(int i =0;i<len;i++){
                Output[i]=mInputQueue[mInputQueueHead+i];
            }
            
            mInputQueueHead += len;
            ret = len;
        } else {
            ret = 0;
        }
    } else {
        validDataLen = INPUT_QUEUE_SIZE - mInputQueueHead + tail;
        if (validDataLen >= len) {
            validDataFromHeadToTail = INPUT_QUEUE_SIZE - mInputQueueHead;
            if (validDataFromHeadToTail >= len) {
                //System.arraycopy(mInputQueue, mInputQueueHead, Output, 0, len);
                for(int i =0;i<len;i++){
                    Output[i]=mInputQueue[mInputQueueHead+i];
                }
                mInputQueueHead += len;
                ret = len;
            } else {
                //System.arraycopy(mInputQueue, mInputQueueHead, Output, 0, validDataFromHeadToTail);
                for(int i =0;i<validDataFromHeadToTail;i++){
                    Output[i]=mInputQueue[mInputQueueHead+i];
                }
                //System.arraycopy(mInputQueue, 0, Output, validDataFromHeadToTail, len - validDataFromHeadToTail);
                for(int i =0;i<len-validDataFromHeadToTail;i++){
                    Output[validDataFromHeadToTail+i]=mInputQueue[i];
                }
                mInputQueueHead = len - validDataFromHeadToTail;
                ret = len;
            }
        } else {
            ret = 0;
        }
    }
    
    return ret;
    
}


-(int) calculateBcc:(int[])inputData length:(int)mylength;
{
    int result = 0;
    int index = 0;
    
    result = inputData[index];
    
    for (index = 1; index < mylength; index++) {
        
        result ^= inputData[index];
    }
    
    return result;
    
}


-(char*) getData
{
    int length = mFrameData[2];
    char tmpData[length];
    
    for (int i = 0; i < length; i++) {
        tmpData[i] = (char)(mFrameData[4 + i] & 0x000000ff);
    }
    
    serialNumber = mFrameData[0];
    char *pt =tmpData;
    return pt;
}

-(int)readFrame
{
    char tmpByteArray[1];
    int tmpInt = 0;
    
    
    while (1 ==[self fetchInputQueue:tmpByteArray length:1]) {
        tmpInt = 0x000000ff & tmpByteArray[0];
        if ((int)0xff == tmpInt) {
            if (RECEIVE_FRAME_STATE == SERL_COMM_FRAME_DATA) {
                /* 0xC0 # # 0xC0 */
                mBcc = mFrameData[mFrameDataIndex];
                RECEIVE_FRAME_STATE = SERL_COMM_FRAME_TAIL;
                
                /* Get total frame . Do BCC Check, return result */
                if([self calculateBcc:mFrameData length:mFrameDataIndex] == mBcc) {
                    /* BCC is OK. Get a message frame */
                    return TRUE;
                } else {
                    /* CRC is wrong. Delete the message frame. */
                    //return TRUE;
                    mFrameDataIndex = -1;
                    return FALSE;
                }
            } else if (RECEIVE_FRAME_STATE == SERL_COMM_FRAME_TAIL) {
                /* single delimter */
                RECEIVE_FRAME_STATE = SERL_COMM_FRAME_HEAD_HALF;
                /* Start receive frame. Initialize the frame buffer. */
                mFrameDataIndex = -1;
            } else if (RECEIVE_FRAME_STATE == SERL_COMM_FRAME_HEAD_HALF) {
                /* single delimter */
                RECEIVE_FRAME_STATE = SERL_COMM_FRAME_HEAD;
                /* Start receive frame. Initialize the frame buffer. */
                mFrameDataIndex = -1;
            } else if (RECEIVE_FRAME_STATE == SERL_COMM_FRAME_HEAD) {
                mFrameDataIndex = -1;
            } else {
                RECEIVE_FRAME_STATE = SERL_COMM_FRAME_TAIL;
                mFrameDataIndex = -1;
                return FALSE;
            }
        } else if ((int)0xfe == tmpInt) {
            /* I don't get delimiter. I get a escape char. Check next char...*/
            if( (RECEIVE_FRAME_STATE == SERL_COMM_FRAME_HEAD )
               || (RECEIVE_FRAME_STATE == SERL_COMM_FRAME_DATA ) )
            {
                RECEIVE_FRAME_STATE = SERL_COMM_FRAME_ESCAPE;
            }
        } else {
            /* I get normal data. Not escape char, not delimiter. */
            if( RECEIVE_FRAME_STATE == SERL_COMM_FRAME_HEAD ) {
                /* Last byte is frame head */
                mFrameDataIndex = -1;
                RECEIVE_FRAME_STATE = SERL_COMM_FRAME_DATA;
            }
            else if( RECEIVE_FRAME_STATE == SERL_COMM_FRAME_ESCAPE ) {
                RECEIVE_FRAME_STATE = SERL_COMM_FRAME_DATA;
                
                if( tmpInt == (int)0x01/*0xDC 0x5E*/ ) {
                    tmpInt = (int)0xff;/*0x7E*/
                }
                else if( tmpInt == (int)0x0/*0x5D*/ ) {
                    tmpInt = (int)0xfe;/*0x7D;*/
                }
                
                /* else,  meaningless char after escape char. Wrong state, just use the current data. */
            }
            
            /* else, don't change state value. */
            
            if( RECEIVE_FRAME_STATE == SERL_COMM_FRAME_DATA ) {
                if( mFrameDataIndex < (MESSAGE_MAX_SIZE - 1) ) {
                    mFrameData[++mFrameDataIndex] = tmpInt;
                }
                else
                {
                    /* Buffer is full. WRONG state. */
                    mFrameDataIndex = -1;
                    RECEIVE_FRAME_STATE = SERL_COMM_FRAME_TAIL;
                    return FALSE;
                }
            }
        }
    }
    return FALSE;
}


-(int) writeFrame:(int[])input length:(int)length
{
    int bcc;
    int index = 0;
    
    mFrameData[0] = serialNumber;
    mFrameData[1] = commandType;
    mFrameData[2] = length & 0x000000ff;
    mFrameData[3] = (length & 0x0000ff00) >> 8;
    
    for (int i = 0; i < length; i++) {
        mFrameData[4 + i] = input[i];
    }
    //bcc = calculateBcc(mFrameData, length + 4);
    bcc = [self calculateBcc:mFrameData length:length+4];
    
    if (length < MESSAGE_MAX_SIZE) {
        /* Set frame head */
        mFrameData[0] = 0xFF;/*0x7E;*/
        mFrameData[1] = 0xFF;
        //Set serial number
        mFrameData[2] = serialNumber;
        mFrameData[3] = commandType;
        
        if(0xFF == length)
        {
            mFrameData[4] = 0xFE;
            mFrameData[5] = 0x01;
            mFrameData[6] = (short)((length & 0x0000ff00) >> 8);
            index += 7;
        }
        else if(0xFE == length)
        {
            mFrameData[4] = 0xFE;
            mFrameData[5] = 0x00;
            mFrameData[6] = (short)((length & 0x0000ff00) >> 8);
            index += 7;
        }
        else
        {
            /* Get frame data length */
            mFrameData[4] = (short)(length & 0x000000ff);
            mFrameData[5] = (short)((length & 0x0000ff00) >> 8);
            index += 6;
        }
        
        /* Set frame data */
        for( int dataPos = 0; dataPos < length; dataPos++ )
        {
            if(input[dataPos] == 0xFF)
            {
                mFrameData[ index++ ] = 0xFE;
                mFrameData[ index++ ] = 0x01;
            }
            else if(input[dataPos] == 0xFE)
            {
                mFrameData[ index++ ] = 0xFE;
                mFrameData[ index++ ] = 0x0;
            }
            else
            {
                mFrameData[ index++ ] = input[dataPos];
            }
        }
        
        /* get CRC check value and do some escape thing if necessary */
        if( bcc == 0xFF/*0x7E*/ )
        {
            mFrameData[ index++ ] = 0xFE;/*0x7D;*/
            mFrameData[ index++ ] = 0x01;/*0x5E;*/
        }
        else if( bcc == 0xFE/*0x7D*/ )
        {
            mFrameData[ index++ ] = 0xFE;/*0x7D;*/
            mFrameData[ index++ ] = 0x0;/*0x5D;*/
        }
        else
        {
            mFrameData[ index++ ] = bcc;
        }
        
        /* frame end */
        mFrameData[ index++ ] = 0xFF;
        
        validDataLen = index;
        
        return TRUE;
        /* Now ucBufPtr is equal to number of data in frame */
        /*
	        if(putOutputQueue(mFrameData, index) != index)
	        {
         mFrameDataIndex = -1;
         return FALSE;
	        }
	        else
	        {
         mFrameDataIndex = -1;
         return TRUE;
	        }
	        */
    } else {
        mFrameDataIndex = -1;
        return FALSE;
    }
    
}


-(char*)convertIntsToBytes:(int*)input length:(int)length
{
    char retBytes[length];
    for (int i = 0; i < length; i++) {
        retBytes[i] = (char)((*input) & 0x000000ff);
        input++;
    }
    char *pt =retBytes;
    return pt;
    
}


-(void)setSerialNumber:(int) n
{
    serialNumber = n;
    
}

-(int*) getFrameData
{
    int *pt =mFrameData;
    return pt;
}
-(int)getvalidDataLen
{
    return validDataLen;
}
-(void)setvalidDataLen:(int) n
{
    validDataLen =n;
}
-(void)getNoData
{
    serialNumber = mFrameData[0];
}






@end


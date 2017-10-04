//
//  BleDataBuffer.h
//  BleDemo
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#ifndef BleDataBuffer_h
#define BleDataBuffer_h


#endif /* BleDataBuffer_h */
#import <Foundation/Foundation.h>

@interface BleDataBuffer : NSObject{
    char SERL_COMM_FRAME_HEAD;               /* Frame head */
    char SERL_COMM_FRAME_DATA;               /* Frame data */
    char SERL_COMM_FRAME_TAIL;               /* Frame tail */
    char SERL_COMM_FRAME_ESCAPE;               /* get a escape char: 0xDB */
    char SERL_COMM_FRAME_HEAD_HALF;               /* Get one 0xFF */
    
    char RECEIVE_FRAME_STATE;
    
    char JIA;
    char ZHEN;
    
    int INPUT_QUEUE_SIZE;
    int OUTPUT_QUEUE_SIZE;
    int MESSAGE_MAX_SIZE;
    
    int serialNumber;
    int commandType;
    
    char mInputQueue[128];
    int mInputQueueHead;
    int mInputQueueTail;
    
    
    int mFrameData[128];
    int validDataLen;
    int mFrameDataIndex;
    int mBcc;
    int mPad;
}



-(void)receiveData:(char[]) data length:(int)length;
-(int) fetchInputQueue:(char[])Output length:(int)len;
-(int) calculateBcc:(int[])inputData length:(int)mylength;
-(char*) getData;
-(int)readFrame;
-(int) writeFrame:(int[])input length:(int)length ;
-(char*)convertIntsToBytes:(int[])input length:(int)length;
-(void)setSerialNumber:(int) n;
-(int*) getFrameData;
-(int)getvalidDataLen;
-(void)setvalidDataLen:(int) n;
-(void)getNoData;


//-(int) getSerialNumber;
//-(void)setValidDataLen:(int) n;


@end


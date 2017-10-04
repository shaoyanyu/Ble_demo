//
//  BleCommand.h
//  BleDemo
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#ifndef BleCommand_h
#define BleCommand_h


#endif /* BleCommand_h */

#import <Foundation/Foundation.h>

@interface BleCommand : NSObject{
    int commandType;
    int serialNumber;
    NSString* data;
}

-(void) setCommandType:(int)n;
-(void) setSerialNumber:(int)n;
-(void) setData:(NSString *)s;




@end

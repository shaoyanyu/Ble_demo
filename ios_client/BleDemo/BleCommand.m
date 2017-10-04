//
//  BleCommand.m
//  BleDemo
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleCommand.h"

int commandType =0x02;
int serialNumber =0;
NSString* data;

static Byte CMD_RESET_CARD = 0x01;
static Byte CMD_APDU = 0x02;
static Byte CMD_CLOSE_DEVICE = 0x03;
static NSString *BLE_CMD_NAME = @"ble-command";



@implementation BleCommand

-(id)init
{
    if(self=[super init])
    {
        commandType = 0x02;
        serialNumber = 0;
    }
    return self;
}

-(void) setCommandType:(int)n {
    commandType =n;
}

-(void) setSerialNumber:(int)n {
    serialNumber =n;
}

-(void) setData:(NSString *)s {
    data =s;
}






@end
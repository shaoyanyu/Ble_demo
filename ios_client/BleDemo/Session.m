//
//  Session.m
//  BleDemo
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"

@implementation Session
// 单例对象
static Session *instance;

// 单例
+ (Session *) GetInstance {
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
            
        }
    }
    return instance;
}
-(id) init
{
    if (self = [super init]) {
        self.name = [[NSString alloc] init];
        self.money = [[NSString alloc] init];
    }
    return self;
}

@end

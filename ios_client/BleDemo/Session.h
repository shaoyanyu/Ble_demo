//
//  Session.h
//  BleDemo
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#ifndef Session_h
#define Session_h


#endif /* Session_h */
//#import <foundation foundation.h="">

@interface Session : NSObject
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *money;
//实现单例方法
+ (Session *) GetInstance;
@end
//</foundation>
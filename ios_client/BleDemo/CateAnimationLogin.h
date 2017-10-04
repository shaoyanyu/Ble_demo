//
//  CateAnimationLogin.h
//  BleDemo
//
//  Created by apple on 16/5/7.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#ifndef CateAnimationLogin_h
#define CateAnimationLogin_h


#endif /* CateAnimationLogin_h */
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ClickType){
    clicktypeNone,
    clicktypeUser,
    clicktypePass
};
@interface CateAnimationLogin : UIView
@property (strong, nonatomic)UITextField *userNameTextField;
@property (strong, nonatomic)UITextField *PassWordTextField;
@end


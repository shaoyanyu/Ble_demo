//
//  CateAnimationRegist.h
//  BleDemo
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#ifndef CateAnimationRegist_h
#define CateAnimationRegist_h


#endif /* CateAnimationRegist_h */
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ClickType1){
    clicktypeNone1,
    clicktypeUser1,
    clicktypePass1
};
@interface CateAnimationRegist : UIView
@property (strong, nonatomic)UITextField *userNameTextField;
@property (strong, nonatomic)UITextField *PassWordTextField;
@property (strong, nonatomic)UITextField *PassWordTextField2;
@end
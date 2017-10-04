//
//  ViewController.m
//  BleDemo
//
//  Created by ZTELiuyw on 15/8/13.
//  Copyright (c) 2015年 liuyanwei. All rights reserved.
//

#import "RegisterViewController.h"
#import "BeCentralVewController.h"
#import "BePeripheralViewController.h"
#import "CateAnimationLogin.h"
#import "CateAnimationRegist.h"

@interface RegisterViewController (){
    
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CateAnimationRegist *login=[[CateAnimationRegist alloc]initWithFrame:CGRectMake(0, 50,self.view.bounds.size.width, 400)];
    [self.view addSubview:login];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"b3.jpg"] ];
    
    
}

/*
 - (IBAction)beCentral:(id)sender {
 BeCentralVewController *vc = [[BeCentralVewController alloc]init];
 [self.navigationController pushViewController:vc animated:YES];
 }
 
 - (IBAction)bePeripheral:(id)sender {
 BePeripheralViewController *vc = [[BePeripheralViewController alloc]init];
 [self.navigationController pushViewController:vc animated:YES];
 }
 */
@end

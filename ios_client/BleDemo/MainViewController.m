//
//  MainViewController.m
//  BleDemo
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeCentralVewController.h"
#import "MainViewController.h"
#import "DataViewController.h"
#import "Session.h"

@interface MainViewController (){
    UILabel *info,*info1;
    UIButton *button,*button1,*button0;
    Session *session;
    
    UIAlertView* alert;
    UITextField *tf;



}

@end

@implementation MainViewController

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%d",buttonIndex);
    if(buttonIndex==1){
        NSString *addmoney = tf.text;
        int intString = [addmoney intValue];
        Session *session = [Session GetInstance];
        int newmoney =[session.money intValue]+intString;
        NSString *stringInt = [NSString stringWithFormat:@"%d",newmoney];
        NSString *str = [[NSString alloc] initWithString:[NSString stringWithFormat:@"您的余额为%@",stringInt]];
        session.money=stringInt;
        [info1 setText:str];
        
        UIAlertView *alter1 = [[UIAlertView alloc] initWithTitle:@"充值成功" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter1 show];


   
        

        
        /*
        //int newmoney =[_money intValue]+intString;
        int newmoney =[session.money intValue]+intString;
        //NSLog(@"%d",newmoney);
        NSString *value = session.money;
        NSLog(value);
        NSString *stringInt = [NSString stringWithFormat:@"%d",newmoney];
        NSString *str = [[NSString alloc] initWithString:[NSString stringWithFormat:@"您的余额为%@",stringInt]];
        session.money=stringInt;
        [info1 setText:str];
        //NSLog(@"INPUT:%@", money);
         */
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    alert = [[UIAlertView alloc] initWithTitle:nil
                                       message:@"请输入充值金额"
                                      delegate:self
                             cancelButtonTitle:@"cancel"
                             otherButtonTitles:@"OK", nil];
    // 基本输入框，显示实际输入的内容
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //设置输入框的键盘类型
    tf = [alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    

    
    
    //页面样式
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"b4.jpg"] ];
 

    info = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/5.4, self.view.frame.size.height/6.5, 250, 75)];
    info.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    Session *session = [Session GetInstance];
   // NSString *astring = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@你好",_name]];
    NSString *astring = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@您好",session.name]];
    [info setText:astring];
    info.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:info];
    
    info1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/5.4, (self.view.frame.size.height/6.5)+74, 250, 75)];
    info1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    //NSString *bstring = [[NSString alloc] initWithString:[NSString stringWithFormat:@"您的余额为%@",_money]];
    NSString *bstring = [[NSString alloc] initWithString:[NSString stringWithFormat:@"您的余额为%@",session.money]];
    [info1 setText:bstring];
    info1.textAlignment = UITextAlignmentCenter;
    
    info1.textColor = [UIColor redColor];
    info1.adjustsFontSizeToFitWidth = YES;
    info1.font = [UIFont boldSystemFontOfSize:20];
    
    
    [self.view addSubview:info1];

    button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button0 setTitle:@"账户充值" forState:UIControlStateNormal];
    button0.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"orange.png"] ];
    button0.bounds = CGRectMake(0, 0, 225, 75);
    button0.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*1.4/3);
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"圈存" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"orange.png"] ];
    button.bounds = CGRectMake(0, 0, 225, 75);
    button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*1.8/3);
    
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"操作记录查询" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"orange.png"] ];;
    button1.bounds = CGRectMake(0, 0, 225, 75);
    button1.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*2.2/3);
    
    
    
    [button0 addTarget:self action:@selector(button0:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    [button1 addTarget:self action:@selector(button1:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:button0];
    [self.view addSubview:button];
    [self.view addSubview:button1];
    
    
}

-(void)button:(UIButton *)sender{
    BeCentralVewController *vc = [[BeCentralVewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
   
}

-(void)button1:(UIButton *)sender{
    DataViewController *vc = [[DataViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)button0:(UIButton *)sender{
     [alert show];
  
    
}



@end


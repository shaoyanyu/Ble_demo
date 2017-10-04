//
//  ViewController.m
//  BleDemo
//
//  Created by ZTELiuyw on 15/8/13.
//  Copyright (c) 2015年 liuyanwei. All rights reserved.
//

#import "ViewController.h"
#import "BeCentralVewController.h"
#import "BePeripheralViewController.h"
#import "CateAnimationLogin.h"
#import "MainViewController.h"
#import "DataViewController.h"
#import "Session.h"
//#import "AppStatus.h"

@interface ViewController (){
    CateAnimationLogin *login;
}

@end

@implementation ViewController

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%d",buttonIndex);
    if(buttonIndex==0){
        Session *session = [Session GetInstance];
        
        session.name = [login userNameTextField].text;
        session.money=@"100";
        MainViewController *vc = [[MainViewController alloc]init];
        //vc.money=@"100";
        //vc.name=[login userNameTextField].text;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor blackColor];
    login=[[CateAnimationLogin alloc]initWithFrame:CGRectMake(0, 50,self.view.bounds.size.width, 400)];
    [self.view addSubview:login];    

    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background.jpg"] ];
}

- (IBAction)beMain:(id)sender {
    //[NSThread sleepForTimeInterval:3.00f];
    NSLog(@"%@",[login userNameTextField].text);
    NSString *name =[login userNameTextField].text;
    NSLog(@"%@",[login PassWordTextField].text);
    NSString *keyword=[login PassWordTextField].text;
    /*
    NSString *urlStr=[NSString stringWithFormat:@"http://172.20.10.4:8080/bookstores/servlet/test0?name=%@&keyword=%@",name,keyword];
    NSURL *url=[NSURL URLWithString:urlStr];
    //    2.创建请求对象
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //    3.发送请求
    //发送同步请求，在主线程执行
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //（一直在等待服务器返回数据，这行代码会卡住，如果服务器没有返回数据，那么在主线程UI会卡住不能继续执行操作）
    NSLog(@"--%d--",data.length);
    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"response:%@", aString);
    */
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"登录成功" delegate:self
                                             cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alertView show];
    
    
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

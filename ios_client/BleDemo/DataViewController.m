//
//  DataViewController.m
//  BleDemo
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "BeCentralVewController.h"
#import "DataViewController.h"

@interface DataViewController (){
    UILabel *info[10];
    UILabel *minfo;
    UIButton *button,*button1;
    
    
}

@end

@implementation DataViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //页面样式
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"b6.jpg"] ];

    minfo = [[UILabel alloc]initWithFrame:self.view.frame];
    [minfo setText:@"欢迎"];
    NSString *name =@"yu";
    
     NSString *urlStr=[NSString stringWithFormat:@"http://172.20.10.4:8080/bookstores/servlet/test1?name=%@",name];
     NSURL *url=[NSURL URLWithString:urlStr];
     //    2.创建请求对象
     NSURLRequest *request=[NSURLRequest requestWithURL:url];
     //    3.发送请求
     //发送同步请求，在主线程执行
     NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
     //（一直在等待服务器返回数据，这行代码会卡住，如果服务器没有返回数据，那么在主线程UI会卡住不能继续执行操作）
     //NSLog(@"--%d--",data.length);
     NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     NSLog(@"response:%@", aString);
    /*
    for(int i =0;i<5;i++){
        info[i] = [[UILabel alloc]initWithFrame:self.view.frame];
        
        NSRange range = [aString rangeOfString:@"*"];
        
        //NSLog(@"%d",range.location);
        NSString *str = [aString substringToIndex:range.location];
        
        info[i] = [[UILabel alloc]initWithFrame:self.view.frame];
        [info[i] setText:str];
        [info[i] setTextAlignment:<#(NSTextAlignment)#>]
        [self.view addSubview:info[i]];
        
        aString = [aString substringFromIndex:range.location];
        
        
    }*/
    
    
    
    
    UILabel *tips = [[UILabel alloc]initWithFrame:self.view.frame];
    [tips setTextColor:[UIColor grayColor]];
    //[tips setText:@"支付密码必须为6位数字组合。\n您可依次进入 '功能列表' -> '安全中心' 修改支付密码。"];
    [tips setText:aString];
    [tips setFont:[UIFont boldSystemFontOfSize:25]];
    tips.textAlignment = NSTextAlignmentLeft;
    tips.numberOfLines = 0; // 关键一句
    [self.view addSubview:tips];
     
    
    
    
    
    
    //[minfo setTextAlignment:NSTextAlignmentCenter];
    //[self.view addSubview:minfo];
   
    
    
}
@end
//
//  BeCentraliewController.m
//  BleDemo
//
//  Created by ZTELiuyw on 15/9/7.
//  Copyright (c) 2015年 liuyanwei. All rights reserved.
//

#import "BeCentralVewController.h"
#import "BleCommand.h"
#import "BleDataBuffer.h"
#import "Session.h"
#import "MainViewController.h"



@interface BeCentralVewController (){
    //系统蓝牙设备管理对象，可以把他理解为主设备，通过他，可以去扫描和链接外设
    CBCentralManager *manager;
    UILabel *info;
    UIButton *button,*button1;
    UIAlertView* alert,*alert1;
    UITextField *tf;
    Session *session;
    //用于保存被发现设备
    NSMutableArray *discoverPeripherals;
    CBPeripheral *mperipheral;
    CBCharacteristic *mcharacteristic;
    BleDataBuffer *mBleDataBuffer;
    
    int turn ;
    char use[18];
    NSString *money,*money1;
    //BOOL answer1 =TRUE;
}

@end

@implementation BeCentralVewController

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%d",buttonIndex);
    if(buttonIndex==1){
        money = tf.text;
        money1 = tf.text;
        NSLog(@"INPUT:%@", money);

        [self notifyCharacteristic:mperipheral characteristic:mcharacteristic];
        NSString *mstr =@"00A404000E315041592E5359532E4444463031";
        [self prepareAndSendFrame2:mstr num:8];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     设置主设备的委托,CBCentralManagerDelegate
     必须实现的：
     - (void)centralManagerDidUpdateState:(CBCentralManager *)central;//主设备状态改变的委托，在初始化CBCentralManager的适合会打开设备，只有当设备正确打开后才能使用
     其他选择实现的委托中比较重要的：
     - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI; //找到外设的委托
     - (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;//连接外设成功的委托
     - (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//外设连接失败的委托
     - (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//断开外设的委托
     */
    
    //初始化并设置委托和线程队列，最好一个线程的参数可以为nil，默认会就main线程
    manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];

  //持有发现的设备,如果不持有设备会导致CBPeripheralDelegate方法不能正确回调
    discoverPeripherals = [[NSMutableArray alloc]init];
    //页面样式
    [self.view setBackgroundColor:[UIColor whiteColor]];
    info = [[UILabel alloc]initWithFrame:self.view.frame];
    [info setText:@"正在执行程序，请观察NSLog信息"];
 
    [info setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:info];
    
    alert = [[UIAlertView alloc] initWithTitle:@"蓝牙设备连接成功"
                                 message:@"请输入充值金额"
                                 delegate:self
                                 cancelButtonTitle:@"cancel"
                                  otherButtonTitles:@"OK", nil];
    // 基本输入框，显示实际输入的内容
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //设置输入框的键盘类型
    tf = [alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeNumberPad;

    turn =0;
    mBleDataBuffer=[[BleDataBuffer alloc]init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"b2.jpg"] ];


}


-(int)parse:(unichar)c{
    if (c >= 'a')
        return (c - 'a' + 10) & 0x0f;
    if (c >= 'A')
        return (c - 'A' + 10) & 0x0f;
    return (c - '0') & 0x0f;
    
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@">>>CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@">>>CBCentralManagerStatePoweredOn");
            //开始扫描周围的外设
            /*
             第一个参数nil就是扫描周围所有的外设，扫描到外设后会进入
             - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
             */
            [central scanForPeripheralsWithServices:nil options:nil];
            
            break;
        default:
            break;
    }
    
}

//扫描到设备会进入方法
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"当扫描到设备:%@",peripheral.name);
    //接下连接我们的测试设备，如果你没有设备，可以下载一个app叫lightbule的app去模拟一个设备
    //这里自己去设置下连接规则，我设置的是P开头的设备
//    if ([peripheral.name hasPrefix:@"P"]){
        /*
         一个主设备最多能连7个外设，每个外设最多只能给一个主设备连接,连接成功，失败，断开会进入各自的委托
         - (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;//连接外设成功的委托
         - (void)centra`lManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//外设连接失败的委托
         - (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//断开外设的委托
         */
  
        //找到的设备必须持有它，否则CBCentralManager中也不会保存peripheral，那么CBPeripheralDelegate中的方法也不会被调用！！
    
    if([peripheral.name isEqual:@"BleSeriaPort"]){
        [discoverPeripherals addObject:peripheral];
        mperipheral = peripheral;
        [central connectPeripheral:peripheral options:nil];
    }
}


//连接到Peripherals-失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
}

//Peripherals断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@">>>外设连接断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    
}
//连接到Peripherals-成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@">>>连接到名称为（%@）的设备-成功",peripheral.name);
    //设置的peripheral委托CBPeripheralDelegate
    //@interface ViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate>
    [peripheral setDelegate:self];
    //扫描外设Services，成功后会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    [peripheral discoverServices:nil];
    
}


//扫描到Services
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    //  NSLog(@">>>扫描到服务：%@",peripheral.services);
    if (error)
    {
        NSLog(@">>>Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    
    for (CBService *service in peripheral.services) {
        NSLog(@"%@",service.UUID);
        NSString *str =@"FFE0";
        if([service.UUID isEqual:[CBUUID UUIDWithString:str]]){
            NSLog(@"找到了服务了阿啊阿啊");
        }
        //扫描每个service的Characteristics，扫描到后会进入方法： -(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
        [peripheral discoverCharacteristics:nil forService:service];
    }
    
}

//扫描到Characteristics
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error)
    {
        NSLog(@"error Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"service:%@ 的 Characteristic: %@",service.UUID,characteristic.UUID);
        NSString *str =@"FFE1";
        if([characteristic.UUID isEqual:[CBUUID UUIDWithString:str]]){
            NSLog(@"找到了特征了阿啊阿啊");
            mcharacteristic=characteristic;
        }
    }
    
    //获取Characteristic的值，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    for (CBCharacteristic *characteristic in service.characteristics){
        {
            
            NSLog(@"Reading value ");
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
    
    //搜索Characteristic的Descriptors，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    for (CBCharacteristic *characteristic in service.characteristics){
        [peripheral discoverDescriptorsForCharacteristic:characteristic];
    }
    
    
}

//获取的charateristic的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"OBU有反应了啊啊啊啊啊");
    turn++;
    NSLog(@"trun%d",turn);
    //打印出characteristic的UUID和值
    //!注意，value的类型是NSData，具体开发时，会根据外设协议制定的方式去解析数据
    NSLog(@"characteristic uuid:%@  value:%@",characteristic.UUID,characteristic.value);
    
    //send1
    if(turn ==10){
        [alert show];
    }
    if(turn>10){
        NSData *data =[[NSData alloc]initWithData:characteristic.value];
        char *pt =(char*)[data bytes];
        int len =[data length];
        char des[len];
        for(int i =0;i<len;i++){
            des[i] = *pt;
            pt++;
        }
        [mBleDataBuffer receiveData:des length:len];
         if(1 ==[mBleDataBuffer readFrame]){
             [mBleDataBuffer getNoData];
             
             if(turn==21){
                 char *pt2=[mBleDataBuffer getData];
                 for(int i =0;i<18;i++){
                     use[i]=*pt2;
                     pt2++;
                 }
                 NSString *str =@"";
                 for(int i =0;i<18;i++){
                     NSString *newHexStr = [NSString stringWithFormat:@"%x",use[i]&0xff];
                     if(newHexStr.length ==1){
                         NSString *str0 =@"0";
                         newHexStr =[str0 stringByAppendingString:newHexStr];
                     }
                     str =[str stringByAppendingString:newHexStr];
                 }
                 NSLog(@"%@",str);
                 
                 
                 //加密
                 NSString *urlStr=[NSString stringWithFormat:@"http://172.20.10.4:8080/bookstores/servlet/test?data=%@&money=%@",str,money];
                 
                 //http://localhost:8080/bookstores/servlet/test?name=16EE0AB800328000
                 NSURL *url=[NSURL URLWithString:urlStr];
                 //    2.创建请求对象
                 NSURLRequest *request=[NSURLRequest requestWithURL:url];
                 //    3.发送请求
                 //发送同步请求，在主线程执行
                 NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                 //（一直在等待服务器返回数据，这行代码会卡住，如果服务器没有返回数据，那么在主线程UI会卡住不能继续执行操作）
                 NSLog(@"--%d--",data.length);
                 NSLog(@"response:%@", data);
                 
                 
                 //解析从服务器传来的加密后的指令
                 char *pt =(char*)[data bytes];
                 int len =[data length];
                 char des[len];
                 for(int i =0;i<len;i++){
                     des[i] = *pt;
                     des[i]=des[i]-48;
                     pt++;
                 }
                 NSString *mstr =@"";
                 for(int i =0;i<32;i++){
                     NSString *newHexStr = [NSString stringWithFormat:@"%x",des[i]&0xff];
                     if(newHexStr.length ==2){
                         //NSString *str0 =@"0";
                         //newHexStr =[str0 stringByAppendingString:newHexStr];
                         newHexStr =[newHexStr substringFromIndex:1];
                         if ([newHexStr isEqualToString:@"1"]){
                             newHexStr=@"a";
                         }
                         if ([newHexStr isEqualToString:@"2"]){
                             newHexStr=@"b";
                         }
                         if ([newHexStr isEqualToString:@"3"]){
                             newHexStr=@"c";
                         }
                         if ([newHexStr isEqualToString:@"4"]){
                             newHexStr=@"d";
                         }
                         if ([newHexStr isEqualToString:@"5"]){
                             newHexStr=@"e";
                         }
                         if ([newHexStr isEqualToString:@"6"]){
                             newHexStr=@"f";
                         }
                     }
                     
                     mstr =[mstr stringByAppendingString:newHexStr];
                 }
                 NSLog(@"%@",mstr);
                 
                 [self prepareAndSendFrame2:mstr num:72];

             }
             
         }
        
        if(turn==13){
            NSString *mstr =@"00a40000021001";
            [self prepareAndSendFrame1:mstr num:24];
        }
        if(turn==18){
            NSString *mstr =@"00200000021234";
            [self prepareAndSendFrame1:mstr num:40];
        }
        //send4
        //initload
        if(turn==19){
            //NSString *mstr =@"805000020B010000006411223344556610";
            //[self prepareAndSendFrame2:mstr num:56];
            
            int intString = [money intValue];
            intString =intString*100;
            NSString *newHexStr = [NSString stringWithFormat:@"%x",intString&0xffff];
            
            NSString *str0 =@"00000000";
            newHexStr =[str0 stringByAppendingString:newHexStr];
            
            int index =[newHexStr length]-8;
            money = [newHexStr substringFromIndex:index];
            
            NSString *initLoadCmd = @"805000020B01";
            initLoadCmd =[initLoadCmd stringByAppendingString:money];
            initLoadCmd =[initLoadCmd stringByAppendingString:@"11223344556610"];
            
            NSLog(@"%@",initLoadCmd);

            [self prepareAndSendFrame2:initLoadCmd num:56];
        }
        
        if(turn==22){
            [NSThread sleepForTimeInterval:0.1f];
            Session *session = [Session GetInstance];
            int intString = [money1 intValue];
   
            int newmoney =[session.money intValue]-intString;
            NSString *stringInt = [NSString stringWithFormat:@"%d",newmoney];
            session.money=stringInt;
            NSString *str = [[NSString alloc] initWithString:[NSString stringWithFormat:@"您的余额为%@",stringInt]];
            UIAlertView *alter1 = [[UIAlertView alloc] initWithTitle:@"圈存成功" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter1 show];
            MainViewController *vc = [[MainViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        
    }
    
    

}

//搜索到Characteristic的Descriptors
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    //打印出Characteristic和他的Descriptors
    NSLog(@"characteristic uuid:%@",characteristic.UUID);
    for (CBDescriptor *d in characteristic.descriptors) {
        NSLog(@"Descriptor uuid:%@",d.UUID);
    }
    
}
//获取到Descriptors的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
    //打印出DescriptorsUUID 和value
    //这个descriptor都是对于characteristic的描述，一般都是字符串，所以这里我们转换成字符串去解析
    NSLog(@"characteristic uuid:%@  value:%@",[NSString stringWithFormat:@"%@",descriptor.UUID],descriptor.value);

}

//写数据的回调函数
- (void)peripheral:(CBPeripheral*)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
   // NSLog(@"write value success : %@", characteristic);
    NSLog(@"write value success");
}




//写数据
-(void)writeCharacteristic:(CBPeripheral *)peripheral
            characteristic:(CBCharacteristic *)characteristic
                     value:(NSData *)value{
    
    //打印出 characteristic 的权限，可以看到有很多种，这是一个NS_OPTIONS，就是可以同时用于好几个值，常见的有read，write，notify，indicate，知知道这几个基本就够用了，前连个是读写权限，后两个都是通知，两种不同的通知方式。
    /*
     typedef NS_OPTIONS(NSUInteger, CBCharacteristicProperties) {
     CBCharacteristicPropertyBroadcast												= 0x01,
     CBCharacteristicPropertyRead													= 0x02,
     CBCharacteristicPropertyWriteWithoutResponse									= 0x04,
     CBCharacteristicPropertyWrite													= 0x08,
     CBCharacteristicPropertyNotify													= 0x10,
     CBCharacteristicPropertyIndicate												= 0x20,
     CBCharacteristicPropertyAuthenticatedSignedWrites								= 0x40,
     CBCharacteristicPropertyExtendedProperties										= 0x80,
     CBCharacteristicPropertyNotifyEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)		= 0x100,
     CBCharacteristicPropertyIndicateEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)	= 0x200
     };
     
     */
   // NSLog(@"%lu", (unsigned long)characteristic.properties);
    
    
    //只有 characteristic.properties 有write的权限才可以写
    if(characteristic.properties & CBCharacteristicPropertyWrite){
        /*
         最好一个type参数可以为CBCharacteristicWriteWithResponse或type:CBCharacteristicWriteWithResponse,区别是是否会有反馈
         */
        [peripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }else{
        NSLog(@"该字段不可写！");
    }
    
    
}

//设置通知
-(void)notifyCharacteristic:(CBPeripheral *)peripheral
             characteristic:(CBCharacteristic *)characteristic{
    //设置通知，数据通知会进入：didUpdateValueForCharacteristic方法
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    NSLog(@"开始监听");
    
}

//取消通知
-(void)cancelNotifyCharacteristic:(CBPeripheral *)peripheral
                   characteristic:(CBCharacteristic *)characteristic{
    
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
}

//停止扫描并断开连接
-(void)disconnectPeripheral:(CBCentralManager *)centralManager
                 peripheral:(CBPeripheral *)peripheral{
    //停止扫描
    [centralManager stopScan];
    //断开连接
    [centralManager cancelPeripheralConnection:peripheral];
    NSLog(@"SSSSSSS");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareAndSendFrame2:(NSString*)mstr num:(int)num{
    [mBleDataBuffer setSerialNumber:num];
    int length = [mstr length ]/ 2;
    char headBytes[3+length];
    char cmdBytes[[mstr length]/2];
    int j = 0;
    for (int i = 0; i < length; i++) {
        unsigned char  c0 = [mstr characterAtIndex:j++];
        c0=[self fixC:c0];
        unsigned char  c1 = [mstr characterAtIndex:j++];
        c1=[self fixC:c1];
        int k;
        if (c0 >= 'a')
            k = (c0 - 'a' + 10) & 0x0f;
        else if (c0 >= 'A')
            k = (c0 - 'A' + 10) & 0x0f;
        else
            k = (c0 - '0') & 0x0f;
        k =k<<4;
        int p;
        if (c0 >= 'a')
            p = (c1 - 'a' + 10) & 0x0f;
        else if (c1 >= 'A')
            p = (c1 - 'A' + 10) & 0x0f;
        else
            p = (c1 - '0') & 0x0f;
        int t =k|p;
        if(t>127)
            t=t-256;
        cmdBytes[i] = (char)t;
    }
    headBytes[0] = (char)0x02; //sub command type
    headBytes[1] = (char)0x01; //command number
    headBytes[2] = (char)(length); // command length
    for(int i =3,j=0;i<3+length;i++,j++){
        headBytes[i]=cmdBytes[j];
    }
    int cmdInts[3+length];
    for (int i = 0; i < 3 + length; i++) {
        cmdInts[i] = headBytes[i];
    }
    [mBleDataBuffer writeFrame:cmdInts length:3+length];
    char *kpt =[mBleDataBuffer convertIntsToBytes:[mBleDataBuffer getFrameData] length:[mBleDataBuffer getvalidDataLen]];
    int dLength=[mBleDataBuffer getvalidDataLen];
    char sendData[[mBleDataBuffer getvalidDataLen]];
    for(int i =0;i<[mBleDataBuffer getvalidDataLen];i++){
        sendData[i]=*kpt;
        kpt++;
    }
    [mBleDataBuffer setvalidDataLen:0];
    int packetNum = dLength / 20;
    int lastPacketBytesNum = dLength % 20;
    char tmpDataToSend[20];
    char lastPacket[lastPacketBytesNum];
    
    for(int i=0,j=dLength-lastPacketBytesNum;i<lastPacketBytesNum;i++,j++){
        lastPacket[i]=sendData[j];
        NSLog(@"%d",lastPacket[i]);
    }
    for(int i =0,j=i*20;i<20;i++,j++){
        tmpDataToSend[i]=sendData[j];
        NSLog(@"%d",tmpDataToSend[i]);
    }
    
    
    NSData *data7 = [[NSData alloc] initWithBytes:&tmpDataToSend length:20];
    NSLog(@"send5 data7:%@", data7);
    [self writeCharacteristic:mperipheral characteristic:mcharacteristic value:data7];
    
    [NSThread sleepForTimeInterval:0.02f];
    
    NSData *data8 = [[NSData alloc] initWithBytes:&lastPacket length:lastPacketBytesNum];
    NSLog(@"send5 data8:%@", data8);
    [self writeCharacteristic:mperipheral characteristic:mcharacteristic value:data8];
    
}

-(int)fixC:(unsigned char)c{
    if(c=='a'){
        return 65;
    }
    else if(c=='b'){
        return 66;
    }
    else if(c=='c'){
        return 67;
    }
    else if(c=='d'){
        return 68;
    }
    else if(c=='e'){
        return 69;
    }
    else if(c=='f'){
        return 70;
    }
    else
        return c;
}



-(void)prepareAndSendFrame1:(NSString*)mstr num:(int)num{
    [mBleDataBuffer setSerialNumber:num];
    int length = [mstr length ]/ 2;
    char headBytes[3+length];
    char cmdBytes[[mstr length]/2];
    int j = 0;
    for (int i = 0; i < length; i++) {
        unsigned char  c0 = [mstr characterAtIndex:j++];
        c0=[self fixC:c0];
        unsigned char  c1 = [mstr characterAtIndex:j++];
        c1=[self fixC:c1];
        int k;
        if (c0 >= 'a')
            k = (c0 - 'a' + 10) & 0x0f;
        else if (c0 >= 'A')
            k = (c0 - 'A' + 10) & 0x0f;
        else
            k = (c0 - '0') & 0x0f;
        k =k<<4;
        int p;
        if (c0 >= 'a')
            p = (c1 - 'a' + 10) & 0x0f;
        else if (c1 >= 'A')
            p = (c1 - 'A' + 10) & 0x0f;
        else
            p = (c1 - '0') & 0x0f;
        int t =k|p;
        if(t>127)
            t=t-256;
        cmdBytes[i] = (char)t;
    }
    headBytes[0] = (char)0x02; //sub command type
    headBytes[1] = (char)0x01; //command number
    headBytes[2] = (char)(length); // command length
    for(int i =3,j=0;i<3+length;i++,j++){
        headBytes[i]=cmdBytes[j];
    }
    int cmdInts[3+length];
    for (int i = 0; i < 3 + length; i++) {
        cmdInts[i] = headBytes[i];
    }
    [mBleDataBuffer writeFrame:cmdInts length:3+length];
    char *kpt =[mBleDataBuffer convertIntsToBytes:[mBleDataBuffer getFrameData] length:[mBleDataBuffer getvalidDataLen]];
    int dLength=[mBleDataBuffer getvalidDataLen];
    char sendData[[mBleDataBuffer getvalidDataLen]];
    for(int i =0;i<[mBleDataBuffer getvalidDataLen];i++){
        sendData[i]=*kpt;
        kpt++;
    }
    [mBleDataBuffer setvalidDataLen:0];
    int packetNum = dLength / 20;
    int lastPacketBytesNum = dLength % 20;
    char tmpDataToSend[20];
    char lastPacket[lastPacketBytesNum];
    
    for(int i=0,j=dLength-lastPacketBytesNum;i<lastPacketBytesNum;i++,j++){
        lastPacket[i]=sendData[j];
        //NSLog(@"%d",lastPacket[i]);
    }
    for(int i =0,j=i*20;i<20;i++,j++){
        tmpDataToSend[i]=sendData[j];
        //NSLog(@"%d",tmpDataToSend[i]);
    }
    
    NSData *data8 = [[NSData alloc] initWithBytes:&lastPacket length:lastPacketBytesNum];
    NSLog(@"send5 data8:%@", data8);
    [self writeCharacteristic:mperipheral characteristic:mcharacteristic value:data8];
    
}




@end
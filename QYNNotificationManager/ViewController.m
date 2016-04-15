//
//  ViewController.m
//  QYNNotificationManager
//
//  Created by qiyun on 16/4/11.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    PDFCalibrationMagnetismView     *cmView;
    PDFSteeringWheel                *steeringWheelView;
    PDFVideoScreenView              *_videoSView;
    UILabel                         *_label;
    NSDate                          *currentDate;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
#if 0
    cmView = [[PDFCalibrationMagnetismView alloc] initWithFrame:CGRectZero];
    cmView.title = @"请远离金属或带磁、带电物体，并使飞行器离地1.5米左右的距离";
    cmView.cmType = PDLCalibrationMagnetism_default;
    [self.view addSubview:cmView];
    
#elif 1
    
    _videoSView = [[PDFVideoScreenView alloc] initWithFrame:CGRectZero titles:@"相机",@"云台", nil];
    [self.view addSubview:_videoSView];
    
#else
    
    steeringWheelView = [[PDFSteeringWheel alloc] initWithFrame:CGRectMake(200, 200, 200, 140) backGroundColor:[UIColor blackColor]];
    [self.view addSubview:steeringWheelView];
  
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor redColor];
    _label.text = @"00:00:00";
    [self.view addSubview:_label];
    

    currentDate = [NSDate date];
    /*
    NSMethodSignature *sgn = [self methodSignatureForSelector:@selector(onTick:)];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature: sgn];
    [inv setTarget: self];
    [inv setSelector:@selector(onTick:)];
    
    NSTimer *t = [NSTimer timerWithTimeInterval: 1.0
                                     invocation:inv
                                        repeats:YES];
    //and after that, you start the timer manually whenever you need like this:
    
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: t forMode: NSDefaultRunLoopMode];
     */
    
    //dateWithTimeIntervalSinceNow: 60.0
    NSDate *d = [NSDate dateWithTimeIntervalSinceNow: 1.0];
    NSTimer *t = [[NSTimer alloc] initWithFireDate: d
                                          interval: 1
                                            target: self
                                          selector:@selector(onTick:)
                                          userInfo:nil
                                           repeats:YES];
    
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:t forMode: NSDefaultRunLoopMode];
    
#endif

}

-(void)onTick:(NSTimer *)timer {
    
    //do something
    //NSLog(@"%@",timer.fireDate);
    
    _label.text = [self timeFormatted:[timer.fireDate timeIntervalSinceDate:currentDate]];
    //NSLog(@"间隔 %@",[self timeFormatted:[timer.fireDate timeIntervalSinceDate:currentDate]]);
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    cmView.frame = self.view.bounds;
    
    steeringWheelView.center = self.view.center;
    
    _label.center = self.view.center;
    _label.frame = CGRectOffset(steeringWheelView.frame, 0, 100);
    
    {
        _videoSView.frame = CGRectMake((self.view.bounds.size.width * 0.62), (self.view.bounds.size.height * 0.15), (self.view.bounds.size.width * 0.25), (self.view.bounds.size.height * 0.7));
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
}

@end

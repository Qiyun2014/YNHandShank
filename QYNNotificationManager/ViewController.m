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
    PDFSteeringWheel    *steeringWheelView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    steeringWheelView = [[PDFSteeringWheel alloc] initWithFrame:CGRectMake(200, 200, 200, 140) backGroundColor:[UIColor blackColor]];
    steeringWheelView.center = self.view.center;
    [self.view addSubview:steeringWheelView];
    
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    steeringWheelView.center = self.view.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
}

@end

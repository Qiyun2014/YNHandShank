//
//  PDFSteeringWheel.h
//  QYNNotificationManager
//
//  Created by qiyun on 16/4/13.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PDFStreeingWheelOfDirection)  {
    
    PDFSteeringWheelDirection_default = 0,
    PDFSteeringWheelDirection_left,
    PDFSteeringWheelDirection_right,
    PDFSteeringWheelDirection_up,
    PDFSteeringWheelDirection_down
};

@interface PDFSteeringWheel : UIView<UIGestureRecognizerDelegate>{
    
    @public
    CGRect      aFrame;         //  范围
    float       moveSpeed;      //  移动速度(0.0--1.0)
    UIImageView *imageView;     //  底图
    UIImage     *dirImage;      //  方位图片
    
    @private
    UIImageView *handShankImageView; //手柄
    UIDynamicAnimator *animator;     //物理仿真行为
}


@property (nonatomic)PDFStreeingWheelOfDirection moveDirection;



- (id)initWithFrame:(CGRect)frame backGroundColor:(UIColor *)color;



/**
 *  比较当前点相对于起点的位置
 *
 *  @param poinx      其实位置，参照点
 *  @param otherPoint 用来比较的位置
 *
 *  @return 方位
 */
- (PDFStreeingWheelOfDirection)compareStartPoint:(CGPoint)poinx otherPoint:(CGPoint)otherPoint;



@end

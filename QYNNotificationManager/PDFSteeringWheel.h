//
//  PDFSteeringWheel.h
//  QYNNotificationManager
//
//  Created by qiyun on 16/4/13.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFLayoutDefine.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PDFStreeingDirection)  {
    
    PDFSteeringWheelDirection_default = 0,
    PDFSteeringWheelDirection_left,
    PDFSteeringWheelDirection_right,
    PDFSteeringWheelDirection_up,
    PDFSteeringWheelDirection_down
};


typedef NS_OPTIONS(NSInteger, PDFRollSetting) {
    
    PDFRollSettingNone = 0,
    PDFRollSettingIncrease,
    PDFRollSettingDecrease
};

@protocol PDFDirectionDelegate <NSObject>

/**
 *  手指拖动摇杆的方向
 *  @brief speed:移动速度（0-1）
 *  @param direction 定义一个协议，将手势的属性进行穿透性反馈
 */
- (void)dragDirection:(PDFStreeingDirection)direction speed:(CGFloat)speed;

@end

@class PDFRollView;
@protocol PDFRollDelegate <NSObject>

/**
 *  @discussion rool轴的调整
 *
 *  @param setting 增加或减小
 */
- (void)rollControl:(PDFRollSetting)setting rollView:(PDFRollView *)rollView;

@end


/* -------------------------------------------------------------------------------------------- */

#pragma mark -  /* 云台、相机调整 */

NS_CLASS_AVAILABLE_IOS(7_0)
@interface PDFSteeringWheelView : UIView<PDFDirectionDelegate,PDFRollDelegate>

/**
 *  初始化视图PDFSteeringWheelView
 *
 *  @param frame  显示位置
 *  @param fTitle 第一个按钮的文字
 *  @param oTitle 第二个按钮的文字
 *
 *  @return PDFSteeringWheelView
 */
- (id)initWithFrame:(CGRect)frame firstItemTitle:(NSString *)fTitle otherItemTitle:(NSString *)oTitle sectionTitles:(NSArray *)sectionTitles;


//设置云台ROLL轴的显示值
@property (nonatomic) CGFloat   cradleHeadValue;

//栏目的标题
@property (nonatomic,strong,readonly) NSArray *sectionTitles;

@end



#pragma mark -      /* 摇杆 */


NS_CLASS_AVAILABLE_IOS(7_0)
@interface PDFSteeringWheel : UIView<UIGestureRecognizerDelegate>


@property (nonatomic)PDFStreeingDirection moveDirection;
@property (nonatomic,weak,nullable) id <PDFDirectionDelegate> delegate;


/**
 *  初始化
 *
 *  @param frame 设定指定位置
 *  @param color 前景色
 *
 *  @return PDFSteeringWheel
 */
- (id)initWithFrame:(CGRect)frame backGroundColor:(UIColor *)color;


/**
 *  比较当前点相对于起点的位置
 *
 *  @param poinx      其实位置，参照点
 *  @param otherPoint 用来比较的位置
 *
 *  @return 方位
 */
- (PDFStreeingDirection)compareStartPoint:(CGPoint)poinx otherPoint:(CGPoint)otherPoint;

@end



#pragma mark -      /* 云台ROLL轴 */

@interface PDFRollView : UIView

@property (nonatomic,weak,nullable) id <PDFRollDelegate> delegate;
@property (nonatomic) CGFloat   rollValue;

@end

NS_ASSUME_NONNULL_END

//
//  PDFCalibrationMagnetismView.h
//  QYNNotificationManager
//
//  Created by qiyun on 16/4/14.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFLayoutDefine.h"

typedef NS_ENUM(NSInteger, PDLCalibrationMagnetismType) {
    
    PDLCalibrationMagnetism_default = 0,        //默认状态
    PDLCalibrationMagnetism_faild,              //失败
    PDLCalibrationMagnetism_misalignment,       //有偏差
    PDLCalibrationMagnetism_success             //成功
};


@interface PDFCalibrationMagnetismView : UIView


@property (nonatomic) PDLCalibrationMagnetismType   cmType;

@property (nonatomic, copy) NSString    *title;         //标题
@property (nonatomic, copy) NSString    *detailTitle;   //内容
@property (nonatomic, copy) NSString    *presentation;  //提示


/**
 *  重新校准
 */
- (void)tryAgain;


@end

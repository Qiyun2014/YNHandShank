//
//  PDLImageNames.h
//  QYNNotificationManager
//
//  Created by qiyun on 16/4/18.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#ifndef PDFLayoutDefine_h
#define PDFLayoutDefine_h


#pragma mark - /* 摇杆图片 */
    #define KPDFDirection_bgImage @"摇杆方位_@3x"
    #define KPDFDirection_hdShank @"摇杆_@3x"



#pragma mark - /* 设备（ipad、iPhone） */
    #define Iphone  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)



#pragma mark - /* 文字字体大小（ipad、iPhone） */

    #define KPDLTitleAdding 8
    #define KPDLTitleHeightAdding 20

    #define KPDL_title_font_most    (Iphone?30:(30 + KPDLTitleAdding))
    #define KPDL_title_font_big     (Iphone?21:(21 + KPDLTitleAdding))
    #define KPDL_title_font_biggish (Iphone?19:(19 + KPDLTitleAdding))
    #define KPDL_title_font_default (Iphone?17:(17 + KPDLTitleAdding))
    #define KPDL_title_font_less    (Iphone?15:(15 + KPDLTitleAdding))
    #define KPDL_title_font_small   (Iphone?13:(13 + KPDLTitleAdding))




#pragma mark - /* Label高度（ipad、iPhone） */

    #define KPDL_label_height_big       (Iphone?60:(60 + KPDLTitleHeightAdding))
    #define KPDL_label_height_biggish   (Iphone?50:(50 + KPDLTitleHeightAdding))
    #define KPDL_label_height_default   (Iphone?40:(40 + KPDLTitleHeightAdding))
    #define KPDL_label_height_less      (Iphone?30:(30 + KPDLTitleHeightAdding))
    #define KPDL_label_height_smaller   (Iphone?25:(25 + KPDLTitleHeightAdding))
    #define KPDL_label_height_small     (Iphone?20:(20 + KPDLTitleHeightAdding))
    #define KPDL_label_height_lesser    (Iphone?10:(10 + KPDLTitleHeightAdding))


#pragma mark - /* 视图高度（ipad、iPhone） */

#define KCurrentView_Height_(UIView) (UIView.bounds.size.height)
#define KCurrentView_width_(UIView) (UIView.bounds.size.width)

#endif /* PDFLayoutDefine_h */

//
//  PDLVideoScreenView.h
//  QYNNotificationManager
//
//  Created by qiyun on 16/4/15.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFVideoScreenView : UIView

/**
 *  初始化控件
 *
 *  @param frame  设定显示范围
 *  @param titles 显示的标题文本,最多支持5个
 *
 */
- (id)initWithFrame:(CGRect)frame titles:(NSString *)titles, ... NS_REQUIRES_NIL_TERMINATION;


@property (nonatomic, strong)   UITableView         *aTableView;
@property (nonatomic, strong)   UICollectionView    *aCollectionView;


//标题数组
@property (nonatomic, readonly) NSArray             *titles;

//多个元素
@property (nonatomic, strong)   NSArray             *itemTitles;

//每项内的子元素🐘 --> @[@[],@[]]
@property (nonatomic, strong)   NSArray             *eleTitles;


@end

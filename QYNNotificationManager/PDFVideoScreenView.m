//
//  PDLVideoScreenView.m
//  QYNNotificationManager
//
//  Created by qiyun on 16/4/15.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import "PDFVideoScreenView.h"

@interface PDFVideoScreenView ()<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *mulTitles;
        
}

@end

@implementation PDFVideoScreenView

- (id)initWithFrame:(CGRect)frame titles:(NSString *)titles, ... NS_REQUIRES_NIL_TERMINATION{
    
    if (self = [super initWithFrame:frame]){
        
        self.frame = frame;
        
        va_list args;
        va_start(args, titles);
        mulTitles = [[NSMutableArray alloc] initWithCapacity:5];
        for (NSString *str = titles; str != nil; str = va_arg(args,NSString *)) {
            [mulTitles addObject:str];
        }
        va_end(args);
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    
}


#pragma mark    -   get method

- (UITableView *)aTableView{
    
    if (!_aTableView) {
        
        self.aTableView = [[UITableView alloc] initWithFrame:CGRectOffset(self.frame, 0, 40) style:UITableViewStyleGrouped];
        self.aTableView.delegate = self;
        self.aTableView.dataSource = self;
        self.aTableView.tableFooterView = [UIView new];
    }
    
    return self.aTableView;
}

- (NSArray *)titles{
    
    return mulTitles;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

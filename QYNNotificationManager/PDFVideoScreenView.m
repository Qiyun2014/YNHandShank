//
//  PDLVideoScreenView.m
//  QYNNotificationManager
//
//  Created by qiyun on 16/4/15.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import "PDFVideoScreenView.h"

@interface PDFVideoScreenView ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

{
    NSMutableArray *mulTitles;
}

@end

@implementation PDFVideoScreenView

- (id)initWithFrame:(CGRect)frame titles:(NSString *)titles, ... NS_REQUIRES_NIL_TERMINATION{
    
    if (self = [super initWithFrame:frame]){
        
        self.frame = frame;
        self.backgroundColor = [UIColor blackColor];

        va_list args;
        va_start(args, titles);
        mulTitles = [[NSMutableArray alloc] initWithCapacity:5];
        for (NSString *str = titles; str != nil; str = va_arg(args,NSString *)) {
            [mulTitles addObject:str];
        }
        va_end(args);
        
        [self addSubview:self.aCollectionView];
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


- (UICollectionView *)aCollectionView{
    
    if (!_aCollectionView) {
        
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

        self.aCollectionView = [[UICollectionView alloc] initWithFrame:CGRectOffset(self.frame, 0, 40) collectionViewLayout:flowLayout];
        self.aCollectionView.dataSource = self;
        self.aCollectionView.delegate = self;
        [self.aCollectionView setBackgroundColor:[UIColor whiteColor]];
        [self.aCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    
    return self.aCollectionView;
}

- (NSArray *)titles{
    
    return mulTitles;
}



#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    label.textColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    [cell.contentView addSubview:label];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 60);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //临时改变个颜色，看好，只是临时改变的。如果要永久改变，可以先改数据源，然后在cellForItemAtIndexPath中控制。（和UITableView差不多吧！O(∩_∩)O~）
    cell.backgroundColor = [UIColor greenColor];
    NSLog(@"item======%ld",(long)indexPath.item);
    NSLog(@"row=======%ld",(long)indexPath.row);
    NSLog(@"section===%ld",(long)indexPath.section);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

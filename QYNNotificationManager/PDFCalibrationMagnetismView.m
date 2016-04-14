//
//  PDFCalibrationMagnetismView.m
//  QYNNotificationManager
//
//  Created by qiyun on 16/4/14.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import "PDFCalibrationMagnetismView.h"
#import <objc/runtime.h>

@interface PDFCalibrationMagnetismView ()

@property (nonatomic) CGRect aFrame;

@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel   *detailLabel;
@property (nonatomic, strong) UILabel   *preLabel;
@property (nonatomic, strong) UIButton  *tryAgainButton;

@end


@implementation PDFCalibrationMagnetismView

#define Iphone  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define KPDLTitleAdding 8
#define KPDLTitleHeightAdding 20

#define KPDL_title_font_big     (Iphone?21:(21 + KPDLTitleAdding))
#define KPDL_title_font_biggish (Iphone?19:(19 + KPDLTitleAdding))
#define KPDL_title_font_default (Iphone?17:(17 + KPDLTitleAdding))
#define KPDL_title_font_less    (Iphone?15:(15 + KPDLTitleAdding))
#define KPDL_title_font_small   (Iphone?13:(13 + KPDLTitleAdding))

#define KPDL_label_height_big       (Iphone?60:(60 + KPDLTitleHeightAdding))
#define KPDL_label_height_biggish   (Iphone?50:(50 + KPDLTitleHeightAdding))
#define KPDL_label_height_default   (Iphone?40:(40 + KPDLTitleHeightAdding))
#define KPDL_label_height_less      (Iphone?30:(30 + KPDLTitleHeightAdding))
#define KPDL_label_height_small     (Iphone?20:(20 + KPDLTitleHeightAdding))



- (id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.aFrame = frame;
        self.frame = frame;
        self.backgroundColor = [UIColor blackColor];
        
        NSLog(@"%d",(int)KPDL_title_font_less);
        
        _titleLabel     = [PDFCalibrationMagnetismView pdf_createLabelWithFrame:CGRectZero font:[UIFont boldSystemFontOfSize:KPDL_title_font_less]];
        _detailLabel    = [PDFCalibrationMagnetismView pdf_createLabelWithFrame:CGRectZero font:[UIFont boldSystemFontOfSize:KPDL_title_font_small]];
        _preLabel       = [PDFCalibrationMagnetismView pdf_createLabelWithFrame:CGRectZero font:[UIFont boldSystemFontOfSize:KPDL_title_font_small]];
        _preLabel.textColor = [UIColor orangeColor];

        [self addSubview:_titleLabel];
        [self addSubview:_detailLabel];
        [self addSubview:_preLabel];
        [self addSubview:self.tryAgainButton];
    }
    return self;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat dil = 20;
    
    _titleLabel.frame = CGRectMake(dil, 20, self.bounds.size.width - dil*2, KPDL_label_height_default);
    CGRect frame = _titleLabel.frame;
    frame.size.height = [PDFCalibrationMagnetismView width:_titleLabel.text font:[UIFont boldSystemFontOfSize:KPDL_title_font_less]].height;
    _titleLabel.frame = frame;
    
    _detailLabel.frame = CGRectOffset(_titleLabel.frame, 0, _titleLabel.frame.size.height + 10);
    frame = _detailLabel.frame;
    frame.size.height = [PDFCalibrationMagnetismView width:_detailLabel.text font:[UIFont boldSystemFontOfSize:KPDL_title_font_small]].height;
    _detailLabel.frame = frame;
    
    _preLabel.frame = CGRectMake(self.bounds.size.width/2 - 50, self.bounds.size.height - 100, 100, KPDL_label_height_less);
    [_tryAgainButton setFrame:CGRectOffset(_preLabel.frame, 0, _preLabel.bounds.size.height + 10)];
}


#pragma mark    -   private func

- (void)tryAgain{
    
    
}


- (UIButton *)tryAgainButton{
    
    if (!_tryAgainButton) {
        
        _tryAgainButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_tryAgainButton setTitle:@"重新校准" forState:UIControlStateNormal];
        [_tryAgainButton setTintColor:[UIColor whiteColor]];
        _tryAgainButton.layer.borderWidth = 1.0f;
        _tryAgainButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [_tryAgainButton addTarget:self action:@selector(tryAgainButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _tryAgainButton;
}

#pragma mark    -   factory func

+ (CGSize)width:(NSString *)str font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake([[UIApplication sharedApplication] keyWindow].bounds.size.width, CGFLOAT_MAX)
                                    options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                 attributes:attribute
                                    context:nil].size;
    
    return size;
}


+ (UILabel *)pdf_createLabelWithFrame:(CGRect)frame font:(UIFont *)font{
    
    UILabel *label      = [[UILabel alloc] initWithFrame:frame];
    label.font          = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor     = [UIColor whiteColor];
    label.numberOfLines = 0;
    return label;
}


#pragma mark    -   set/get func

- (void)setCmType:(PDLCalibrationMagnetismType)cmType{
    
    switch (cmType) {
        
        case PDLCalibrationMagnetism_default:
        {
            self.presentation = @"校准中";
            [_tryAgainButton removeFromSuperview];
        }
            
        case PDLCalibrationMagnetism_faild:
        case PDLCalibrationMagnetism_misalignment:
        {
            self.detailTitle = @"STEP1  请按照图像显示，水平选择飞行器";
            self.detailTitle = @"STEP2  请按照图像显示，竖直旋转飞行器";
            self.presentation = @"校准失败";
            
            [_tryAgainButton removeFromSuperview];
        }
            break;
            
        case PDLCalibrationMagnetism_success:
        {
            self.presentation = @"校准成功";
            [self addSubview:self.tryAgainButton];
        }
            
        default:
            break;
    }
}


- (void)setTitle:(NSString *)title{
    
    _titleLabel.text = title;
}


- (void)setDetailTitle:(NSString *)detailTitle{
    
    _detailLabel.text = detailTitle;
}


- (void)setPresentation:(NSString *)presentation{
    
    _preLabel.text = presentation;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

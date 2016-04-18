//
//  PDFSteeringWheel.m
//  QYNNotificationManager
//
//  Created by qiyun on 16/4/13.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import "PDFSteeringWheel.h"

@interface PDFSteeringWheelView()

@property (nonatomic, strong) PDFSteeringWheel  *steWheel;
@property (nonatomic, strong) PDFRollView       *rollView;
@property (nonatomic, copy)   NSArray *titles;

@end

@implementation PDFSteeringWheelView{
    
    /* 方位，ROLL */
    UILabel  *subTitles[2];
    
    /* 相机，云台 */
    UIButton *buttons[2];
}

- (id)initWithFrame:(CGRect)frame firstItemTitle:(NSString *)fTitle otherItemTitle:(NSString *)oTitle sectionTitles:(NSArray *)sectionTitles{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        self.frame = frame;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 4;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.masksToBounds = YES;
        
        _titles = [NSArray arrayWithObjects:fTitle,oTitle, nil];
        _sectionTitles = [sectionTitles copy];
        [self loadView];
    }
    return self;
}

- (void)loadView{
    
    [_titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        buttons[idx] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buttons[idx] setTitle:obj forState:UIControlStateNormal];
        [buttons[idx] setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [buttons[idx] titleLabel].font = [UIFont systemFontOfSize:KPDL_title_font_less];
        [buttons[idx] setTitleColor:(idx==1)?[UIColor lightGrayColor]:[UIColor orangeColor] forState:UIControlStateNormal];
    
        [buttons[idx] addTarget:self action:@selector(transitionAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttons[idx]];
    }];
    
    _steWheel = [[PDFSteeringWheel alloc] initWithFrame:CGRectZero backGroundColor:[UIColor clearColor]];
    _rollView = [[PDFRollView alloc] initWithFrame:CGRectZero];
    _rollView.backgroundColor       = [UIColor clearColor];
    _rollView.delegate = self;
    _steWheel.delegate = self;
    [self addSubview:_steWheel];
    [self addSubview:_rollView];
    
    if (!self.sectionTitles.count && self.sectionTitles.count < 2) return;
    
    /* 相机，云台 */
    [self.sectionTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        subTitles[idx] = [[UILabel alloc] init];
        subTitles[idx].text             = obj;
        subTitles[idx].textAlignment    = NSTextAlignmentLeft;
        subTitles[idx].textColor        = [UIColor whiteColor];
        subTitles[idx].font             = [UIFont boldSystemFontOfSize:KPDL_title_font_small];
        [self addSubview:subTitles[idx]];
    }];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    _steWheel.frame = CGRectMake(0, KCurrentView_Height_(self)*0.28, KCurrentView_width_(self), KCurrentView_Height_(self)*0.4);
    _rollView.frame = CGRectMake(0, KCurrentView_Height_(self)*0.83, KCurrentView_width_(self), KCurrentView_Height_(self)*0.17);
    
    
    /* 切换按钮 */
    [_titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        CGFloat wid = [PDFSteeringWheelView width:obj font:[UIFont systemFontOfSize:KPDL_title_font_less]].width;
        buttons[idx].frame = CGRectMake(idx==0?(KCurrentView_width_(self)/2 - wid - 10):10 + KCurrentView_width_(self)/2, KPDL_label_height_lesser, wid, 20);
    }];
    
    
    /* 相机，云台位置布局 */
    [self.sectionTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        CGRect rect = CGRectOffset(((idx == 0)?_steWheel:_rollView).frame, 15, -KPDL_label_height_less);
        rect.size.height = KPDL_label_height_small;
        subTitles[idx].frame = rect;
    }];
}

/**
 *  切换设置(相机，云台)
 */
- (void)transitionAction:(UIButton *)sender{
    
    if ([sender isEqual:buttons[0]]) {  //相机
        
        [buttons[0] setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [buttons[1] setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
    }else{  //云台
        
        [buttons[1] setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [buttons[0] setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}


#pragma mark    -   delegate

- (void)dragDirection:(PDFStreeingDirection)direction speed:(CGFloat)speed{
    
    switch (direction) {
            
        case PDFSteeringWheelDirection_down:
            NSLog(@"下  速度:%f",speed);
            break;
            
        case PDFSteeringWheelDirection_left:
            NSLog(@"左  速度:%f",speed);
            break;
            
        case PDFSteeringWheelDirection_right:
            NSLog(@"右  速度:%f",speed);
            break;
            
        case PDFSteeringWheelDirection_up:
            NSLog(@"上  速度:%f",speed);
            break;
            
        default:
            NSLog(@"默认。。。");
            break;
    }
}

- (void)rollControl:(PDFRollSetting)setting rollView:(PDFRollView *)rollView{
    
    NSLog(@"******  %f",rollView.rollValue);
}


+ (CGSize)width:(NSString *)str font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake([[UIApplication sharedApplication] keyWindow].bounds.size.width, CGFLOAT_MAX)
                                    options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                 attributes:attribute
                                    context:nil].size;
    
    return size;
}


@end


#pragma mark    -   Steering Wheel


@implementation PDFSteeringWheel{
    
@public
    float       moveSpeed;      //  移动速度(0.0--1.0)
    UIImageView *imageView;     //  底图
    UIImage     *dirImage;      //  方位图片
    
@private
    UIImageView *handShankImageView; //手柄
    UIDynamicAnimator *animator;     //物理仿真行为
}


#pragma mark    -   layout subviews

- (id)initWithFrame:(CGRect)frame backGroundColor:(UIColor *)color{
    
    if (self = [super initWithFrame:frame]) {
        
        self->dirImage = [UIImage imageWithData:UIImagePNGRepresentation([UIImage imageNamed:KPDFDirection_bgImage]) scale:0.3];
        self.frame = frame;
        self.backgroundColor = color;
        
        [self addSubview:[self directionImageView]];
        [self addSubview:[self handShankImageView]];
        
        self->animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
    }
    return self;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat origin_x = (self.bounds.size.width - self->imageView.bounds.size.width)/2;
    CGFloat origin_y = (self.bounds.size.height - self->imageView.bounds.size.height)/2;
    
    CGRect rect = self.frame;
    rect.origin = CGPointMake(origin_x, origin_y);
    self->imageView.frame = rect;

    //CGRect rect2 = CGRectMake(0, 0, rect.size.height/2.5, rect.size.height/2.5);
    CGRect rect2 = CGRectInset(rect,rect.size.width/5,rect.size.width/5);
    
    self->handShankImageView.frame = rect2;
    self->handShankImageView.center = self->imageView.center;
}


#pragma mark    -   private method

- (PDFStreeingDirection)compareStartPoint:(CGPoint)poinx otherPoint:(CGPoint)otherPoint{
    
    //NSLog(@"**************%@**************",NSStringFromCGPoint(self->imageView.center));
    //NSLog(@"斜长  %f",hypot(self.bounds.size.width,self.bounds.size.height));
    
    //横纵轴标的比例
    float persent = self.bounds.size.width/self.bounds.size.height;
    
    if ((otherPoint.y > otherPoint.x / persent) && (self.bounds.size.width - otherPoint.x) / persent < otherPoint.y) {
        
        self->moveSpeed = (otherPoint.y - poinx.y)/(self.bounds.size.height/2);
        return PDFSteeringWheelDirection_down;
    }
    
    else if ((otherPoint.y < otherPoint.x / persent) && (self.bounds.size.width - otherPoint.x) / persent > otherPoint.y){
        
        self->moveSpeed = (poinx.y - otherPoint.y)/(self.bounds.size.height/2);
        return PDFSteeringWheelDirection_up;
    }
    
    else if ((otherPoint.y > otherPoint.x / persent) && (self.bounds.size.width - otherPoint.x) / persent > otherPoint.y){
        
        self->moveSpeed = (poinx.x - otherPoint.x)/(self.bounds.size.width/2);
        return PDFSteeringWheelDirection_left;
    }
    
    else if ((otherPoint.y < otherPoint.x / persent) && (self.bounds.size.width - otherPoint.x) / persent < otherPoint.y){
        
        self->moveSpeed = (otherPoint.x - poinx.x)/(self.bounds.size.width/2);
        return PDFSteeringWheelDirection_right;
        
    }else return PDFSteeringWheelDirection_default; //两个方向交界处
}


- (UIImageView *)directionImageView{
    
    self->imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self->imageView setImage:self->dirImage];
    [self->imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    return self->imageView;
}

- (UIImageView *)handShankImageView{
    
    self->handShankImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self->handShankImageView.image = [UIImage imageNamed:KPDFDirection_hdShank];
    [self->handShankImageView setUserInteractionEnabled:YES];
    [self->handShankImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self->handShankImageView setClipsToBounds:YES];
    
    //UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    //panGesture.delegate = self;
    //[self->handShankImageView addGestureRecognizer:panGesture];
    
    return self->handShankImageView;
}

#pragma mark    -   set/get


- (void)setMoveDirection:(PDFStreeingDirection)moveDirection{
    
    //self.moveDirection = moveDirection;
    
    if ([self.delegate respondsToSelector:@selector(dragDirection:speed:)]) {
        [self.delegate dragDirection:moveDirection speed:self->moveSpeed];
    }
}


#pragma mark    -   Gesture delegate


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    
    //创建碰撞行为
    //UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self->imageView,self->handShankImageView]];
    
    //设置碰撞边界，不设置就会飞出屏幕，设置就会在屏幕边框处产生碰撞效果
    //collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    //[collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    CGPoint point = [[touches allObjects].lastObject locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, point)) {
        
       //NSLog(@"point = %@",NSStringFromCGPoint(point));
        
        self->handShankImageView.center = point;
        
        self.moveDirection = [self compareStartPoint:self->imageView.center otherPoint:point];
    }
    
    //[self->animator removeAllBehaviors];
    //[self->animator addBehavior:collisionBehavior];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self->handShankImageView.center = self->imageView.center;
    
    /*
    UISnapBehavior *snap = [[UISnapBehavior alloc]initWithItem:self->handShankImageView
                                                   snapToPoint:CGPointApplyAffineTransform(self->handShankImageView.center, CGAffineTransformMakeRotation(M_PI_2))];
    snap.damping = 0.2;

    [self->animator removeAllBehaviors];
    [self->animator addBehavior:snap];
    */
    
    NSInteger angle = random()%30;
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.4
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self->handShankImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI/2), angle, angle);
                         
                     } completion:^(BOOL finished){
                         
                         self->handShankImageView.center = self->imageView.center;
                     }];
}

/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    CGPoint point = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, point)) {
        
        NSLog(@"point = %@",NSStringFromCGPoint(point));
        
        self->handShankImageView.center = point;
    }
    
    return YES;
}
*/



- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan{
    
    NSLog(@"pan ...");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

#pragma mark    -   Roll View


@interface PDFRollView ()

@property (nonatomic,strong) UIButton   *increaseButton;
@property (nonatomic,strong) UIButton   *decreaseButton;
@property (nonatomic,strong) UILabel    *valueLabel;

@end

#define KAttribute_button_(button)\
button = [UIButton buttonWithType:UIButtonTypeRoundedRect];\
[button addTarget:self action:@selector(sender:)\
 forControlEvents:UIControlEventTouchUpInside];\
[button titleLabel].font = [UIFont boldSystemFontOfSize:KPDL_title_font_most];\
[button setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];\
[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];\
[button layer].borderWidth = 1;\
[button layer].borderColor = [[UIColor whiteColor] CGColor];\


@implementation PDFRollView{
    
    CGFloat width,height;
}

- (id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.frame = frame;
        
        [self addSubview:self.valueLabel];
        [self addSubview:self.increaseButton];
        [self addSubview:self.decreaseButton];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    width = self.bounds.size.width;
    height = self.bounds.size.height;
    
    CGFloat space = KPDL_label_height_small;
    self.valueLabel.frame = CGRectMake((width/2 - space), (height - KPDL_label_height_smaller)/2.7, space * 2, KPDL_label_height_smaller);
    
    self.increaseButton.frame = CGRectOffset(self.valueLabel.frame, -(width/4), 0);;
    self.decreaseButton.frame = CGRectOffset(self.valueLabel.frame, (width/4), 0);
}

/* 点击增加或减少的相应事件 */
- (void)sender:(UIButton *)sender{
    
    if (sender.tag == 77)   self.rollValue += 1;
    else    self.rollValue -= 1;
    
    if ([self.delegate respondsToSelector:@selector(rollControl:rollView:)]) {
        [self.delegate rollControl:(sender.tag==77)?PDFRollSettingIncrease:PDFRollSettingDecrease rollView:self];
    }
}

/* RollValue的set方法 */
- (void)setRollValue:(CGFloat)rollValue{
    
    self.valueLabel.text = [NSString stringWithFormat:@"%.0f",rollValue];
    _rollValue = rollValue;
}


#pragma mark    -   get method

- (UILabel *)valueLabel{
    
    if (!_valueLabel) {
        
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.valueLabel.textAlignment = NSTextAlignmentCenter;
        self.rollValue = 0;
        self.valueLabel.font = [UIFont systemFontOfSize:KPDL_title_font_less];
        self.valueLabel.textColor = [UIColor whiteColor];
    }
    return _valueLabel;
}

- (UIButton *)increaseButton{
    
    if (!_increaseButton){
    
        KAttribute_button_(self.increaseButton);
        [self.increaseButton setTitle:@"-" forState:UIControlStateNormal];
    }
    return _increaseButton;
}

- (UIButton *)decreaseButton{
    
    if (_increaseButton && !_decreaseButton) {
        
        //NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject: self.increaseButton];
        //self.decreaseButton = [NSKeyedUnarchiver unarchiveObjectWithData: archivedData];
        KAttribute_button_(self.decreaseButton);
        [self.decreaseButton setTitle:@"+" forState:UIControlStateNormal];
        [self.decreaseButton setTag:77];
    }
    
    return _decreaseButton;
}

@end



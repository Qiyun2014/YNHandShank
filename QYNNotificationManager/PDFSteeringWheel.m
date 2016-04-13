//
//  PDFSteeringWheel.m
//  QYNNotificationManager
//
//  Created by qiyun on 16/4/13.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import "PDFSteeringWheel.h"

@implementation PDFSteeringWheel


#define KPDFDirection_bgImage @"摇杆方位_@3x"
#define KPDFDirection_hdShank @"摇杆_@3x"

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


- (PDFStreeingWheelOfDirection)compareStartPoint:(CGPoint)poinx otherPoint:(CGPoint)otherPoint{

    //NSLog(@"**************%@**************",NSStringFromCGPoint(self->imageView.center));

    //横纵轴标的比例
    float persent = self.bounds.size.width/self.bounds.size.height;

    if ((poinx.x < otherPoint.x) && (otherPoint.x < (otherPoint.y * persent))) {

        //右半轴拖动的比例 0.0--1.0
        self->moveSpeed = (otherPoint.x - poinx.x)/(self.bounds.size.width/2);
        return PDFSteeringWheelDirection_right;
    }
    
    else if ((poinx.x > otherPoint.x) && (otherPoint.x > (otherPoint.y * persent))){
        
        self->moveSpeed = (poinx.x - otherPoint.x)/(self.bounds.size.width/2);
        return PDFSteeringWheelDirection_left;
    }
    
    else if ((poinx.y < otherPoint.y) && (otherPoint.x < (otherPoint.y * persent))){
        
        self->moveSpeed = (otherPoint.y - poinx.y)/(self.bounds.size.width/2);
        return PDFSteeringWheelDirection_down;
    }
    
    else if ((poinx.y > otherPoint.y) && (otherPoint.x > (otherPoint.y * persent))){
        
        self->moveSpeed = (poinx.y - otherPoint.y)/(self.bounds.size.height/2);
        return PDFSteeringWheelDirection_up;
    }
    
    return PDFSteeringWheelDirection_default;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat origin_x = (self.bounds.size.width - self->imageView.bounds.size.width)/2;
    CGFloat origin_y = (self.bounds.size.height - self->imageView.bounds.size.height)/2;
    
    CGRect rect = self->aFrame;
    rect.origin = CGPointMake(origin_x, origin_y);
    self->imageView.frame = rect;
    
    CGRect rect2 = CGRectMake(0, 0, rect.size.height/2.5, rect.size.height/2.5);
    self->handShankImageView.frame = rect2;
    self->handShankImageView.center = self->imageView.center;
}


#pragma mark    -   private method

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

- (void)setFrame:(CGRect)frame{
    
    self->aFrame = frame;
}

- (void)setMoveDirection:(PDFStreeingWheelOfDirection)moveDirection{
    
    //    self.moveDirection = moveDirection;
    switch (moveDirection) {
        case PDFSteeringWheelDirection_down:
            NSLog(@"下");
            break;

        case PDFSteeringWheelDirection_left:
            NSLog(@"左");
            break;

        case PDFSteeringWheelDirection_right:
            NSLog(@"右");
            break;

        case PDFSteeringWheelDirection_up:
            NSLog(@"上");
            break;

        default:
            NSLog(@"默认。。。");
            break;
    }
}


#pragma mark    -   Gesture delegate


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    
    //创建碰撞行为
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self,self->handShankImageView]];
    
    //设置碰撞边界，不设置就会飞出屏幕，设置就会在屏幕边框处产生碰撞效果
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    CGPoint point = [[touches allObjects].lastObject locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, point)) {
        
        NSLog(@"point = %@",NSStringFromCGPoint(point));
        
        self->handShankImageView.center = point;
        
        self.moveDirection = [self compareStartPoint:self->imageView.center otherPoint:point];
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self->handShankImageView.center = self->imageView.center;
    /*
    
    UISnapBehavior *snap = [[UISnapBehavior alloc]initWithItem:self->handShankImageView
                                                   snapToPoint:CGPointApplyAffineTransform(self->imageView.center, CGAffineTransformMakeRotation(M_PI_2))];
    
    snap.damping = 0.2;

    [self->animator removeAllBehaviors];
    [self->animator addBehavior:snap];
    */
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

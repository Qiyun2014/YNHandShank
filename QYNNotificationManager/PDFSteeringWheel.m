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
    
    CGRect rect = self->aFrame;
    rect.origin = CGPointMake(origin_x, origin_y);
    self->imageView.frame = rect;
    
    CGRect rect2 = CGRectMake(0, 0, rect.size.height/2.5, rect.size.height/2.5);
    self->handShankImageView.frame = rect2;
    self->handShankImageView.center = self->imageView.center;
}


#pragma mark    -   private method

- (PDFStreeingWheelOfDirection)compareStartPoint:(CGPoint)poinx otherPoint:(CGPoint)otherPoint{
    
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

- (void)setFrame:(CGRect)frame{
    
    self->aFrame = frame;
}

- (void)setMoveDirection:(PDFStreeingWheelOfDirection)moveDirection{
    
    //    self.moveDirection = moveDirection;
    switch (moveDirection) {
            
        case PDFSteeringWheelDirection_down:
            NSLog(@"下  速度:%f",self->moveSpeed);
            break;

        case PDFSteeringWheelDirection_left:
            NSLog(@"左  速度:%f",self->moveSpeed);
            break;

        case PDFSteeringWheelDirection_right:
            NSLog(@"右  速度:%f",self->moveSpeed);
            break;

        case PDFSteeringWheelDirection_up:
            NSLog(@"上  速度:%f",self->moveSpeed);
            break;

        default:
            NSLog(@"默认。。。");
            break;
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
         usingSpringWithDamping:0.1
          initialSpringVelocity:0.5
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

//
//  SLGestureCodeItem.m
//  GestureCode
//
//  Created by Sean on 2018/10/26.
//  Copyright © 2018 private. All rights reserved.
//

#import "SLGestureCodeItem.h"
#import "SLGestureCodeHelper.h"

static CGFloat kInnerItemWidth = 20.f;
static CGFloat kTrianglePadding = 8.f;
static CGFloat kTriangleWidth = 10.f;

@interface SLGestureCodeItem ()
@property (strong, nonatomic) UIColor *selectedColor;
@end

@implementation SLGestureCodeItem

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.selectedColor = SLSelectedColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithOvalInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0))];
    outerPath.lineWidth = self.state == SLGestureCOdeItemStateNormal ? 1.f : 2.f;
    
    self.selectedColor = self.state == SLGestureCOdeItemStateError ? SLErrorColor : SLSelectedColor;
    
    [self.selectedColor setStroke];
    [outerPath stroke];

    [[UIColor clearColor] setFill];
    [outerPath fill];
    
    CAShapeLayer *outerLayer = [CAShapeLayer new];
    outerLayer.path = outerPath.CGPath;
    
    if (self.state != SLGestureCOdeItemStateNormal) {
        CGFloat center = CGRectGetMidX(self.bounds);

        UIBezierPath *innerPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(center, center) radius:kInnerItemWidth/2.f startAngle:0.f endAngle:2 * M_PI clockwise:true];
        [self.selectedColor setFill];
        [innerPath fill];
        
        if (!CGPointEqualToPoint(self.destination, CGPointZero)) {
            self.destination.x < self.center.x ? [self leftTriangle] : [self rightTriangle];
            
            [CATransaction begin];
            [CATransaction setDisableActions:true];
            self.layer.transform = CATransform3DMakeRotation([self _angleToRotation], 0, 0, 1);
            [CATransaction commit];
        }
    }
    
    self.layer.mask = outerLayer;
}

- (void)setState:(SLGestureCOdeItemState)state {
    if (state == _state) return;
    
    _state = state;
    
    [self setNeedsDisplay];
}

- (void)setDestination:(CGPoint)destination {
    if (CGPointEqualToPoint(destination, _destination)) return;
    
    _destination = destination;
    
    [self setNeedsDisplay];;
}

#pragma mark - Private
- (CGFloat)_angleToRotation {
    CGFloat height = self.destination.y - self.center.y;
    CGFloat width = self.destination.x - self.center.x;
    CGFloat rads = atan(height/width);

    return rads;
}

- (void)leftTriangle {
    CGFloat center = CGRectGetMidX(self.bounds);
    
    UIBezierPath *aPath = [UIBezierPath new];
    [aPath moveToPoint:CGPointMake(kTrianglePadding, center)];
    [aPath addLineToPoint:CGPointMake(kTrianglePadding + kTriangleWidth/2.f, center - kTriangleWidth/2.f)];
    [aPath addLineToPoint:CGPointMake(kTrianglePadding + kTriangleWidth/2.f, center + kTriangleWidth/2.f)];
    [aPath addLineToPoint:CGPointMake(kTrianglePadding, center)];
    
    [self.selectedColor setFill];
    [aPath fill];
}

- (void)rightTriangle {
    CGFloat center = CGRectGetMidX(self.bounds);
    CGFloat maxX = CGRectGetWidth(self.bounds) - kTrianglePadding;
    
    UIBezierPath *aPath = [UIBezierPath new];
    [aPath moveToPoint:CGPointMake(maxX, center)];
    [aPath addLineToPoint:CGPointMake(maxX - kTriangleWidth/2.f, center - kTriangleWidth/2.f)];
    [aPath addLineToPoint:CGPointMake(maxX - kTriangleWidth/2.f, center + kTriangleWidth/2.f)];
    [aPath addLineToPoint:CGPointMake(maxX, center)];
    
    [self.selectedColor setFill];
    [aPath fill];
}
@end

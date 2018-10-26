//
//  SLGestureCodeItem.m
//  GestureCode
//
//  Created by Sean on 2018/10/26.
//  Copyright © 2018 private. All rights reserved.
//

#import "SLGestureCodeItem.h"

static CGFloat kInnerItemWidth = 20.f;

@interface SLGestureCodeItem ()
@property (strong, nonatomic) CALayer *outerLayer;
@property (strong, nonatomic) CALayer *innerLayer;
@property (strong, nonatomic) CALayer *triangleLayer;

@property (strong, nonatomic) UIColor *selectedColor;
@end

@implementation SLGestureCodeItem

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.selectedColor = [UIColor colorWithRed:0.06 green:0.51 blue:0.90 alpha:1];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithOvalInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0))];
    outerPath.lineWidth = _selected ? 2.f : 1.f;
    [self.selectedColor setStroke];
    [outerPath stroke];
    
    [[UIColor clearColor] setFill];
    [outerPath fill];
    
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.path = outerPath.CGPath;
    
    if (_selected) {
        CGFloat center = CGRectGetMidX(self.bounds);

        UIBezierPath *innerPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(center, center) radius:kInnerItemWidth/2.f startAngle:0.f endAngle:2 * M_PI clockwise:true];
        [self.selectedColor setFill];
        [innerPath fill];
        
        CAShapeLayer *innerLayer = [CAShapeLayer new];
        innerLayer.path = innerPath.CGPath;
        
        [layer addSublayer:innerLayer];
        
        if (!CGPointEqualToPoint(self.destination, CGPointZero)) {
            NSLog(@"%@",@([self _angleToRotation]));
        }
    }
    
    self.layer.mask = layer;
}

- (void)setSelected:(BOOL)selected {
    if (selected == _selected) return;
    
    _selected = selected;
    
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
    CGFloat value = (180.f * rads / M_PI);
    
    return value;
}
@end

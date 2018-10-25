//
//  SLGestureCodeView.m
//  GestureCode
//
//  Created by Sean on 2018/10/25.
//  Copyright © 2018 private. All rights reserved.
//

#import "SLGestureCodeView.h"

static CGFloat kSLItemWidth = 65.f;
static NSInteger kSLItemTag = 10000;

@interface SLGestureCodeView ()
@property (assign, nonatomic) CGFloat itemPadding;
@property (assign, nonatomic) CGFloat itemMargin;

@property (strong, nonatomic) NSMutableArray *points;

@property (assign, nonatomic) CGPoint currentPoint;

@property (strong, nonatomic) UIColor *selectedColor;
@end

@implementation SLGestureCodeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _points = [NSMutableArray new];
        _itemPadding = (CGRectGetWidth(frame) - 3 * kSLItemWidth) / 4.f;
        _itemMargin = 40.f;
        
        _selectedColor = [UIColor colorWithRed:0.13 green:0.7 blue:0.96 alpha:1];
        
        [self _initializePoints];
        [self _configGuestures];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.points.count == 0) return;
    
     [[UIColor whiteColor] setFill];
    
    UIBezierPath *path = [UIBezierPath new];
    
    for (NSInteger index = 0; index < self.points.count; index++) {
        UIButton *point = self.points[index];
        if (index == 0) {
            [path moveToPoint:point.center];
        } else {
            [path addLineToPoint:point.center];
        }
    }
    
    if (self.currentPoint.x != 0 && self.currentPoint.y != 0) {
        [path addLineToPoint:self.currentPoint];
    }
    
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineWidth:1.0f];
    [self.selectedColor set];
    [path stroke];
}

#pragma mark - Private
- (void)_initializePoints {
    for (NSInteger index = 0; index < 9; index++) {
        UIButton *point = [self _initializePoint:index];
        CGFloat originX = (index % 3) * kSLItemWidth + (index % 3 + 1) * self.itemPadding;
        CGFloat originY = (index / 3) * kSLItemWidth + (index / 3 + 1) * self.itemMargin;
        point.center = CGPointMake(originX + kSLItemWidth/2.f, originY + kSLItemWidth/2.f);
        [self addSubview:point];
    }
}

- (UIButton *)_initializePoint:(NSInteger)index {
    UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kSLItemWidth, kSLItemWidth)];
    item.tag = kSLItemTag + index;
    item.userInteractionEnabled = false;
    [item setImage:[UIImage imageNamed:@"gusture_point_normal"] forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:@"gusture_point_selected"] forState:UIControlStateSelected];
    return item;
}

- (void)_configGuestures {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self addGestureRecognizer:pan];
}

- (void)checkPoint:(CGPoint)point redraw:(BOOL)redraw {
    for (UIButton *button in self.subviews) {
        if (!button.selected && CGRectContainsPoint(button.frame, point)) {
            button.selected = true;
            [self.points addObject:button];
            break;
        }
    }
    [self setNeedsDisplay];
}

- (void)clearPoints {
    self.currentPoint = CGPointZero;
}

#pragma mark - Action
- (void)handleGesture:(UIPanGestureRecognizer *)pan {
    self.currentPoint = [pan locationInView:self];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            [self checkPoint:self.currentPoint redraw:false];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            [self checkPoint:self.currentPoint redraw:false];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            [self clearPoints];
            [self setNeedsDisplay];
        }
            break;
        default:
            break;
    }
}
@end

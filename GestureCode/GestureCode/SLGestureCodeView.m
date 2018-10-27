//
//  SLGestureCodeView.m
//  GestureCode
//
//  Created by Sean on 2018/10/25.
//  Copyright © 2018 private. All rights reserved.
//

#import "SLGestureCodeView.h"
#import "SLGestureCodeItem.h"
#import "SLGestureCodeHelper.h"

static CGFloat kSLItemWidth = 65.f;
static NSInteger kSLItemTag = 10000;

static const CGFloat kErrorDuration = 1.0f;

@interface SLGestureCodeView ()
@property (strong, nonatomic) NSMutableArray *points;

@property (assign, nonatomic) CGPoint currentPoint;

@property (strong, nonatomic) UIColor *selectedColor;

@property (strong, nonatomic) NSString *generatedCode;
@end

@implementation SLGestureCodeView
static CGFloat kItemPadding;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _points = [NSMutableArray new];
        kItemPadding = (CGRectGetWidth(frame) - 3 * kSLItemWidth) / 4.f;
        
        _selectedColor = SLSelectedColor;
        
        [self _initializePoints];
        [self _configGuestures];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
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
        SLGestureCodeItem *point = [self _initializePoint:index];
        CGFloat originX = (index % 3) * kSLItemWidth + (index % 3 + 1) * kItemPadding;
        CGFloat originY = (index / 3) * kSLItemWidth + (index / 3 + 1) * kItemPadding;
        point.center = CGPointMake(originX + kSLItemWidth/2.f, originY + kSLItemWidth/2.f);
        [self addSubview:point];
    }
}

- (SLGestureCodeItem *)_initializePoint:(NSInteger)index {
    SLGestureCodeItem *item = [[SLGestureCodeItem alloc] initWithFrame:CGRectMake(0, 0, kSLItemWidth, kSLItemWidth)];
    item.tag = kSLItemTag + index;
    return item;
}

- (void)_configGuestures {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self addGestureRecognizer:pan];
}

- (void)checkPoint:(CGPoint)point redraw:(BOOL)redraw {
    for (NSInteger index = 0; index < self.subviews.count; index++) {
        SLGestureCodeItem *item = self.subviews[index];
        if (item.state == SLGestureCOdeItemStateNormal && CGRectContainsPoint(item.frame, point)) {
            item.state = SLGestureCOdeItemStateSelected;
            [self.points addObject:item];
            [self configTriangle:item];
            break;
        }
    }
    [self setNeedsDisplay];
}

- (void)configTriangle:(SLGestureCodeItem *)destination  {
    if (self.points.count <= 1) return;
    
    SLGestureCodeItem *item = self.points[self.points.count - 2];
    item.destination = destination.center;
}

- (void)clearPoints {
    for (SLGestureCodeItem *point in self.points) {
        point.state = SLGestureCOdeItemStateNormal;
        point.destination = CGPointZero;
    }
    
    self.currentPoint = CGPointZero;
    
    [self.points removeAllObjects];
}

- (BOOL)verifyCode {
    NSMutableString *code = [NSMutableString new];
    for (SLGestureCodeItem *point in self.points) {
        [code appendFormat:@"%@", @(point.tag - kSLItemTag + 1).stringValue];
    }
    
    if (self.generatedCode.length == 0) {
        self.generatedCode = code;
        return true;
    }
    
    if ([self.generatedCode isEqualToString:code]) {
        //两次密码输入相等,这里可以回掉出去
        if (self.generatedBlock) self.generatedBlock(self.generatedCode);
        self.generatedCode = nil;
        return true;
    }
    
    return false;
}

- (void)showError {
    for (SLGestureCodeItem *point in self.points) {
        point.state = SLGestureCOdeItemStateError;
    }
    if (self.errorBlock) self.errorBlock();
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
            if ([self verifyCode]) {
                [self clearPoints];
                
                [self setNeedsDisplay];
            } else {
                self.userInteractionEnabled = false;
                self.selectedColor = SLErrorColor;
                [self showError];
                
                [self setNeedsDisplay];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kErrorDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.userInteractionEnabled = true;
                    self.selectedColor = SLSelectedColor;
                    [self clearPoints];
                    [self setNeedsDisplay];
                });
            }
        }
            break;
        default:
            break;
    }
}
@end

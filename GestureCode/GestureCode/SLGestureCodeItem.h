//
//  SLGestureCodeItem.h
//  GestureCode
//
//  Created by Sean on 2018/10/26.
//  Copyright © 2018 private. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SLGestureCOdeItemState) {
    SLGestureCOdeItemStateNormal,
    SLGestureCOdeItemStateSelected,
    SLGestureCOdeItemStateError
};

NS_ASSUME_NONNULL_BEGIN

@interface SLGestureCodeItem : UIView
@property (assign, nonatomic) SLGestureCOdeItemState state;
@property (assign, nonatomic) CGPoint destination;
@end

NS_ASSUME_NONNULL_END

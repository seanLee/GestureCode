//
//  SLGestureCodeView.h
//  GestureCode
//
//  Created by Sean on 2018/10/25.
//  Copyright © 2018 private. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLGestureCodeView : UIView
@property (copy, nonatomic) void (^generatedBlock)(NSString *);
@property (copy, nonatomic) void (^errorBlock)(void);
@end

NS_ASSUME_NONNULL_END

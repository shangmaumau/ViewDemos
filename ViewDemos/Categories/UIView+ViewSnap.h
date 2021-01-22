//
//  UIView+ViewSnap.h
//  QMGame
//
//  Created by Michael on 2021/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ViewSnap)

- (nullable UIImage *)snap;
- (nullable UIImage *)snapInBounds:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END

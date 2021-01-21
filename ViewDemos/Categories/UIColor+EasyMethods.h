//
//  UIColor+EasyMethods.h
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (EasyMethods)

+ (UIColor *)colorWith255R:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;

+ (UIColor *)doubleFishThemeColor;

+ (UIColor *)doubleFishTintColor;

@end

NS_ASSUME_NONNULL_END

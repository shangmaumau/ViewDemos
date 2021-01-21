//
//  UIColor+EasyMethods.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import "UIColor+EasyMethods.h"

@implementation UIColor (EasyMethods)

+ (UIColor *)colorWith255R:(CGFloat)r g:(CGFloat)g b:(CGFloat)b {
    return [self colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

+ (UIColor *)doubleFishThemeColor {
    return [self colorWith255R:32 g:13 b:86];
}

+ (UIColor *)doubleFishTintColor {
    return [self colorWith255R:255.0 g:120.0 b:253.0];
}

@end

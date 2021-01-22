//
//  UIColor+EasyMethods.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import "UIColor+EasyMethods.h"

@implementation UIColor (EasyMethods)

+ (UIColor *)colorWithGray:(CGFloat)gray {
    return [UIColor colorWithRed:gray green:gray blue:gray alpha:1.0];
}

+ (UIColor *)colorWith255R:(CGFloat)r g:(CGFloat)g b:(CGFloat)b {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

+ (UIColor *)doubleFishThemeColor {
    return [UIColor colorWith255R:32.0 g:13.0 b:86.0];
}

+ (UIColor *)doubleFishTintColor {
    return [UIColor colorWith255R:255.0 g:120.0 b:253.0];
}

@end

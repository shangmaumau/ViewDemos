//
//  UIScreen+EasyMethods.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import "UIScreen+EasyMethods.h"

@implementation UIScreen (EasyMethods)

+ (CGFloat)width_c {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)height_c {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)widthScale {
    return [self width_c] / 375.0;
}

+ (CGFloat)heigthScale {
    return [self height_c] / 667.0;
}

@end

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

@end

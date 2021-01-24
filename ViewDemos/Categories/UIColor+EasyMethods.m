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

+ (UIColor *)doubleFishTextGrayColor {
    return [UIColor colorWith255R:176.0 g:169.0 b:194.0];
}

CGFloat jk_colorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    CGFloat alpha, red, blue, green;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = jk_colorComponentFrom(colorString, 0, 1);
            green = jk_colorComponentFrom(colorString, 1, 1);
            blue  = jk_colorComponentFrom(colorString, 2, 1);
            break;
            
        case 4: // #ARGB
            alpha = jk_colorComponentFrom(colorString, 0, 1);
            red   = jk_colorComponentFrom(colorString, 1, 1);
            green = jk_colorComponentFrom(colorString, 2, 1);
            blue  = jk_colorComponentFrom(colorString, 3, 1);
            break;
            
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = jk_colorComponentFrom(colorString, 0, 2);
            green = jk_colorComponentFrom(colorString, 2, 2);
            blue  = jk_colorComponentFrom(colorString, 4, 2);
            break;
            
        case 8: // #AARRGGBB
            alpha = jk_colorComponentFrom(colorString, 0, 2);
            red   = jk_colorComponentFrom(colorString, 2, 2);
            green = jk_colorComponentFrom(colorString, 4, 2);
            blue  = jk_colorComponentFrom(colorString, 6, 2);
            break;
            
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

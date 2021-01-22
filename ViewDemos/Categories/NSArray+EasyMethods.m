//
//  NSArray+EasyMethods.m
//  QMGame
//
//  Created by Michael on 2021/1/11.
//  Copyright © 2021 xiaonihy. All rights reserved.
//

#import "NSArray+EasyMethods.h"

@implementation NSArray (EasyMethods)

- (id)anotherObjectOf:(NSUInteger)index {
    
    if (self.count != 2) {
        return nil;
    }
    
    if (index == 0) {
        return self[1];
    } else {
        return self[0];
    }
}

@end

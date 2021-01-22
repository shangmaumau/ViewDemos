//
//  NSArray+EasyMethods.h
//  QMGame
//
//  Created by Michael on 2021/1/11.
//  Copyright © 2021 xiaonihy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (EasyMethods)

- (nullable ObjectType)anotherObjectOf:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END

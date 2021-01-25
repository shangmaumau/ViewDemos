//
//  SYLocalJSONManager.h
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SYMIUniversityModel, SYMIProfBaseModel, SYMICityBaseModel;

@interface SYLocalJSONManager : NSObject


+ (id)dataFromLocalJSONWithName:(NSString *)filename;

+ (NSArray<SYMICityBaseModel *> *)cities;
+ (NSArray<SYMIProfBaseModel *> *)profs;
+ (NSArray<SYMIUniversityModel *> *)universities;
+ (NSArray<NSString *> *)universities_name;


@end

NS_ASSUME_NONNULL_END

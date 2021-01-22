//
//  LocalJSONManager.h
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import <Foundation/Foundation.h>
#import "DFCityDataModels.h"
#import "DFProfDataModels.h"
#import "DFUniversityDataModels.h"

NS_ASSUME_NONNULL_BEGIN

@class DFUniversityBaseModel, DFProfBaseModel, DFCityBaseModel;

@interface LocalJSONManager : NSObject


+ (id)dataFromLocalJSONWithName:(NSString *)filename;

+ (NSArray<DFCityBaseModel *> *)cities;
+ (NSArray<DFProfBaseModel *> *)profs;
+ (NSArray<DFUniversityBaseModel *> *)universities;
+ (NSArray<NSString *> *)universities_name;


@end

NS_ASSUME_NONNULL_END

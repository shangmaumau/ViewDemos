//
//  LocalJSONManager.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import "LocalJSONManager.h"
#import "DFCityDataModels.h"
#import "DFProfDataModels.h"
#import "DFUniversityDataModels.h"

@implementation LocalJSONManager

+ (id)dataFromLocalJSONWithName:(NSString *)filename {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

+ (NSArray<DFCityBaseModel *> *)cities {
    NSArray *citiesRawData = [self dataFromLocalJSONWithName:@"cities"];
    NSMutableArray<DFCityBaseModel *> *models = [NSMutableArray array];
    for (NSUInteger idx = 0; idx < citiesRawData.count; idx++) {
        DFCityBaseModel *model = [DFCityBaseModel modelObjectWithDictionary:citiesRawData[idx]];
        if (model) {
            [models addObject:model];
        }
    }
    return [models copy];
}

+ (NSArray<DFProfBaseModel *> *)profs {
    NSArray *profRawData = [self dataFromLocalJSONWithName:@"professions"];
    NSMutableArray<DFCityBaseModel *> *models = [NSMutableArray array];
    for (NSUInteger idx = 0; idx < profRawData.count; idx++) {
        DFCityBaseModel *model = [DFCityBaseModel modelObjectWithDictionary:profRawData[idx]];
        if (model) {
            [models addObject:model];
        }
    }
    return [models copy];
}

+ (NSArray<DFUniversityBaseModel *> *)universities {
    NSArray *univerRawData = [self dataFromLocalJSONWithName:@"universities"];
    NSMutableArray<DFUniversityBaseModel *> *models = [NSMutableArray array];
    for (NSUInteger idx = 0; idx < univerRawData.count; idx++) {
        DFUniversityBaseModel *model = [DFUniversityBaseModel modelObjectWithDictionary:univerRawData[idx]];
        if (model) {
            [models addObject:model];
        }
    }
    return [models copy];
}

+ (NSArray<NSString *> *)universities_name {
    NSArray *univerRawData = [self dataFromLocalJSONWithName:@"universities"];
    NSMutableArray<NSString *> *models = [NSMutableArray array];
    for (NSUInteger idx = 0; idx < univerRawData.count; idx++) {
        DFUniversityBaseModel *model = [DFUniversityBaseModel modelObjectWithDictionary:univerRawData[idx]];
        if (model) {
            [models addObject:model.name];
        }
    }
    return [models copy];
}


@end

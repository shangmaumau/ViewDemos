//
//  SYLocalJSONManager.m
//  ViewDemos
//
//  Created by 尚雷勋 on 2021/1/20.
//

#import "SYLocalJSONManager.h"
#import "SYMICityModels.h"
#import "SYMIProfModels.h"
#import "SYMIUniversityModels.h"

@implementation SYLocalJSONManager

+ (id)dataFromLocalJSONWithName:(NSString *)filename {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

+ (NSArray<SYMICityBaseModel *> *)cities {
    NSArray *citiesRawData = [self dataFromLocalJSONWithName:@"cities"];
    NSMutableArray<SYMICityBaseModel *> *models = [NSMutableArray array];
    for (NSUInteger idx = 0; idx < citiesRawData.count; idx++) {
        SYMICityBaseModel *model = [SYMICityBaseModel modelObjectWithDictionary:citiesRawData[idx]];
        if (model) {
            [models addObject:model];
        }
    }
    return [models copy];
}

+ (NSArray<SYMIProfBaseModel *> *)profs {
    NSArray *profRawData = [self dataFromLocalJSONWithName:@"professions"];
    NSMutableArray<SYMICityBaseModel *> *models = [NSMutableArray array];
    for (NSUInteger idx = 0; idx < profRawData.count; idx++) {
        SYMICityBaseModel *model = [SYMICityBaseModel modelObjectWithDictionary:profRawData[idx]];
        if (model) {
            [models addObject:model];
        }
    }
    return [models copy];
}

+ (NSArray<SYMIUniversityModel *> *)universities {
    NSArray *univerRawData = [self dataFromLocalJSONWithName:@"universities"];
    NSMutableArray<SYMIUniversityModel *> *models = [NSMutableArray array];
    for (NSUInteger idx = 0; idx < univerRawData.count; idx++) {
        SYMIUniversityModel *model = [SYMIUniversityModel modelObjectWithDictionary:univerRawData[idx]];
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
        SYMIUniversityModel *model = [SYMIUniversityModel modelObjectWithDictionary:univerRawData[idx]];
        if (model) {
            [models addObject:model.name];
        }
    }
    return [models copy];
}


@end

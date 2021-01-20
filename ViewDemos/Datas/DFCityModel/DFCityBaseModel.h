//
//  DFCityBaseModel.h
//
//  Created by 雷勋 尚 on 2021/1/20
//  Copyright (c) 2021 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DFCityBaseModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *sub;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end

//
//  SYMIUniversityModel.h
//
//  Created by 雷勋 尚 on 2021/1/20
//  Copyright (c) 2021 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SYMIUniversityModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double internalBaseClassIdentifier;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end

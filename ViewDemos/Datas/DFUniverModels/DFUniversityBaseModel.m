//
//  DFUniversityBaseModel.m
//
//  Created by 雷勋 尚 on 2021/1/20
//  Copyright (c) 2021 __MyCompanyName__. All rights reserved.
//

#import "DFUniversityBaseModel.h"


NSString *const kDFUniversityBaseModelId = @"id";
NSString *const kDFUniversityBaseModelName = @"name";


@interface DFUniversityBaseModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DFUniversityBaseModel

@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize name = _name;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.internalBaseClassIdentifier = [[self objectOrNilForKey:kDFUniversityBaseModelId fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kDFUniversityBaseModelName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.internalBaseClassIdentifier] forKey:kDFUniversityBaseModelId];
    [mutableDict setValue:self.name forKey:kDFUniversityBaseModelName];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.internalBaseClassIdentifier = [aDecoder decodeDoubleForKey:kDFUniversityBaseModelId];
    self.name = [aDecoder decodeObjectForKey:kDFUniversityBaseModelName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_internalBaseClassIdentifier forKey:kDFUniversityBaseModelId];
    [aCoder encodeObject:_name forKey:kDFUniversityBaseModelName];
}

- (id)copyWithZone:(NSZone *)zone
{
    DFUniversityBaseModel *copy = [[DFUniversityBaseModel alloc] init];
    
    if (copy) {

        copy.internalBaseClassIdentifier = self.internalBaseClassIdentifier;
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end

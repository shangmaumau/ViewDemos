//
//  DFCityBaseModel.m
//
//  Created by 雷勋 尚 on 2021/1/20
//  Copyright (c) 2021 __MyCompanyName__. All rights reserved.
//

#import "DFCityBaseModel.h"
#import "DFCityCityModel.h"


NSString *const kDFCityBaseModelId = @"id";
NSString *const kDFCityBaseModelName = @"name";
NSString *const kDFCityBaseModelSub = @"sub";


@interface DFCityBaseModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DFCityBaseModel

@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize name = _name;
@synthesize sub = _sub;


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
            self.internalBaseClassIdentifier = [self objectOrNilForKey:kDFCityBaseModelId fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDFCityBaseModelName fromDictionary:dict];
    NSObject *receivedSub = [dict objectForKey:kDFCityBaseModelSub];
    NSMutableArray *parsedSub = [NSMutableArray array];
    if ([receivedSub isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSub) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSub addObject:[DFCityCityModel modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSub isKindOfClass:[NSDictionary class]]) {
       [parsedSub addObject:[DFCityCityModel modelObjectWithDictionary:(NSDictionary *)receivedSub]];
    }

    self.sub = [NSArray arrayWithArray:parsedSub];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kDFCityBaseModelId];
    [mutableDict setValue:self.name forKey:kDFCityBaseModelName];
    NSMutableArray *tempArrayForSub = [NSMutableArray array];
    for (NSObject *subArrayObject in self.sub) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForSub addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForSub addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForSub] forKey:kDFCityBaseModelSub];

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

    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kDFCityBaseModelId];
    self.name = [aDecoder decodeObjectForKey:kDFCityBaseModelName];
    self.sub = [aDecoder decodeObjectForKey:kDFCityBaseModelSub];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kDFCityBaseModelId];
    [aCoder encodeObject:_name forKey:kDFCityBaseModelName];
    [aCoder encodeObject:_sub forKey:kDFCityBaseModelSub];
}

- (id)copyWithZone:(NSZone *)zone
{
    DFCityBaseModel *copy = [[DFCityBaseModel alloc] init];
    
    if (copy) {

        copy.internalBaseClassIdentifier = [self.internalBaseClassIdentifier copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.sub = [self.sub copyWithZone:zone];
    }
    
    return copy;
}


@end

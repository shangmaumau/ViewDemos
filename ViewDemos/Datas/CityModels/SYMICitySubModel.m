//
//  SYMICitySubModel.m
//
//  Created by 雷勋 尚 on 2021/1/20
//  Copyright (c) 2021 __MyCompanyName__. All rights reserved.
//

#import "SYMICitySubModel.h"


NSString *const kDFCityCityModelId = @"id";
NSString *const kDFCityCityModelName = @"name";
NSString *const kDFCityCityModelSub = @"sub";


@interface SYMICitySubModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SYMICitySubModel

@synthesize subIdentifier = _subIdentifier;
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
            self.subIdentifier = [self objectOrNilForKey:kDFCityCityModelId fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDFCityCityModelName fromDictionary:dict];
            self.sub = [self objectOrNilForKey:kDFCityCityModelSub fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.subIdentifier forKey:kDFCityCityModelId];
    [mutableDict setValue:self.name forKey:kDFCityCityModelName];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForSub] forKey:kDFCityCityModelSub];

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

    self.subIdentifier = [aDecoder decodeObjectForKey:kDFCityCityModelId];
    self.name = [aDecoder decodeObjectForKey:kDFCityCityModelName];
    self.sub = [aDecoder decodeObjectForKey:kDFCityCityModelSub];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_subIdentifier forKey:kDFCityCityModelId];
    [aCoder encodeObject:_name forKey:kDFCityCityModelName];
    [aCoder encodeObject:_sub forKey:kDFCityCityModelSub];
}

- (id)copyWithZone:(NSZone *)zone
{
    SYMICitySubModel *copy = [[SYMICitySubModel alloc] init];
    
    if (copy) {

        copy.subIdentifier = [self.subIdentifier copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.sub = [self.sub copyWithZone:zone];
    }
    
    return copy;
}


@end

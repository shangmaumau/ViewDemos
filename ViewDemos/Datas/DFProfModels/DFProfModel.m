//
//  DFProfModel.m
//
//  Created by 雷勋 尚 on 2021/1/20
//  Copyright (c) 2021 __MyCompanyName__. All rights reserved.
//

#import "DFProfModel.h"


NSString *const kDFProfModelId = @"id";
NSString *const kDFProfModelName = @"name";


@interface DFProfModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DFProfModel

@synthesize subIdentifier = _subIdentifier;
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
            self.subIdentifier = [[self objectOrNilForKey:kDFProfModelId fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kDFProfModelName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.subIdentifier] forKey:kDFProfModelId];
    [mutableDict setValue:self.name forKey:kDFProfModelName];

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

    self.subIdentifier = [aDecoder decodeDoubleForKey:kDFProfModelId];
    self.name = [aDecoder decodeObjectForKey:kDFProfModelName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_subIdentifier forKey:kDFProfModelId];
    [aCoder encodeObject:_name forKey:kDFProfModelName];
}

- (id)copyWithZone:(NSZone *)zone
{
    DFProfModel *copy = [[DFProfModel alloc] init];
    
    if (copy) {

        copy.subIdentifier = self.subIdentifier;
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end

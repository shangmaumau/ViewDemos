//
//  DFProfBaseModel.m
//
//  Created by 雷勋 尚 on 2021/1/20
//  Copyright (c) 2021 __MyCompanyName__. All rights reserved.
//

#import "DFProfBaseModel.h"
#import "DFProfModel.h"


NSString *const kDFProfBaseModelId = @"id";
NSString *const kDFProfBaseModelName = @"name";
NSString *const kDFProfBaseModelSub = @"sub";


@interface DFProfBaseModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DFProfBaseModel

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
            self.internalBaseClassIdentifier = [[self objectOrNilForKey:kDFProfBaseModelId fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kDFProfBaseModelName fromDictionary:dict];
    NSObject *receivedSub = [dict objectForKey:kDFProfBaseModelSub];
    NSMutableArray *parsedSub = [NSMutableArray array];
    if ([receivedSub isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSub) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSub addObject:[DFProfModel modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSub isKindOfClass:[NSDictionary class]]) {
       [parsedSub addObject:[DFProfModel modelObjectWithDictionary:(NSDictionary *)receivedSub]];
    }

    self.sub = [NSArray arrayWithArray:parsedSub];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.internalBaseClassIdentifier] forKey:kDFProfBaseModelId];
    [mutableDict setValue:self.name forKey:kDFProfBaseModelName];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForSub] forKey:kDFProfBaseModelSub];

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

    self.internalBaseClassIdentifier = [aDecoder decodeDoubleForKey:kDFProfBaseModelId];
    self.name = [aDecoder decodeObjectForKey:kDFProfBaseModelName];
    self.sub = [aDecoder decodeObjectForKey:kDFProfBaseModelSub];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_internalBaseClassIdentifier forKey:kDFProfBaseModelId];
    [aCoder encodeObject:_name forKey:kDFProfBaseModelName];
    [aCoder encodeObject:_sub forKey:kDFProfBaseModelSub];
}

- (id)copyWithZone:(NSZone *)zone
{
    DFProfBaseModel *copy = [[DFProfBaseModel alloc] init];
    
    if (copy) {

        copy.internalBaseClassIdentifier = self.internalBaseClassIdentifier;
        copy.name = [self.name copyWithZone:zone];
        copy.sub = [self.sub copyWithZone:zone];
    }
    
    return copy;
}


@end

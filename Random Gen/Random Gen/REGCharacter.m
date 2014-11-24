//
//  REGCharacter.m
//  Random Gen
//
//  Created by Alan Wang on 11/20/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "REGCharacter.h"
#import "REGPropertiesDatabase.h"
#import "GlobalConstants.h"

@implementation REGCharacter

#pragma mark - Initializers
//DESIGNATED
-(instancetype)initWithName:(NSString *)name occupation:(NSString *)occupation race:(NSString *)race
{
    self = [super init];
    
    if (self) {
        _name = name;
        _occupation = occupation;
        _race = race;
    }
    
    return self;
}

-(instancetype)init
{
    return [self initWithName:nil occupation:nil race:nil];
}

#pragma mark - Traits
-(void)addTrait:(NSString *)trait
{
    NSMutableArray *traits;
    
    if (self.traits == nil) {
        traits = [[NSMutableArray alloc]init];
    }
    else {
        traits = [self.traits mutableCopy];
    }
    
    [traits addObject:trait];
    
    self.traits = [traits copy];
}

-(void)removeTraitAtIndex:(NSUInteger)index
{
    NSMutableArray *traits;
    
    if (self.traits == nil) {
        traits = [[NSMutableArray alloc]init];
    }
    else {
        traits = [self.traits mutableCopy];
    }
    
    [traits removeObjectAtIndex:index];
    
    if ([traits count] != 0) {
        self.traits = [traits copy];
    }
    else {
        self.traits = nil;
    }
}

-(void)changeTraitAtIndex:(NSUInteger)index toTrait:(NSString *)trait
{
    NSMutableArray *traits;
    
    if (self.traits == nil) {
        traits = [[NSMutableArray alloc]init];
    }
    else {
        traits = [self.traits mutableCopy];
    }
    
    traits[index] = trait;
    
    self.traits = [traits copy];
}

#pragma mark - Randomization methods
+ (instancetype)randomCharacter
{
    REGCharacter *randomCharacter = [[REGCharacter alloc]init];
    
    [randomCharacter randomizeName];
    [randomCharacter randomizeOccupation];
    [randomCharacter randomizeRace];
    [randomCharacter addTrait:[randomCharacter getRandomTrait]];
    
    return randomCharacter;
}

- (void)randomizeName
{
    self.name = [[REGPropertiesDatabase sharedDatabase]getRandomPropertyForKey:CHARACTER_NAME_KEY];
}

-(void)randomizeOccupation
{
    self.occupation = [[REGPropertiesDatabase sharedDatabase]getRandomPropertyForKey:OCCUPATION_KEY];
}

-(void)randomizeRace
{
    self.race = [[REGPropertiesDatabase sharedDatabase]getRandomPropertyForKey:RACE_KEY];
}

-(NSString *)getRandomTrait
{
    return [[REGPropertiesDatabase sharedDatabase]getRandomPropertyForKey:CHARACTER_TRAIT_KEY];
}

#pragma mark - Miscellaneous
-(NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@ %@", self.name, self.race, self.occupation];
}

@end

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

#pragma mark - Randomization methods
+ (instancetype)randomCharacter
{
    REGPropertiesDatabase *database = [REGPropertiesDatabase sharedDatabase];
    
    REGCharacter *randomCharacter = [[REGCharacter alloc]init];
    
    [randomCharacter randomizeName];
    [randomCharacter randomizeOccupation];
    [randomCharacter randomizeRace];
    
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

#pragma mark - Miscellaneous
-(NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@ %@", self.name, self.race, self.occupation];
}

@end

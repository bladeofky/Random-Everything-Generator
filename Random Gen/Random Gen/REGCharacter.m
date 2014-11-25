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

#pragma mark - Accessors
-(void)setTraits:(NSOrderedSet *)traits
{
    _traits = traits;
}

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

#pragma mark - Trait Manipulation
-(void)addTrait:(NSString *)trait
{
    NSMutableOrderedSet *traits;
    
    if (self.traits == nil) {
        traits = [[NSMutableOrderedSet alloc]init];
    }
    else {
        traits = [self.traits mutableCopy];
    }
    
    [traits addObject:trait];
    
    self.traits = [traits copy];
}

-(void)removeTrait:(NSString *)trait
{
    //indexOfObject works by enumerating through the set and sending the isEqual: message to each object. This should return the index of a trait whose NSString is equal to the provided NSString, even if they're in different places in memory.
    NSUInteger index = [self.traits indexOfObject:trait];
    
    if (index == NSNotFound || self.traits == nil) {
        NSLog(@"Could not delete trait. Trait not found: %@", trait);
    }
    else {
        NSMutableOrderedSet *traits = [self.traits mutableCopy];
        
        [traits removeObjectAtIndex:index];
        
        if ([traits count] != 0) {
            self.traits = [traits copy];
        }
        else {
            self.traits = nil;
        }
    }
}

-(void)changeTrait:(NSString *)traitToChange toTrait:(NSString *)newTrait
{
    NSUInteger index = [self.traits indexOfObject:traitToChange];
    
    if (index == NSNotFound || self.traits == nil) {
        NSLog(@"Could not change trait. Trait not found: %@", traitToChange);
    }
    else {
        NSMutableOrderedSet *traits = [self.traits mutableCopy];
        
        [traits replaceObjectAtIndex:index withObject:newTrait];
        
        self.traits = [traits copy];
    }
}

#pragma mark - Randomization methods
+ (instancetype)randomCharacter
{
    REGCharacter *randomCharacter = [[REGCharacter alloc]init];
    
    [randomCharacter randomizeName];
    [randomCharacter randomizeOccupation];
    [randomCharacter randomizeRace];
    [randomCharacter addTrait:[randomCharacter randomTrait]];
    
    return randomCharacter;
}

- (void)randomizeName
{
    self.name = [[REGPropertiesDatabase sharedDatabase]randomPropertyForKey:CHARACTER_NAME_KEY];
}

-(void)randomizeOccupation
{
    self.occupation = [[REGPropertiesDatabase sharedDatabase]randomPropertyForKey:OCCUPATION_KEY];
}

-(void)randomizeRace
{
    self.race = [[REGPropertiesDatabase sharedDatabase]randomPropertyForKey:RACE_KEY];
}

-(void)addRandomTrait
{
    [self addTrait:[self randomTrait]];
}

-(void)changeToRandomTrait:(NSString *)traitToChange
{
    [self changeTrait:traitToChange toTrait:[self randomTrait]];
}

-(NSString *)randomTrait
{
    return [[REGPropertiesDatabase sharedDatabase]randomPropertyForKey:CHARACTER_TRAIT_KEY];
}

#pragma mark - Miscellaneous
-(NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@ %@", self.name, self.race, self.occupation];
}

@end

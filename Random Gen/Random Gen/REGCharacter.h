//
//  REGCharacter.h
//  Random Gen
//
//  Created by Alan Wang on 11/20/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REGCharacter : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *occupation;
@property (nonatomic, strong) NSString *race;
@property (nonatomic, strong, readonly) NSOrderedSet *traits;
@property (nonatomic, strong) NSString *notes;

+ (instancetype)randomCharacter;
- (instancetype)initWithName:(NSString *)name occupation:(NSString *)occupation race:(NSString *)race;

- (void) addTrait:(NSString *)trait;
- (void) removeTrait:(NSString *)trait;
- (void) changeTrait:(NSString *)traitToChange toTrait:(NSString *)newTrait;

- (void) randomizeName;
- (void) randomizeOccupation;
- (void) randomizeRace;
- (void) addRandomTrait;
- (void) changeToRandomTrait:(NSString *)traitToChange;

@end

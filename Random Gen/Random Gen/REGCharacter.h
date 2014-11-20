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
@property (nonatomic, strong) NSArray *traits;

+ (instancetype)randomCharacter;
- (instancetype)initWithName:(NSString *)name occupation:(NSString *)occupation race:(NSString *)race;
- (void) randomizeName;
- (void) randomizeOccupation;
- (void) randomizeRace;
- (void) addTrait: (NSString *)trait;
- (void) removeTraitAtIndex: (NSUInteger)index;
- (void) changeTraitAtIndex:(NSUInteger)index toTrait:(NSString *)trait;

@end

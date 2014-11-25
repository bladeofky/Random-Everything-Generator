//
//  REGPropertiesDatabase.h
//  Random Gen
//
//  Created by Alan Wang on 11/20/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

/* This is a singleton that holds all the possible races/names/traits/random things that can be generated */

#import <UIKit/UIKit.h>

@interface REGPropertiesDatabase : NSObject

+ (instancetype)sharedDatabase;

- (id)randomPropertyForKey: (NSString *)key;
- (NSArray *)allPropertiesForKey: (NSString *)key;

@end

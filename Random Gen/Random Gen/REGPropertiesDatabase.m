//
//  REGPropertiesDatabase.m
//  Random Gen
//
//  Created by Alan Wang on 11/20/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "REGPropertiesDatabase.h"

@interface REGPropertiesDatabase ()

@property (nonatomic, strong) NSDictionary *index;

@end

@implementation REGPropertiesDatabase

#pragma mark - Class methods
+(instancetype)sharedDatabase
{
    static REGPropertiesDatabase *sharedDatabase;
    
    if (!sharedDatabase) {
        sharedDatabase = [[self alloc]initPrivate];
    }
    
    return sharedDatabase;
}

#pragma mark - Initializers
-(instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use [+sharedDatabase] instead."];
    
    return nil;
}

-(instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"PropertiesDatabase" ofType:@"plist"];
        _index = [[NSDictionary alloc]initWithContentsOfFile:path];
    }
    
    return self;
}

#pragma mark - Data Retrieval methods

-(id)randomPropertyForKey:(NSString *)key
{
    NSArray *properties = [self allPropertiesForKey:key];
    
    return properties[arc4random_uniform([properties count])];
}

- (NSArray *)allPropertiesForKey:(NSString *)key
{
    return self.index[key];
}

@end

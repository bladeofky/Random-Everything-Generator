//
//  REGCharacterEditViewController.h
//  Random Gen
//
//  Created by Alan Wang on 11/20/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class REGCharacter;

@interface REGCharacterEditViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *raceField;
@property (nonatomic, weak) IBOutlet UITextField *occupationField;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextView *notesTextView;

@property (nonatomic, weak) IBOutlet UIImageView *diceIconName;
@property (nonatomic, weak) IBOutlet UIImageView *diceIconRace;
@property (nonatomic, weak) IBOutlet UIImageView *diceIconOccupation;

@property (nonatomic, strong) REGCharacter *character;

- (instancetype)initWithCharacter:(REGCharacter *)character;

@end

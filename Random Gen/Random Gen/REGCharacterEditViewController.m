//
//  REGCharacterEditViewController.m
//  Random Gen
//
//  Created by Alan Wang on 11/20/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "REGCharacterEditViewController.h"
#import "REGCharacter.h"

@interface REGCharacterEditViewController ()

// Pointers to use during editing of traits
@property (nonatomic, weak) UITextView *pseudoCellTextField;
@property (nonatomic, weak) UIView *pseudoCell;
@property (nonatomic, weak) UITextView *editorTextView;
@property (nonatomic, weak) UIView *darkenLayer;
@property (nonatomic, strong) NSIndexPath *editingIndexPath;
@property (nonatomic) CGRect rectOfOriginalTableViewCell;
@property (nonatomic) CGRect rectOfOriginalNotesView;

@end

@implementation REGCharacterEditViewController

#pragma mark - Initializers
// DESIGNATED
- (instancetype)initWithCharacter:(REGCharacter *)character
{
    self = [super initWithNibName:@"REGCharacterEditViewController" bundle:[NSBundle mainBundle]];
    
    if (self) {
        self.character = character;
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    REGCharacter *character = [[REGCharacter alloc]init];
    return [self initWithCharacter:character];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameField.text = self.character.name;
    self.raceField.text = self.character.race;
    self.occupationField.text = self.character.occupation;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UITapGestureRecognizer *tapNameDiceRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapNameDice)];
    tapNameDiceRecognizer.numberOfTapsRequired = 1;
    UITapGestureRecognizer *tapRaceDiceRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapRaceDice)];
    tapRaceDiceRecognizer.numberOfTapsRequired = 1;
    UITapGestureRecognizer *tapOccupationDiceRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOccupationDice)];
    tapOccupationDiceRecognizer.numberOfTapsRequired = 1;
    
    self.diceIconName.image = [UIImage imageNamed:@"dice.png"];
    [self.diceIconName addGestureRecognizer:tapNameDiceRecognizer];
    
    self.diceIconRace.image = [UIImage imageNamed:@"dice.png"];
    [self.diceIconRace addGestureRecognizer:tapRaceDiceRecognizer];
    
    self.diceIconOccupation.image = [UIImage imageNamed:@"dice.png"];
    [self.diceIconOccupation addGestureRecognizer:tapOccupationDiceRecognizer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tap Events

-(void)didTapNameDice
{
    [self.character randomizeName];
    self.nameField.text = self.character.name;
}

-(void)didTapRaceDice
{
    [self.character randomizeRace];
    self.raceField.text = self.character.race;
}

-(void)didTapOccupationDice
{
//    NSLog(@"Did tap occupation dice");
    [self.character randomizeOccupation];
    self.occupationField.text = self.character.occupation;
}

-(void)didTapTraitDice
{
    // State change to character.traits
    NSString *existingTrait = self.character.traits[self.editingIndexPath.row];
    [self.character changeToRandomTrait:existingTrait];
    
    // Update the view
    self.pseudoCellTextField.text = self.character.traits[self.editingIndexPath.row];
    [self textViewDidChange:self.pseudoCellTextField];
}

-(void)finishEditingTrait
{
    // Commit change
    NSString *existingTrait = self.character.traits[self.editingIndexPath.row];
    NSString *newTrait = self.pseudoCellTextField.text;
    [self.character changeTrait:existingTrait toTrait:newTrait];
    
    // Animate
    [UIView animateWithDuration:0.5 animations:
     ^{
        self.darkenLayer.alpha = 0;
        self.pseudoCell.frame = self.rectOfOriginalTableViewCell;
        [self.pseudoCellTextField resignFirstResponder]; //automatically dismisses keyboard
    } completion:
     ^(BOOL finished) {
        // Remove views
        [self.pseudoCell removeFromSuperview];
        [self.darkenLayer removeFromSuperview];
        
         // Reload trait table
         [self.tableView reloadData];
    }];
    
}

-(void)finishEditingNotes
{
    // Commit changes
    self.character.notes = self.editorTextView.text;
    self.notesTextView.text = self.character.notes;
    
    // Animation
    [UIView animateWithDuration:0.5 animations:^{
        self.darkenLayer.alpha = 0;
        self.editorTextView.frame = self.rectOfOriginalNotesView;
        [self.editorTextView resignFirstResponder];
    } completion:^(BOOL finished) {
        [self.darkenLayer removeFromSuperview];
        [self.editorTextView removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource Protocol
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = 0;
    
    if (self.character.traits) {
        numRows = [self.character.traits count];
    }
    
    return numRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.character.traits[indexPath.row];
    cell.textLabel.numberOfLines = 0;   // Allows multiple lines of text
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Traits";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITextView *textFieldForSizing = [[UITextView alloc]initWithFrame:CGRectZero];
    textFieldForSizing.font = [UIFont systemFontOfSize:17.0]; // This should match the font that the UITableViewCell is using
    textFieldForSizing.text = self.character.traits[indexPath.row];
    
    CGFloat fixedWidth = self.tableView.bounds.size.width;
    CGFloat minHeight = 44.0;
    CGSize newSize = [textFieldForSizing sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    
//    NSLog(@"Height for row: %li is %f", (long)indexPath.row, fmaxf(minHeight, newSize.height));
    
    return fmaxf(minHeight, newSize.height);
}

#pragma mark - UITableViewDelegate Protocol

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rectOfCellInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect rectOfCellInView = [self.tableView convertRect:rectOfCellInTableView toView:self.view];
    self.rectOfOriginalTableViewCell = rectOfCellInView;
    
    // Build pseudo-cell to edit in
    UIView *pseudoCell = [[UIView alloc]initWithFrame:rectOfCellInView];
    pseudoCell.backgroundColor = [UIColor whiteColor];
    
    // Set up text view used for editing trait cell
    UITextView *pseudoCellTextView = [[UITextView alloc]initWithFrame:CGRectMake(8, 0, pseudoCell.bounds.size.width - 8 - 8 - 8 - 44, pseudoCell.bounds.size.height)];
    pseudoCellTextView.delegate = self;
    pseudoCellTextView.scrollEnabled = NO;
    pseudoCellTextView.text = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    pseudoCellTextView.font = [UIFont systemFontOfSize:17.0];
    pseudoCellTextView.delegate = self;
    
    // Set up dice to randomize trait
    UIImageView *diceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(pseudoCell.bounds.size.width - 8 - 44, 0, 44, 44)];
    diceImageView.image = [UIImage imageNamed:@"dice.png"];
    diceImageView.contentMode = UIViewContentModeCenter;
    UITapGestureRecognizer *diceTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapTraitDice)];
    [diceImageView addGestureRecognizer:diceTapGestureRecognizer];
    diceImageView.userInteractionEnabled = YES;
    
    // Darken background
    UIView *darkenLayer = [[UIView alloc]initWithFrame:self.view.bounds];
    darkenLayer.backgroundColor = [UIColor blackColor];
    darkenLayer.alpha = 0.8;
    UITapGestureRecognizer *backgroundTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(finishEditingTrait)];
    [darkenLayer addGestureRecognizer:backgroundTapRecognizer];
    
    // Build view heirarchy
    [pseudoCell addSubview:pseudoCellTextView];
    [pseudoCell addSubview:diceImageView];
    [self.view addSubview:darkenLayer];
    [self.view addSubview:pseudoCell];
    
    // Animate
    [UIView animateWithDuration:0.5 animations:^{
        pseudoCell.frame = CGRectMake(0, 60, pseudoCell.bounds.size.width, pseudoCell.bounds.size.height);
        [pseudoCellTextView becomeFirstResponder];
    }];
    
    // Establish weak references for use elsewhere in class
    self.pseudoCell = pseudoCell;
    self.pseudoCellTextField = pseudoCellTextView;
    self.darkenLayer = darkenLayer;
    self.editingIndexPath = indexPath;
}

#pragma mark - UITextViewDelegate Protocol
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.pseudoCellTextField) {
        CGFloat fixedWidth = textView.bounds.size.width;
        CGFloat minHeight = 44.0;
        CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = textView.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), fmaxf(minHeight, newSize.height));
        textView.frame = newFrame;
        
        UIView *pseudoCell = textView.superview;
        CGRect oldSuperviewFrame = pseudoCell.frame;
        CGRect newSuperviewFrame = CGRectMake(oldSuperviewFrame.origin.x, oldSuperviewFrame.origin.y, oldSuperviewFrame.size.width, textView.frame.size.height);
        pseudoCell.frame = newSuperviewFrame;
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    BOOL output = YES;
    
    if (textView == self.notesTextView) {
        // Darken background
        UIView *darkenLayer = [[UIView alloc]initWithFrame:self.view.frame];
        darkenLayer.backgroundColor = [UIColor blackColor];
        darkenLayer.alpha = 0.8;
        UITapGestureRecognizer *backgroundTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(finishEditingNotes)];
        [darkenLayer addGestureRecognizer:backgroundTapRecognizer];
        self.darkenLayer = darkenLayer;
        
        // Create a text view for editing
        self.rectOfOriginalNotesView = self.notesTextView.frame;
        UITextView *editorTextView = [[UITextView alloc]initWithFrame:self.rectOfOriginalNotesView];
        editorTextView.text = self.notesTextView.text;
        editorTextView.font = self.notesTextView.font;
        self.editorTextView = editorTextView;
        
        [UIView animateWithDuration:0.5 animations:^{
            // Add UIView and rearrange order so that notesTextField is on top
            [self.view addSubview:darkenLayer];
            [self.view addSubview:editorTextView];
            
            // Move editorTextView up
            CGFloat topMargin = 60.0f;
            CGFloat estimatedKeyboardHeight = 250;
            self.editorTextView.frame = CGRectMake(self.rectOfOriginalNotesView.origin.x, topMargin, self.rectOfOriginalNotesView.size.width, self.view.bounds.size.height - topMargin - estimatedKeyboardHeight - topMargin);
            
            // Make editorTextView first responder
            [self.editorTextView becomeFirstResponder];
        }];
        
        output = NO;
    }
    
    return output;
}

#pragma mark - UITextFieldDelegate Protocal
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end

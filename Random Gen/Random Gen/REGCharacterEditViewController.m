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

@end

@implementation REGCharacterEditViewController

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
    [self.character randomizeOccupation];
    self.occupationField.text = self.character.occupation;
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
    
    return cell;
}

#pragma mark - UITableViewDelegate Protocol


@end

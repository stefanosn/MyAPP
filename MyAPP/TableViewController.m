//
//  ViewController.m
//  MyAPP
//
//  Created by stefanos neofitidis on 01/10/2021.
//  Copyright © 2021 Stefanos Neofytidis. All rights reserved.
//

#import "TableViewController.h"

@interface UIViewController ()


@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self cofigureTableview];
  creditList = [NSMutableArray arrayWithObjects:@"Test Movie 1", nil];
     // Do any additional setup after loading the view.
}

-(void)cofigureTableview
{
    self.loaddatatable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.loaddatatable.dataSource = self;
    self.loaddatatable.delegate = self;
   // [self.view addSubview:self.table];

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

NSString *sectionNameString = @"Current Jobs";
return sectionNameString;}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
  }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
      return creditList.count;
  }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

     cell.textLabel.text = [[creditList objectAtIndex:indexPath.row] capitalizedString];

     return cell;
  }

- (IBAction)pressMe:(id)sender {
    //self.label.text=@"stefanos";
     
}

-(void)hideLabel
{
   
   // self.label.hidden=YES;
    
    
}

@end

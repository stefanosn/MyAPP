//
//  ViewController.h
//  MyAPP
//
//  Created by stefanos neofitidis on 01/10/2021.
//  Copyright © 2021 Stefanos Neofytidis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface TableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
NSMutableArray *creditList;
}

@property (strong, nonatomic) IBOutlet UITableView *loaddatatable;


@end


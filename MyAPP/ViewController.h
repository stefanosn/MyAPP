//
//  ViewController.h
//  MyAPP
//
//  Created by stefanos neofitidis on 01/10/2021.
//  Copyright © 2021 Stefanos Neofytidis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <QuartzCore/QuartzCore.h>
#import "WalletViewController.h"
#import "AppDelegate.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
    NSMutableArray *creditList;
    NSMutableArray *communityKeys;
    NSMutableArray *sponsorshipKeys;
    NSMutableArray *Allkeys;
    NSMutableArray *communityValues;
    NSMutableArray * imageViewsArray;
    NSDictionary *s,*c;
    NSLock *arrayLock;
    
    UILabel *label1;
    UIActivityIndicatorView *spinner;
    UIRefreshControl *refreshControl;
    
    BOOL internet;
    BOOL waitnow;
    BOOL endofquerydata;
    int offs;
    
    AppDelegate *appDelegate1 ;
    WalletViewController *sample;
    
}

- (IBAction)segmented:(id)sender;
- (IBAction)pressMe:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *cat;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITableView *tabledata1;
@property(retain,nonatomic) NSMutableArray *userAccountsList;


@end



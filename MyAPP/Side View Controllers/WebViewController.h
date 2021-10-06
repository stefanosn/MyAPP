//
//  MasterViewController.h
//  MyAPP
//
//  Created by stefanos neofitidis on 04/10/2021.
//  Copyright © 2021 Stefanos Neofytidis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <QuartzCore/QuartzCore.h>
#import "WalletViewController.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController <WKNavigationDelegate>
{
    UIActivityIndicatorView *spinner1;
     AppDelegate *appDelegate1 ;
}

- (IBAction)segmentclick:(id)sender;
- (IBAction)but:(UIButton *)sender;
- (IBAction)butp:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (strong, nonatomic) IBOutlet UIButton *butorange;
@property (strong, nonatomic) IBOutlet UIButton *butpurple;
@property (strong, nonatomic) IBOutlet WKWebView *webv;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@end

NS_ASSUME_NONNULL_END

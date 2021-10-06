//
//  MasterViewController.m
//  MyAPP
//
//  Created by stefanos neofitidis on 04/10/2021.
//  Copyright © 2021 Stefanos Neofytidis. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize segmented=_segmented;
@synthesize spinner=_spinner;
@synthesize webv=_webv;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    appDelegate1 = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.webv.navigationDelegate=self;
    
    spinner1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    CGRect frame = spinner1.frame;
    frame.origin.x = self.view.frame.size.width / 2 - frame.size.width / 2;
    frame.origin.y = self.view.frame.size.height / 2 - frame.size.height / 2;
    spinner1.frame = frame;
    spinner1.tag = 22;
    spinner1.hidesWhenStopped = YES;
    
    [self.view addSubview:spinner1];
    [spinner1 startAnimating];
 
   dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
   dispatch_async(queue, ^{
      
       if ([self->appDelegate1.communityUrlToLoad isEqual:@"https://business.weare8.com/survey/s-127/"])
       {
           self->appDelegate1.communityUrlToLoad =@"http://business.weare8.com/survey/s-127/";
       }
       if ([self->appDelegate1.communityUrlToLoad isEqual:@"https://business.weare8.com/survey/knowhere-news-video-2/"])
       {
           self->appDelegate1.communityUrlToLoad =@"http://business.weare8.com/survey/knowhere-news-video-2/";
       }
       
       NSURL *url=[NSURL URLWithString:self->appDelegate1.communityUrlToLoad];
       NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
              
   dispatch_sync(dispatch_get_main_queue(), ^{
       
       [self->_webv loadRequest:request];
       self->_webv.hidden=false;
       
   });
   });
 

}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    [spinner1 startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [spinner1 stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Something Went Wrong!"
                                   message: [NSMutableString stringWithFormat:@"%@",[error localizedDescription]]
                                   preferredStyle:UIAlertControllerStyleAlert];
     
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {}];
     
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    [spinner1 stopAnimating];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    
}

- (IBAction)segmentclick:(UISegmentedControl*)sender {
      
    UISegmentedControl *s = (UISegmentedControl *)sender;

      if (s.selectedSegmentIndex == 1)
      {
         
         
          WalletViewController *sample = [self.storyboard instantiateViewControllerWithIdentifier:@"WalletViewController"];
          sample.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
          [self.view addSubview:sample.view];
     
      }
      else
      {
          ProfileViewController *sample = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
          sample.view.frame = CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height);
          [self.view addSubview:sample.view];
        
      }
    
}

- (IBAction)but:(UIButton *)sender {
   
    
    ProfileViewController *sample = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
      
    sample.view.frame = CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height);
       
    [UIView animateWithDuration:0.2
    animations:^{sample.view.alpha = 1.0;}
    completion:^(BOOL finished){ [self.view addSubview:sample.view];}];

}

- (IBAction)butp:(UIButton *)sender {
    
      WalletViewController *sample = [self.storyboard instantiateViewControllerWithIdentifier:@"WalletViewController"];
           
      sample.view.frame = CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height);
            
      [UIView animateWithDuration:0.2
      animations:^{sample.view.alpha = 1.0;}
      completion:^(BOOL finished){ [self.view addSubview:sample.view];}];
         
}

@end

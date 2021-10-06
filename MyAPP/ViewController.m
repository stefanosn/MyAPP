//
//  ViewController.m
//  MyAPP
//
//  Created by stefanos neofitidis on 01/10/2021.
//  Copyright © 2021 Stefanos Neofytidis. All rights reserved.
//

 /*
 This is the main view controller. An UITableView along with two UITableViewCells created on the storyboard exist for showing the json lists.
 We could have used seperate UITableViewCell classes but there is no need for this example. On load the app checks if internet connection exists and connects to the specified remote json urls and asynchronously using threads retrieves data.
 */

#import "ViewController.h"
#import "AppDelegate.h"

//NSLayoutConstraint triggered to help us find which constraint causes an issue on our interface.
@interface NSLayoutConstraint (Description)

@end

@implementation NSLayoutConstraint (Description)

-(NSString *)description {
    return [NSString stringWithFormat:@"id: %@, constant: %f attribute: %ld", self.identifier, self.constant,(long)self.firstAttribute];
}

@end
//NSLayoutConstraint end of implementation

//The ViewController interface uses UITableViewDelegate and UITableViewDataSource. These delegate are used to call functions of UITableView in order to help us manipulate and show the data.
@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController
//Synthesize the property/iboutlet, setter getter accessor/instance. We are gonna use the tabledata1 instance to change and set the properties of UITableView
@synthesize tabledata1 = _tabledata1;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //creation of an appDelegete so we can pass data between classes using the appDelegate instance
    appDelegate1 = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //setting the tabledata line seperator to none so we can add our custom line seperator
    [self.tabledata1 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    offs=0;
    
    endofquerydata=false;
    
    //initializing images array so we can keep track if an image is being used in a UITableViewCell or not. This way we wont have to connect more than once to retrieve each image of a cell
    imageViewsArray = [[NSMutableArray alloc] init];
    
    //Method to check if an internet connection is available
    [self checkForInternetConnection];
    
    self.label.hidden=YES;
    
    //if connection is OK then continue by showing a loading label and spinner until data retrieved from remote source
    if (internet==true)
    {
        
    //show loading label and spinner method
    [self ShowLoadingLabelAndSpinner ];
    
    //this is the most important function. It connects to both of the remote sources and retrieves json data and stores them into NSMutableArray  *communityKeys;  NSMutableArray *sponsorshipKeys; NSMutableArray *Allkeys;
    [self getCommunityAndSponsorshipJsonRemotely];
    
    //this function sets the delegates to the UITableView so all delegate functions can be triggered
    [self cofigureTableview];
        
    }
     

}

//Method that is triggered so we can check if a connection is available. Triggers a popup UIAlertAction if a connection is not available.
-(void)checkForInternetConnection
{
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.google.com/m"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    internet=false;
    if (data)
    { NSLog(@"Device is connected to the Internet");
        internet=true;
    }
    else
    {
      NSLog(@"Device is not connected to the Internet show popup");
       UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No Internet!"
                                       message:@"Please check your internet connection and try again!"
                                       preferredStyle:UIAlertControllerStyleAlert];
         
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {}];
         
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//This function sets the datasource and delegate as well as sets some other properties of the table
-(void)cofigureTableview
{
    
   self.tabledata1.dataSource= self;
   self.tabledata1.delegate= self;
   self.tabledata1.rowHeight = UITableViewAutomaticDimension;
   self.tabledata1.estimatedRowHeight = UITableViewAutomaticDimension;

}

//This function is triggered when the user scrolls from top to refresh the table
-(void)handleRefresh:(id)sender
{
    
    [self.tabledata1 reloadData];
    [self->refreshControl endRefreshing];
}

- (IBAction)pressMe:(id)sender {
    
     self.label.hidden=NO;
  
  
}

-(void)hideLabel
{
   
    self.label.hidden=YES;
    
    
}

//This action is triggered when the user taps the second or first item of the segmented control at the top. When pressed views change.
- (IBAction)segmented:(id)sender
{
      UISegmentedControl *s = (UISegmentedControl *)sender;

      if (s.selectedSegmentIndex == 1)
      {
        
          sample = [self.storyboard instantiateViewControllerWithIdentifier:@"WalletViewController"];
                    
                    
          //create transition and set the type,subtype to change to new view
          CATransition *transition = [CATransition new];
          transition.type = kCATransitionPush;
          transition.subtype = kCATransitionFromRight;

          sample.view.frame = CGRectMake(0, 33, self.view.bounds.size.width, self.view.bounds.size.height);
          [self.view addSubview:self->sample.view];
          
          // Add the transition
          [sample.view.layer addAnimation:transition forKey:@"transition"];

      }
      else
      {
       
          [UIView animateWithDuration:0.5
          delay:0.5
          options: UIViewAnimationOptionTransitionFlipFromLeft
          animations:^{
             self->sample.view.alpha = 0;
          }completion:^(BOOL finished){
              [self->sample.view removeFromSuperview];
          }];
     
          [self->sample.view removeFromSuperview];
  
      }
    
}

//Function called at the end of retrieval of the remote data from the json urls to merge the keys and data into one NSMutableArray. As well as it adds dummy string to imageViewsArray.
-(void)MergeData
{
    Allkeys = [[NSMutableArray alloc] init];
   
    for (int i=0;i<[self->sponsorshipKeys count];i++)
    {
            [Allkeys addObject:[sponsorshipKeys objectAtIndex:i]];
                     
            if (i<[self->communityKeys count])
            {
                [Allkeys addObject:[communityKeys objectAtIndex:i]];
            }
                    
     }
    
    for (int i=0;i<[self->Allkeys count];i++)
    {
    [imageViewsArray addObject:@"dummy"];
    }
    
}
//This function is triggered when the view loads for first time. While the user waits for data to be retrieved a spinner and a loading message appears. An internet connection should be available.
-(void)ShowLoadingLabelAndSpinner
{
    if (internet==true)
    {
            [[self navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil]];
                  
            refreshControl = [[UIRefreshControl alloc]init];
            [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
            [_tabledata1 addSubview:refreshControl];
                
            if (@available(iOS 10.0, *)) {
                      self.tabledata1.refreshControl = refreshControl;
                  } else {
                      [self.tabledata1 addSubview:refreshControl];
                  }
            
          sponsorshipKeys = [[NSMutableArray alloc] init];
          communityKeys = [[NSMutableArray alloc] init];
          communityValues = [[NSMutableArray alloc] init];
          arrayLock = [[NSLock alloc] init];
       
          
          label1 = [[UILabel alloc] initWithFrame:CGRectMake(300,200,210,200)];
          CGRect frame1 = label1.frame;
          frame1.origin.x = self.view.frame.size.width / 2-frame1.size.height / 2;
          frame1.origin.y = self.view.frame.size.height / 2 - frame1.size.height / 2+40;
          label1.frame = frame1;
          label1.text = @"Loading...";
          label1.textAlignment=NSTextAlignmentCenter;
          [self.view addSubview:label1];
          
          _tabledata1.hidden=YES;
            
          
          spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
          CGRect frame = spinner.frame;
          frame.origin.x = self.view.frame.size.width / 2 - frame.size.width / 2;
          frame.origin.y = self.view.frame.size.height / 2 - frame.size.height / 2;
          spinner.frame = frame;
          spinner.tag = 12;
          spinner.hidesWhenStopped = YES;//[spinner release];
          [self.view addSubview:spinner];
          [spinner startAnimating];
            
        }
}

//This function is called in order to retrieve the data from both json urls and store them into NSMutableArrays. First we retrieve all data from remote sources then we pass them to NSMutableArray and then we start showing them
-(void)getCommunityAndSponsorshipJsonRemotely
{

      if (internet==true)
      {
        
          //Use asynchronous connections to retrieve data by setting up a dispatch queue
          //first get the data from https://cdn-test.test.aws.the8app.com/communitytiles.json
      dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
         
      dispatch_async(downloadQueue, ^{
          
          //start the retrieval asynchronously using NSData dataWithContentsOfURL: and lock the thread for synchronization issues
      [self->arrayLock lock];
      
      [NSThread sleepForTimeInterval:1];
      NSString *path = [@"https://cdn-test.test.aws.the8app.com/communitytiles.json" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
      NSURL *url = [NSURL URLWithString:path];
           
      NSError *error = nil;
      NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached
             error:&error];
      BOOL feedisnil=false;
          
      //check if data are retrieved. Show a message on failure.
          if (data == nil)
             {
                 feedisnil=true;
                 NSDictionary *userInfo = [error userInfo];
                 NSString *message;
                 if (userInfo && [userInfo
                 objectForKey:NSUnderlyingErrorKey])
                 {
                 NSError *underlyingError = [userInfo
                              objectForKey:NSUnderlyingErrorKey];
                 message = [underlyingError localizedDescription];
                 NSLog(@"An error occurred in feed: %@",
                       message);
                 }
                 else
                 {
                     NSLog(@"An error occurred in feed: %@",
                                     [error localizedDescription]);
                 }
                 
                 
                 //do any UI stuff on the main UI thread
                 dispatch_async(dispatch_get_main_queue(), ^{
                             
                     [self->spinner stopAnimating];
                      self->label1.hidden=true;
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Something Went Wrong!"
                                                message: [NSMutableString stringWithFormat:@"%@",[error localizedDescription]]
                                                preferredStyle:UIAlertControllerStyleAlert];
                  
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action) {}];
                  
                 [alert addAction:defaultAction];
                 [self presentViewController:alert animated:YES completion:nil];
                         });
             }
             else
             {
                 NSLog(@"Everything's fine");
             }
             
             self->waitnow=true;
          
             if (feedisnil==false)
             {
        
             self->s = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
             NSMutableArray *keys1;
             keys1=[[NSMutableArray alloc] init];
             NSString *mediaImageUri_key = @"mediaImageUri";
             NSString *createdDate_key = @"createdDate";
             NSString *createdTimestampEpochInMilliseconds_key = @"createdTimestampEpochInMilliseconds";
             NSString *updatedDate_key = @"updatedDate";
             NSString *id_key = @"id";
             NSString *name_key = @"name";
             NSString *url_key = @"url";
             NSString *categoryType_key = @"categoryType";
                 

             for (NSDictionary *value in self->s) {
               
                 NSString *mediaImageUri_data = [value objectForKey:@"mediaImageUri"];
        
                 NSString *createdDate_data = [value objectForKey:@"createdDate"];
                
                 NSString *createdTimestampEpochInMilliseconds_data = [value objectForKey:@"createdTimestampEpochInMilliseconds"];
                 NSString *updatedDate_data = [value objectForKey:@"updatedDate"];
          
                 NSString *id_data = [value objectForKey:@"id"];
                 NSString *name_data = [value objectForKey:@"name"];
                 NSString *url_data = [value objectForKey:@"url"];
                 NSString *categoryType_data = [value objectForKey:@"categoryType"];
                
                 NSDictionary *dictionary;
                 dictionary=[[NSDictionary alloc] init];
                 dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              mediaImageUri_data,  mediaImageUri_key,createdDate_data,createdDate_key,
                               createdTimestampEpochInMilliseconds_data,createdTimestampEpochInMilliseconds_key , updatedDate_data ,updatedDate_key ,id_data,id_key,name_data,name_key,url_data,url_key,categoryType_data,categoryType_key,
                               nil];
               
                 [keys1 addObject:dictionary];
                 
             }
             
                 //unlock the thread
                 [self->arrayLock unlock];

                        //Use asynchronous connections to retrieve data by setting up a dispatch queue
                        // get the data from https://cdn-test.test.aws.the8app.com/feedsponsorships.json
                            [NSThread sleepForTimeInterval:1];
                            NSString *path = [@"https://cdn-test.test.aws.the8app.com/feedsponsorships.json" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                            NSURL *url = [NSURL URLWithString:path];
                            
                            NSError *error = nil;
                            NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached
                            error:&error];
                 
                            BOOL feedisnil=false;
                            if (data == nil)
                            {
                                feedisnil=true;
                                NSDictionary *userInfo = [error userInfo];
                                NSString *message;
                                if (userInfo && [userInfo
                                objectForKey:NSUnderlyingErrorKey])
                                {
                                NSError *underlyingError = [userInfo
                                             objectForKey:NSUnderlyingErrorKey];
                                message = [underlyingError localizedDescription];
                                NSLog(@"An error occurred in feed: %@",
                                      message);
                                }
                                else
                                {
                                    NSLog(@"An error occurred in feed: %@",
                                                    [error localizedDescription]);
                                }
                                
                                // do any UI stuff on the main UI thread
                                
                               dispatch_async(dispatch_get_main_queue(), ^{
                                            [self->spinner stopAnimating];
                                            self->label1.hidden=true;
                               UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Something Went Wrong!"
                                                               message: [NSMutableString stringWithFormat:@"%@",[error localizedDescription]]
                                                               preferredStyle:UIAlertControllerStyleAlert];
                                 
                                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
                                 
                                [alert addAction:defaultAction];
                                [self presentViewController:alert animated:YES completion:nil];
                                        });
                            }
                            else
                            {
                                NSLog(@"Everything's fine");
                            }
                               self->waitnow=true;
                            
                            NSMutableArray *keys2;
                            if (feedisnil==false)
                            {
                           // id jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                         self->c = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                   
                            
                            
                                        keys2=[[NSMutableArray alloc] init];
                            NSString *coverTileUri_key = @"coverTileUri";
                     
                            for (NSDictionary *value in self->c) {
                              
                                NSString *coverTileUri_data = [value objectForKey:@"coverTileUri"];
         
                                NSDictionary *dictionary;
                                dictionary=[[NSDictionary alloc] init];
                                dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                             coverTileUri_data,  coverTileUri_key,
                                              nil];
                              
                                [keys2 addObject:dictionary];
                                
                     
                            }
                                
                            }

           // do any UI stuff on the main UI thread
             dispatch_async(dispatch_get_main_queue(), ^{
                 
            //pass the temporary keys to the NSMutableArrays communityKeys and sponsorshipKeys
                                 for (NSDictionary *value in keys1)
                                 {
                                 [self->communityKeys addObject:value];
                                 }

                               for (NSDictionary *value in keys2)
                              {
                               [self->sponsorshipKeys addObject:value];
                              }
         //merge the data into one NSMutableArray
                 [self MergeData];
                 [self->_tabledata1 reloadData];
                 [self->spinner stopAnimating];
                 self->label1.hidden=YES;
   
                 if (([keys1 count]==20) && (self->endofquerydata==false))
                 {
                     self->endofquerydata=false;
                     self->offs+=20;
                     self->waitnow=false;
                 }
                 else
                 {
                 self->offs+=[keys1 count];
                 self->endofquerydata=true;
                 }
                
             });
             }
         });
        }
}


//Below are all the methods used from the UITableView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //we use the code below to check the offset of the tabledata when user pulls down to refresh
  if(self.tabledata1.contentOffset.y<0)
  {
      //it means table view is pulled down like refresh
      return;
   }
    else if(self.tabledata1.contentOffset.y >= (self.tabledata1.contentSize.height - self.tabledata1.bounds.size.height))
    {
      
        if (waitnow==false)
        {
            NSLog(@"bottom!");
       
        }
        
     }

}
//called just before a cell will be displayed
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row)
    {
        _tabledata1.hidden=NO;
    }
}
//called when we want to change the sections in the tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     
    return 1;
  }
//function called to pass the number of the total items retrieved from the remote sources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
      return [Allkeys count];
  }

//Change the Height of the Cell [Default is 44]:
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
 int a;
    
 if (indexPath.row % 2 != 0)
 {
        a=454;
 }
 else
 {
     a=404;
 }
    
  return a;
}

//Change the Height of the Cell [Default is 44]:
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath*)indexPath
{
 
  int a;
    
  if (indexPath.row % 2 != 0)
  {
      a=454;
  }
  else
  {
      a=404;
  }
    
   return a;
}

//called when a user taps on a UITableViewCell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   //NSLog(@"URL: %@", [[Allkeys objectAtIndex:indexPath.row] objectForKey:@"url"]);
   
   appDelegate1.communityUrlToLoad=(NSString*)[[Allkeys objectAtIndex:indexPath.row] objectForKey:@"url"];
}

//called to populate data asynchronously to the table, connect to the image url and store it in imageViewsArray. Then use imageViewsArray to show the image.
//Plus we make use of dequeueReusableCellWithIdentifier in combination with the identifier of the cell to to use less memory. We use tags for each item in our uitableviewcell. With tags we can retrieve each item and update it.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *tmpDict = [Allkeys objectAtIndex:indexPath.row];
    NSString *imageUrl =  [tmpDict objectForKey:@"mediaImageUri"];
 
    UITableViewCell *cell;
    //if imageUrl is a mediaImageUri from community json then use the second cell
    if (imageUrl)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"secondcellview" forIndexPath:indexPath];
        
      
        UIImageView *image1=[(UIImageView *)[cell viewWithTag:7]initWithImage:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
     
      
        if (imageUrl)
        {
            
            if (![[imageViewsArray objectAtIndex:indexPath.row]  isEqual:@"dummy"])
          {
            
              image1.image=[imageViewsArray objectAtIndex:indexPath.row];
           
          }
          else
          {
              
          dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
          dispatch_async(queue, ^{
              
              NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString: [[self->Allkeys objectAtIndex:indexPath.row] objectForKey:@"mediaImageUri"]]];
              
          dispatch_sync(dispatch_get_main_queue(), ^{
          
            image1.image=[UIImage imageWithData:imageData];
            
            [self->imageViewsArray replaceObjectAtIndex:indexPath.row withObject:image1.image];
              
              if (indexPath.row>0)
              {
            UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 0.5)];/// change size as you need.
                         separatorLineView.backgroundColor = [UIColor blackColor];// you can also put image here
                         separatorLineView.alpha=0.5;
                         [cell.contentView addSubview:separatorLineView];
              }
          });
          });
        }

          
           
      }
      
    }
    else
    {
        
    cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCellIdentifier" forIndexPath:indexPath];
  
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
        UIView *view1=(UIView*)[cell viewWithTag:8];
  
        // drop shadow around the UIVIew of the image
        [view1.layer setShadowColor:[UIColor blackColor].CGColor];
        [view1.layer setShadowOpacity:0.8];
        [view1.layer setShadowRadius:3.0];
        [view1.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
   
        UIImageView *image1=[(UIImageView *)[cell viewWithTag:3]initWithImage:nil];
       
        
        
                   if (![[imageViewsArray objectAtIndex:indexPath.row]  isEqual:@"dummy"])
                 {
                    
                     image1.image=[imageViewsArray objectAtIndex:indexPath.row];
              
                 }
                 else
                 {
          
               dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
               dispatch_async(queue, ^{
                   
                   NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString: [[self->Allkeys objectAtIndex:indexPath.row] objectForKey:@"coverTileUri"]]];
                   
               dispatch_sync(dispatch_get_main_queue(), ^{
                 
                 image1.image=[UIImage imageWithData:imageData];
               
                
                  [self->imageViewsArray replaceObjectAtIndex:indexPath.row withObject:image1.image];
                  if (indexPath.row>0)
                                               {
                                   UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 0.5)];/// change size as you need.
                                  
                                  separatorLineView.backgroundColor = [UIColor blackColor];
                                  separatorLineView.alpha=1.0;
                                  
                                  [separatorLineView.layer setShadowColor:[UIColor blackColor].CGColor];
                                  [separatorLineView.layer setShadowOpacity:0.8];
                                  [separatorLineView.layer setShadowRadius:3.0];
                                  [separatorLineView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
                                  [cell.contentView addSubview:separatorLineView];
                                               }
                                                
               });
               });
                 }
        
        
    }
  
     return cell;
  }

/* uncomment if you want to show a title header for the UITableView
 
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSLog(@"Something To Print123");
NSString *sectionNameString = @"Current Items";
return sectionNameString;
    
}
*/


@end

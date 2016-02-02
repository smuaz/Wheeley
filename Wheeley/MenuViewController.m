//
//  MenuViewController.m
//  Wheeley
//
//  Created by Syed Muaz on 9/24/14.
//  Copyright (c) 2014 l2pstudio. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface MenuViewController ()
@property (nonatomic, strong) UINavigationController *transitionsNavigationController;
- (IBAction)goHome:(id)sender;
- (IBAction)goOrder:(id)sender;
- (IBAction)logout:(id)sender;

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"LOAD MENU");
    self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
    /*
    PFQuery *query = [PFUser query];
    //NSArray *users = [query findObjects];
    //NSLog(@"users are  %@", users);

    
    [query whereKey:@"username" equalTo:@"syedmuaz@gmail.com"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"object are  %@", objects);
            // Do something with the found objects
            NSString *role = [[objects objectAtIndex:0] objectForKey:@"role"];
            NSLog(@"role is: %@",role);
           
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
     */

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goHome:(id)sender {
    
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"METransitionsNavigationController"];
    [self.slidingViewController resetTopViewAnimated:YES];

}

- (IBAction)goOrder:(id)sender {
    // When users indicate they are Giants fans, we subscribe them to that channel.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:@"PersonalShopper" forKey:@"channels"];
    [currentInstallation saveInBackground];
    
    /*
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Order"];
    [self.slidingViewController resetTopViewAnimated:YES];
     */
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];

    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end

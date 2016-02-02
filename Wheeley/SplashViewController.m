//
//  SplashViewController.m
//  Wheeley
//
//  Created by Syed Muaz on 9/25/14.
//  Copyright (c) 2014 l2pstudio. All rights reserved.
//

#import "SplashViewController.h"
#import "OrdersViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    // Check if user is logged in
    if ([PFUser currentUser]) {
        NSLog(@"is current user");
        NSString *role = [[PFUser currentUser] objectForKey:@"role"];
        NSLog(@"role role is: %@",role);
        if ([role isEqualToString:@"shopper"]) {
            UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalShopper"];
            //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];

            [self presentViewController:vc animated:NO completion:nil];
            
        } else {
            ECSlidingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Sliding"];
            [self.navigationController pushViewController:vc animated:NO];
        }
        
        //ECSlidingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Sliding"];
        //[self.navigationController pushViewController:vc animated:NO];
    }

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

@end

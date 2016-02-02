//
//  LoginViewController.m
//  Wheeley
//
//  Created by Syed Muaz on 9/24/14.
//  Copyright (c) 2014 l2pstudio. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "OrdersViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)goLogin:(id)sender;
@end

@implementation LoginViewController

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
    //ECSlidingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Sliding"];
    //[self.navigationController pushViewController:vc animated:NO];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"LOG IN";
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSignInView:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    

    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];

}

- (void)hideSignInView:(UITapGestureRecognizer*)Sender
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
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

- (IBAction)goLogin:(id)sender {
    if ([self.emailTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Email Field Empty"
                              message: @"Please enter your email."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([self.passwordTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Password Field Empty"
                              message: @"Please enter your password."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
    else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading";
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            
            [PFUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
                if (user) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    });
                    //[self dismissViewControllerAnimated:YES completion:nil];
                    
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
                    //[self.navigationController pushViewController:vc animated:YES];
                    
                } else {
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                }
            }];
            
            
        });
        
        
    }

 

}
@end

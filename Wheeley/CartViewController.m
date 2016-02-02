//
//  CartViewController.m
//  Wheeley
//
//  Created by Syed Muaz on 9/24/14.
//  Copyright (c) 2014 l2pstudio. All rights reserved.
//

#import "CartViewController.h"
#import "Product.h"

@interface CartViewController ()
@property (weak, nonatomic) IBOutlet UITableView *cartTableView;
@property (strong,nonatomic) NSMutableArray *cartArray;

- (IBAction)goCheckout:(id)sender;
@end

@implementation CartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clearCart
{
    PFQuery *query = [PFQuery queryWithClassName:@"Cart"];
    [query whereKey:@"userEmail" equalTo:[[PFUser currentUser] username]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully delete %d items", objects.count);
            // Do something with the found objects
            [PFObject deleteAllInBackground:objects block:^(BOOL succeeded, NSError *error) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

-(void)loadItem
{
    PFQuery *query = [PFQuery queryWithClassName:@"Cart"];
    [query whereKey:@"userEmail" equalTo:[[PFUser currentUser] username]];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            for (PFObject *object in objects)
            {
                NSLog(@"object are: %@",object);
                
                NSString *name = [object objectForKey:@"productName"];
                NSString *weight = [object objectForKey:@"productWeight"];
                NSString *category = [object objectForKey:@"productCategory"];
                NSNumber *price = [object objectForKey:@"productPrice"];
                PFFile *image = [object objectForKey:@"productImage"];
                

                Product *product = [[Product alloc] init];
                [product setName:name];
                [product setWeight:weight];
                [product setCategory:category];
                [product setPrice:price];
                [product setImage:image];

                [self.cartArray addObject:product];
                
                
            }
            
            [self.cartTableView reloadData];
            
            NSLog(@"array is: %@",self.cartArray);
            
            
        } else {
            
            //4
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    self.navigationItem.title = @"CART";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"previous.png"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(goBack)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *scheduleButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"trash.png"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(clearCart)];
    
    self.navigationItem.rightBarButtonItem = scheduleButton;

    self.cartArray = [[NSMutableArray alloc] init];
    
    [self loadItem];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cartArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    PFImageView *recipeImageView = (PFImageView *)[cell viewWithTag:350];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:351];
    UILabel *weightLabel = (UILabel *)[cell viewWithTag:352];
        
    Product *entry = [self.cartArray objectAtIndex:indexPath.row];
    NSLog(@"prod name is; %@",entry.name);
    nameLabel.text = entry.name;
    weightLabel.text = [NSString stringWithFormat:@"RM%@",entry.price];
    
    PFFile *thumbnail = entry.image;
    recipeImageView.file = thumbnail;
    [recipeImageView loadInBackground];
    
    return cell;
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

- (IBAction)goCheckout:(id)sender {
    

    PFObject *prod = [PFObject objectWithClassName:@"Order"];
    prod[@"userEmail"] = [[PFUser currentUser] username];
    prod[@"numberOfItems"] = [NSNumber numberWithInteger:self.cartArray.count];
    prod[@"status"] = @"New Order";
    [prod saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:@"PersonalShopper"];
        [push setMessage:@"You have new order"];
        [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self clearCart];
        }];
        //[self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    /*
    PFPush *push = [[PFPush alloc] init];
    [push setChannel:@"PersonalShopper"];
    [push setMessage:@"You have new order"];
    [push sendPushInBackground];
    
    [self dismissViewControllerAnimated:YES completion:nil];
     */
    
}
@end

//
//  OrdersViewController.m
//  Wheeley
//
//  Created by Syed Muaz on 9/25/14.
//  Copyright (c) 2014 l2pstudio. All rights reserved.
//

#import "OrdersViewController.h"
#import "Order.h"

@interface OrdersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *orderTableView;
@property (strong,nonatomic) NSMutableArray *orderArray;

- (IBAction)signOut:(id)sender;
@end

@implementation OrdersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadItem
{
    PFQuery *query = [PFQuery queryWithClassName:@"Order"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            for (PFObject *object in objects)
            {
                NSLog(@"object are: %@",object);
                
                NSString *orderID = object.objectId;
                NSDate *orderDate = object.createdAt;
                NSString *userEmail = [object objectForKey:@"userEmail"];
                NSString *status = [object objectForKey:@"status"];
                NSNumber *numberOfItems = [object objectForKey:@"numberOfItems"];
                
                NSLog(@"object id is: %@",orderID);
                
                Order *order = [[Order alloc] init];
                [order setOrderID:orderID];
                [order setOrderDate:orderDate];
                [order setUserEmail:userEmail];
                [order setStatus:status];
                [order setNumberOfItems:numberOfItems];
                
                [self.orderArray addObject:order];
                
                
            }
            
            [self.orderTableView reloadData];
            
            NSLog(@"array is: %@",self.orderArray);
            
            
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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"previous.png"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(signOut:)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.orderArray = [[NSMutableArray alloc] init];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor colorWithRed:106.0/255.0 green:176.0/255.0 blue:99.0/255.0 alpha:1.0];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.orderTableView addSubview:refreshControl];
    
    [self loadItem];
}

- (void)refresh:(id)sender {
    NSLog(@"Refreshing");
    
    [self.orderArray removeAllObjects]; // remove all data
    [self.orderTableView reloadData]; // before load new content, clear the existing table list
    [self loadItem]; // load new data
    //[weakSelf.tableView.pullToRefreshView stopAnimating]; // clear the animation
    [(UIRefreshControl *)sender endRefreshing];
    
    // once refresh, allow the infinite scroll again
    //self.tableView.showsInfiniteScrolling = YES;
    
    // End Refreshing
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orderArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILabel *orderNoLabel = (UILabel *)[cell viewWithTag:400];
    UILabel *orderDateLabel = (UILabel *)[cell viewWithTag:401];
    UILabel *orderUserLabel = (UILabel *)[cell viewWithTag:402];
    UILabel *orderItemsLabel = (UILabel *)[cell viewWithTag:403];
    UILabel *orderStatusLabel = (UILabel *)[cell viewWithTag:404];

    Order *entry = [self.orderArray objectAtIndex:indexPath.row];
    NSLog(@"order ID is; %@",entry.orderID);
    
    orderNoLabel.text = [NSString stringWithFormat:@"Order No: %@", entry.orderID];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:entry.orderDate
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    NSLog(@"%@",dateString);
    orderDateLabel.text = dateString;
    orderUserLabel.text = [NSString stringWithFormat:@"User: %@", entry.userEmail];
    orderItemsLabel.text = [NSString stringWithFormat:@"Number of Items: %@", entry.numberOfItems];
    orderStatusLabel.text = [NSString stringWithFormat:@"Status: %@",entry.status];
    
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

- (IBAction)signOut:(id)sender {
    [PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //[self.navigationController popToRootViewControllerAnimated:YES];

}
@end

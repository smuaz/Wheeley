//
//  MainViewController.m
//  Wheeley
//
//  Created by Syed Muaz on 9/24/14.
//  Copyright (c) 2014 l2pstudio. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "METransitions.h"
#import "ProductViewController.h"
#import "Product.h"
#import "CartViewController.h"
#import "UIBarButtonItem+Badge.h"

@interface MainViewController () {
    int selectedRow;
    int selectedColumn;
    int numberOfItemsInCart;

}
@property (nonatomic, strong) METransitions *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *productsArray;
@property (strong, nonatomic) NSMutableArray *array1;
@property (strong, nonatomic) NSMutableArray *array2;

- (IBAction)goToCart:(id)sender;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)badgeInfo
{
    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor colorWithRed:255.0/255.0 green:86.0/255.0 blue:0.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem.badgeMinSize = 10.0f;
    self.navigationItem.rightBarButtonItem.badgeOriginX = 14.0;
    self.navigationItem.rightBarButtonItem.badgeOriginY = -10.0;
    
    [self.navigationItem.rightBarButtonItem setShouldAnimateBadge:YES];
    [self.navigationItem.rightBarButtonItem setShouldHideBadgeAtZero:YES];
    
}

-(void)getNumberOfItemsInCart
{
    NSLog(@"getNumberOfItemsInCart");
    PFQuery *query = [PFQuery queryWithClassName:@"Cart"];
    [query whereKey:@"userEmail" equalTo:[[PFUser currentUser] username]];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            // The count request succeeded. Log the count
            NSLog(@"Items in cart is %d", count);
            if (count != 0) {
                self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%d",count];
                [self badgeInfo];
            } else {
                self.navigationItem.rightBarButtonItem.badgeValue = @"";
                [self badgeInfo];

            }
            
        } else {
            // The request failed
        }
    }];

}


- (void)refresh:(id)sender {
    NSLog(@"Refreshing");
    
    self.productsArray = nil; // remove all data
    [self.collectionView reloadData]; // before load new content, clear the existing table list
    [self loadItems]; // load new data
    //[weakSelf.tableView.pullToRefreshView stopAnimating]; // clear the animation
    [(UIRefreshControl *)sender endRefreshing];
    
    // once refresh, allow the infinite scroll again
    //self.tableView.showsInfiniteScrolling = YES;
    
    // End Refreshing
}

-(void)loadItems
{
    NSMutableArray *array1 = [[NSMutableArray alloc] init];
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    NSMutableArray *array3 = [[NSMutableArray alloc] init];

    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Product"];
    //[query orderByAscending:@"name"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            for (PFObject *object in objects)
            {
                //NSLog(@"object are: %@",[object objectForKey:@"category"]);
                
                
                
                if ([[object objectForKey:@"category"] isEqualToString:@"Fresh Food"]) {
                    
                    NSString *name = [object objectForKey:@"name"];
                    NSString *weight = [object objectForKey:@"weight"];
                    NSString *category = [object objectForKey:@"category"];
                    NSNumber *price = [object objectForKey:@"price"];
                    PFFile *image = [object objectForKey:@"image"];
                    
                    Product *product = [[Product alloc] init];
                    [product setName:name];
                    [product setWeight:weight];
                    [product setCategory:category];
                    [product setPrice:price];
                    [product setImage:image];
                    
                    [array1 addObject:product];
                }
                else if ([[object objectForKey:@"category"] isEqualToString:@"Grocery"]) {
                    
                    NSString *name = [object objectForKey:@"name"];
                    NSString *weight = [object objectForKey:@"weight"];
                    NSString *category = [object objectForKey:@"category"];
                    NSNumber *price = [object objectForKey:@"price"];
                    PFFile *image = [object objectForKey:@"image"];
                    
                    Product *product = [[Product alloc] init];
                    [product setName:name];
                    [product setWeight:weight];
                    [product setCategory:category];
                    [product setPrice:price];
                    [product setImage:image];
                    
                    [array2 addObject:product];
                }
                else if ([[object objectForKey:@"category"] isEqualToString:@"Baby"]) {
                    
                    NSString *name = [object objectForKey:@"name"];
                    NSString *weight = [object objectForKey:@"weight"];
                    NSString *category = [object objectForKey:@"category"];
                    NSNumber *price = [object objectForKey:@"price"];
                    PFFile *image = [object objectForKey:@"image"];
                    
                    Product *product = [[Product alloc] init];
                    [product setName:name];
                    [product setWeight:weight];
                    [product setCategory:category];
                    [product setPrice:price];
                    [product setImage:image];
                    
                    [array3 addObject:product];
                }

                
                
            }
            self.productsArray = [NSArray arrayWithObjects:array1, array2, array3, nil];
            
            [self.collectionView reloadData];
            
        } else {
            
            //4
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];

}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"view will appear");
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self getNumberOfItemsInCart];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.transitions.dynamicTransition.slidingViewController = self.slidingViewController;

    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
    self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
    [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
    [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;

    collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
    //[self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

    self.navigationItem.title = @"SHOP";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-button.png"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(menuButtonTapped:)];
    
    self.navigationItem.leftBarButtonItem = searchButton;
    
    
    UIImage *image = [UIImage imageNamed:@"carticon2.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,image.size.width, image.size.height);
    [button addTarget:self action:@selector(goToCart:) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:45.0/255.0 green:133.0/255.0 blue:232.0/255.0 alpha:1]];
    
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:45.0/255.0 green:133.0/255.0 blue:232.0/255.0 alpha:1]];
    self.navigationItem.rightBarButtonItem = navLeftButton;
    
    //self.navigationItem.rightBarButtonItem.badgeValue = @"";
    

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor colorWithRed:106.0/255.0 green:176.0/255.0 blue:99.0/255.0 alpha:1.0];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    [self loadItems];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.productsArray objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.productsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    PFImageView *recipeImageView = (PFImageView *)[cell viewWithTag:100];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:200];
    UILabel *weightLabel = (UILabel *)[cell viewWithTag:250];

    //recipeImageView.image = [UIImage imageNamed:[recipeImages objectAtIndex:indexPath.row]];
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];

    Product *entry = [self.productsArray[indexPath.section] objectAtIndex:indexPath.row];
    
    nameLabel.text = entry.name;
    weightLabel.text = [NSString stringWithFormat:@"RM%@",entry.price];

    PFFile *thumbnail = entry.image;
    recipeImageView.file = thumbnail;
    [recipeImageView loadInBackground];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //ProductViewController *vc = [[ProductViewController alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
    //vc = nil;
    selectedRow = indexPath.row;
    selectedColumn = indexPath.section;
    [self performSegueWithIdentifier:@"ProductDetails" sender:self];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    UILabel *nameLabel = (UILabel *)[self.view viewWithTag:300];
    //NSLog(@"section is: %d",indexPath.section);
    //NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
    //[nameLabel setText:title];
    
    
    if (indexPath.section == 1) {
        [nameLabel setText:@"Fresh Food"];
    }
    else if (indexPath.section == 0) {
        [nameLabel setText:@"Grocery"];
    }
    else if (indexPath.section == 2) {
        [nameLabel setText:@"Baby"];
    }
    
    //reusableview = headerView;
    return headerView;

}

#pragma mark - Properties

- (METransitions *)transitions {
    if (_transitions) return _transitions;
    
    _transitions = [[METransitions alloc] init];
    
    return _transitions;
}

- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;
    
    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transitions.dynamicTransition action:@selector(handlePanGesture:)];
    
    return _dynamicTransitionPanGesture;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    Product *entry = [self.productsArray[selectedColumn] objectAtIndex:selectedRow];
    NSLog(@"entry name: %@",entry.name);
    
    ProductViewController *detail = [segue destinationViewController];
    detail.product = entry;
    //[detail.detailLabel setText:entry.name];
    //[detail setStrDetail:entry.name];

}

- (IBAction)goToCart:(id)sender {
    UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CartNav"];
    //UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:cart];
    [self presentViewController:vc animated:YES completion:nil];
    
}
@end

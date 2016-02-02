//
//  ProductViewController.m
//  Wheeley
//
//  Created by Syed Muaz on 9/24/14.
//  Copyright (c) 2014 l2pstudio. All rights reserved.
//

#import "ProductViewController.h"

@interface ProductViewController ()

- (IBAction)addToCart:(id)sender;
@end

@implementation ProductViewController
@synthesize product;

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
    //Product *prod = [[Product alloc] init];
    
    [self.detailLabel setText:self.product.name];
    [self.weightLabel setText:self.product.weight];
    [self.priceLabel setText:[NSString stringWithFormat:@"RM %@",self.product.price]];
    
    PFFile *thumbnail = self.product.image;
    self.itemImage.file = thumbnail;
    [self.itemImage loadInBackground];

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

- (IBAction)addToCart:(id)sender {
    
    PFObject *prod = [PFObject objectWithClassName:@"Cart"];
    prod[@"productName"] = product.name;
    prod[@"productWeight"] = product.weight;
    prod[@"productPrice"] = product.price;
    prod[@"productCategory"] = product.category;
    prod[@"productImage"] = product.image;
    prod[@"userEmail"] = [[PFUser currentUser] username];
    [prod saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
}
@end

//
//  ProductViewController.h
//  Wheeley
//
//  Created by Syed Muaz on 9/24/14.
//  Copyright (c) 2014 l2pstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet PFImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) Product *product;
@end

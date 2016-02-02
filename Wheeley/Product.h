//
//  Product.h
//  Wheeley
//
//  Created by Syed Muaz on 9/24/14.
//  Copyright (c) 2014 l2pstudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *weight;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, retain) PFFile *image;
@end

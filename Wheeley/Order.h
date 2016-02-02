//
//  Order.h
//  Wheeley
//
//  Created by Syed Muaz on 9/25/14.
//  Copyright (c) 2014 l2pstudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject
@property (nonatomic, retain) NSString *orderID;
@property (nonatomic, retain) NSDate *orderDate;
@property (nonatomic, retain) NSString *userEmail;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSNumber *numberOfItems;
@end

//
//  Basket.h
//  Weave
//
//  Created by Nicholas Angeli on 23/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface Basket : NSObject

@property (nonatomic, strong) NSMutableArray *products;

+(Basket *)instance;

-(void)addProduct:(Product *)product;
-(float)basketTotal;

@end

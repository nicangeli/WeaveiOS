//
//  Basket.m
//  Weave
//
//  Created by Nicholas Angeli on 23/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "Basket.h"
#import "Product.h"

@implementation Basket

+ (Basket *)instance // singleton pattern
{
    static Basket *basket = nil;
    
    @synchronized(self)
    {
        if (!basket) {
            basket = [[Basket alloc] init];
        }
        
        return basket;
    }
}

-(void)addProduct:(Product *)product
{
    if(!self.products) {
        self.products = [[NSMutableArray alloc] initWithCapacity:5];
    }
    [self.products addObject:product];
}

-(float)basketTotal
{
    float total = 0.0f;
    for(Product *p in self.products) {
        total += [p getNumberPrice];
    }
    return total;
}



@end

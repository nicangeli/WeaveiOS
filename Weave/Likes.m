//
//  Likes.m
//  Weave
//
//  Created by Nicholas Angeli on 01/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "Likes.h"
#import "Product.h"

@implementation Likes

+ (Likes *)likes // singleton pattern
{
    static Likes *likes;
    
    @synchronized(self)
    {
        if (!likes) {
            likes = [[Likes alloc] init];
        }
        
        return likes;
    }
}


-(void)addProduct:(Product *)product {
    if(!likedProducts) {
        likedProducts = [[NSMutableArray alloc] init];
    }
    NSLog(@"Adding product %@", [product getTitle]);
    [likedProducts addObject:product];
}

-(NSMutableArray *)getLikes {
    return likedProducts;
}

-(void)removeProduct:(Product *)product
{
    [likedProducts removeObject:product];
}

-(void)removeProductAtIndex:(NSInteger )index
{
    [likedProducts removeObjectAtIndex:index];
}

-(void)print
{
    NSLog(@"Printing");
    NSLog(@"%d", [likedProducts count]);
}

-(NSInteger)count
{
    return [likedProducts count];
}

-(Product *)objectAtIndex:(NSUInteger)index
{
    return [likedProducts objectAtIndex:index];
}


@end

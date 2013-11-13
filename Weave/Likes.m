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

+ (Likes *)instance // singleton pattern
{
    static Likes *likes = nil;
    
    @synchronized(self)
    {
        if (!likes) {
            likes = [[Likes alloc] init];
        }
        
        return likes;
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:likedProducts forKey:@"LikedProducts"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        likedProducts = [aDecoder decodeObjectForKey:@"LikedProducts"];
    }
    return self;
}

-(void)addProduct:(Product *)product {
    NSLog(@"Add product called");
    if(!likedProducts) {
        likedProducts = [[NSMutableArray alloc] init];
    }
    NSLog(@"Adding product %@", [product getTitle]);
    [likedProducts addObject:product];
}

-(NSMutableArray *)getLikes {
    return likedProducts;
}

-(void)setLikes:(NSMutableArray *)likes
{
    NSLog(@"Set likes is called");
    if(!likedProducts)
    {
        likedProducts = likes;
    } else {
        likedProducts = [[NSMutableArray alloc] initWithArray:likes];
    }
}

-(void)removeProduct:(Product *)product
{
    [likedProducts removeObject:product];
}

-(void)removeProductAtIndex:(NSInteger )index
{
    [likedProducts removeObjectAtIndex:index];
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

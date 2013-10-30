//
//  Likes.h
//  Weave
//
//  Created by Nicholas Angeli on 01/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Product;

@interface Likes : NSObject <NSCoding> {
    NSMutableArray *likedProducts;
}

+(Likes *)instance;

-(NSMutableArray *)getLikes;
-(void)setLikes:(NSMutableArray *)likes;
-(void)addProduct:(Product *)product;
-(void)removeProduct:(Product *)product;
-(void)removeProductAtIndex:(NSInteger )index;
-(NSInteger )count;
-(Product *)objectAtIndex:(NSUInteger)index;

@end

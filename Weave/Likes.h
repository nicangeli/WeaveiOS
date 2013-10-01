//
//  Likes.h
//  Weave
//
//  Created by Nicholas Angeli on 01/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface Likes : NSObject {
    NSMutableArray *likedProducts;
}

+(Likes *)likes;

-(NSMutableArray *)getLikes;
-(void)addProduct:(Product *)product;
-(void)removeProduct:(Product *)product;
-(void)removeProductAtIndex:(NSInteger )index;
-(void)print;
-(NSInteger )count;
-(Product *)objectAtIndex:(NSUInteger)index;

@end

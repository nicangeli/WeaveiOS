//
//  Collection.h
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "ProductViewController.h"

@class ProductViewController;

@interface Collection : NSObject {
    NSMutableArray *products;
}

@property (nonatomic, strong) ProductViewController *calling;

+(Collection *)instance;
-(NSNumber *)numberOfProducts;
-(Product *)getNextProduct;
-(void)loadNextCollectionForBrands:(NSMutableArray *)brands;
-(void)clearCollection;

@end

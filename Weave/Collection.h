//
//  Collection.h
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ProductViewController;
@class Product;
@class Brand;

@protocol CollectionDelegate <NSObject>

-(void)didDownloadAllProducts;
-(void)didFailOnDownloadProducts;

@end

@interface Collection : NSObject {
    NSMutableArray *products;
}

@property (nonatomic, strong) ProductViewController *calling;
@property (nonatomic, strong) NSString *lastSeenDate;
@property (nonatomic, retain) id<CollectionDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *currentProductSelection;


+(Collection *)instance;
-(NSNumber *)numberOfProducts;
-(Product *)getNextProduct;
-(void)loadNextCollectionForBrands:(NSMutableArray *)brands;
-(void)setCurrentProductSelectionForBrands:(NSMutableArray *)brands;
-(void)clearCollection;
-(NSNumber *)count;
-(void)removeProductsThatAreNotIn:(NSMutableArray *)brands;
-(NSMutableArray *)getProducts;
-(NSMutableArray *)getArchivedProducts;
-(void)setProducts:(NSMutableArray *)myProducts;
-(void)getAllProducts;
-(NSInteger)numberOfProductsForBrand:(Brand *)brand;
-(void)updateSelectionForCategories;

@end

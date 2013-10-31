//
//  Collection.m
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "Collection.h"
#import "Product.h"
#import "Brand.h"
#import "ProductViewController.h"
#import "Strings.h"
#import "AFHTTPRequestOperationManager.h"
#import "NoLikesViewController.h"

@implementation Collection

+(Collection *)instance
{
    static Collection *collection = nil;
    @synchronized(self)
    {
        if(!collection) {
            collection = [[Collection alloc] init];
        }
        
        return collection;
    }
}

-(Product *)getNextProduct
{
    if([self.currentProductSelection count] == 0) {
        return nil;
    }
    NSUInteger index = arc4random() % [self.currentProductSelection count];
    Product *p = [self.currentProductSelection objectAtIndex:index];
    [products removeObject:p];
    [self.currentProductSelection removeObject:p];
    return p;
}

-(NSNumber *)numberOfProducts {
    return [NSNumber numberWithInt:[products count]];
}

-(NSNumber *) count {
    return [NSNumber numberWithInt:[products count]];
}

-(void)clearCollection
{
    products = nil;
}

-(NSString *)buildBrandStringFromArray:(NSArray *)brands
{
    NSMutableArray *brandsStrings = [[NSMutableArray alloc] initWithCapacity:5];
    for(Brand *b in brands) {
        [brandsStrings addObject:[b getName]];
    }
    NSString *brandString = [brandsStrings componentsJoinedByString:@","];
    NSLog(@"Brand String: %@", brandString);
    return brandString;
}

-(void)removeProductsThatAreNotIn:(NSMutableArray *)brands
{
    NSLog(@"Removing products...");
    NSString *str = [self buildBrandStringFromArray:brands];
    NSLog(@"Products before: %d", [products count]);
    for(NSInteger i = 0; i < [products count]; i++) {
        Product *p = [products objectAtIndex:i];
        NSString *productShop = [p getShop];
        if(![brands containsObject:productShop]) {
            // product is not one we want anymore, remove it
            NSLog(@"Removing Object from shop: %@", [p getShop]);
            [products removeObjectAtIndex:i];
        }
    }
    NSLog(@"Products after: %d", [products count]);
}

-(NSMutableArray *)getProducts
{
    return products;
}


-(void)setProducts:(NSMutableArray *)myProducts
{
    products = myProducts;
}

-(void)getAllProducts
{
    Strings *s= [Strings instance];
    
    //NSArray *objects = [NSArray arrayWithObjects:[[Mixpanel sharedInstance] distinctId], b, nil];
    
    NSArray *keys = [NSArray arrayWithObjects:@"UDID", nil];
    NSArray *objects = [NSArray arrayWithObjects:[[Mixpanel sharedInstance] distinctId], nil];

    NSDictionary *paramaters = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:s.baseAPIURLAll parameters:paramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *jsonArray = [NSMutableArray arrayWithArray:responseObject];
        
        for(NSDictionary *dic in jsonArray) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"images"]];
            Product *p = [[Product alloc] initWithTitle:[dic objectForKey:@"title"] url:[dic objectForKey:@"url"] price:[dic objectForKey:@"price"] shop:[dic objectForKey:@"shop"] brand:[dic objectForKey:@"brand"] imageUrls:array category:[dic objectForKey:@"category"] subcategory:[dic objectForKey:@"subcategory"] materials:[dic objectForKey:@"materials"] collectionDate:[dic objectForKey:@"collectionDate"]];
            
            if(!products) {
                products = [[NSMutableArray alloc] initWithCapacity:20];
            } else {
                if([p doesNotExistInCollection:self]) { // do we already have this product in the array? 
                    [products addObject:p];
                }
            }
        }
        if([jsonArray count] != 0) {
            self.lastSeenDate = [[jsonArray objectAtIndex:[jsonArray count]-1] objectForKey:@"collectionDate"];
        }
        [self.delegate didDownloadAllProducts];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
        [self.delegate didFailOnDownloadProducts];
    }];
}

-(NSInteger)numberOfProductsForBrand:(Brand *)brand
{
    NSInteger count = 0;
    for(Product *p in products) {
        if([[p getShop] isEqualToString:[brand getName]]) {
            count++;
        }
    }
    return count;
}

-(void)setCurrentProductSelectionForBrands:(NSMutableArray *)brands
{
    NSMutableArray *brandStrings = [[NSMutableArray alloc] init];
    for(Brand *b in brands) {
        [brandStrings addObject:[b getName]];
    }
    for(NSInteger i = 0; i < [products count]; i++) {
        Product *p = [products objectAtIndex:i];
        if([brandStrings containsObject:[p getShop]]) {
            if(!self.currentProductSelection) {
                self.currentProductSelection = [[NSMutableArray alloc] init];
            }
            [self.currentProductSelection addObject:p];
        }
    }
    NSLog(@"%d products in the current selection ", [self.currentProductSelection count]);
}

@end

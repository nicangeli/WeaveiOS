//
//  Collection.m
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "Collection.h"
#import "Product.h"
#import "Strings.h"
#import "AFHTTPRequestOperationManager.h"
#import "Mixpanel.h"
#import "NoLikesViewController.h"
#import "Brand.h"
#import "AppDelegate.h"

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
    if([products count] == 0) {
        return nil;
    }
    NSUInteger index = arc4random() % [products count];
    Product *p = [products objectAtIndex:index];
    [products removeObject:p];
    return p;
}

-(NSNumber *)numberOfProducts {
    return [NSNumber numberWithInt:[products count]];
}

-(NSNumber *) count {
    return [NSNumber numberWithInt:[products count]];
}

-(void)loadNextCollectionForBrands:(NSMutableArray *)brands
{
    NSLog(@"LOAD NEXT COLLECTION FOR BRANDS IS CALLED");
    Strings *s= [Strings instance];
    NSArray *keys = [NSArray arrayWithObjects:@"UDID", @"shops", @"version", nil];
    NSString *b = [self buildBrandStringFromArray:brands];
    NSLog(@"Brands: %@", b);
    NSArray *objects = [NSArray arrayWithObjects:[[Mixpanel sharedInstance] distinctId], b, [AppDelegate appVersion], nil];

    //NSArray *objects = [NSArray arrayWithObjects:[[Mixpanel sharedInstance] distinctId], b, nil];
    NSDictionary *paramaters = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager POST:s.baseAPIURL parameters:paramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"I have downloaded the data");
                
        NSMutableArray *jsonArray = [NSMutableArray arrayWithArray:responseObject];
        
        for(NSDictionary *dic in jsonArray) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"images"]];
            Product *p = [[Product alloc] initWithTitle:[dic objectForKey:@"title"] url:[dic objectForKey:@"url"] price:[dic objectForKey:@"price"] shop:[dic objectForKey:@"shop"] brand:[dic objectForKey:@"brand"] imageUrls:array category:[dic objectForKey:@"category"] subcategory:[dic objectForKey:@"subcategory"] materials:[dic objectForKey:@"materials"] collectionDate:[dic objectForKey:@"collectionDate"]];
                    //NSLog(@"Made new product object: %@", [p getTitle]);
            if(!products) {
                products = [[NSMutableArray alloc] initWithCapacity:20];
            }
           [products addObject:p];
            }
                
            [self.calling downloadFinished];
                
                
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"Error: %@", error);
            [self.calling showNetworkError];
        }];
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

@end

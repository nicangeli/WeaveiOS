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

-(void)loadNextCollectionForBrands:(NSMutableArray *)brands
{
    NSLog(@"LOAD NEXT COLLECTION FOR BRANDS IS CALLED");
    Strings *s= [Strings instance];
    NSArray *keys = [NSArray arrayWithObjects:@"UDID", @"shops", nil];
    NSString *b = [self buildBrandStringFromArray:brands];
    NSArray *objects = [NSArray arrayWithObjects:[[Mixpanel sharedInstance] distinctId], b, nil];

    //NSArray *objects = [NSArray arrayWithObjects:[[Mixpanel sharedInstance] distinctId], b, nil];
    NSDictionary *paramaters = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager POST:s.baseAPIURL parameters:paramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"I have downloaded the data");
                
        NSMutableArray *jsonArray = [NSMutableArray arrayWithArray:responseObject];
        //NSLog(@"%@", jsonArray);
                
        for(NSDictionary *dic in jsonArray) {
            Product *p = [[Product alloc] initWithTitle:[dic objectForKey:@"title"] url:[dic objectForKey:@"url"] price:[dic objectForKey:@"price"] shop:[dic objectForKey:@"shop"] brand:[dic objectForKey:@"brand"] type:[dic objectForKey:@"type"] imageUrl:[dic objectForKey:@"imageUrl"]];
                    //NSLog(@"Made new product object: %@", [p getTitle]);
            if(!products) {
                products = [[NSMutableArray alloc] initWithCapacity:20];
            }
           [products addObject:p];
            }
                
            [self.calling downloadFinished];
                
                
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"Error: %@", error);
            // handle the error on no network connection here
            // we obviously have no network connection, but the API is down
           /* UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NoLikesViewController *controller = (NoLikesViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NoLikes"];
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.calling presentViewController:navController
                                                    animated:YES
                                                  completion:nil];
            */
            [self.calling showNetworkError];
        }];
}

-(NSString *)buildBrandStringFromArray:(NSArray *)brands
{
    NSMutableArray *brandsStrings = [[NSMutableArray alloc] initWithCapacity:5];
    for(Brand *b in brands) {
        [brandsStrings addObject:[b getName]];
    }
    NSString *brandString = [brandsStrings componentsJoinedByString:@","];
    return brandString;
}

-(void)print
{
    for(Product *p in products) {
    //    NSLog(@"%@", [p getTitle]);
    }
}

@end

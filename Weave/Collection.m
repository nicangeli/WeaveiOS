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

-(void)loadNextCollectionForBrands:(NSArray *)brands
{
    Strings *s= [Strings instance];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *paramaters;
    if(![defaults stringArrayForKey:@"brands"]) {
        paramaters = @{@"UDID": [[Mixpanel sharedInstance] distinctId]};
    } else {
        NSArray *keys = [NSArray arrayWithObjects:@"UDID", @"shops", nil];
        NSArray *brands = [defaults stringArrayForKey:@"brands"];
        NSString *b = [brands componentsJoinedByString:@","];
        NSLog(@"%@", b);
        NSArray *objects = [NSArray arrayWithObjects:[[Mixpanel sharedInstance] distinctId], b, nil];
        paramaters = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager POST:s.baseAPIURL parameters:paramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"I have downloaded the data");

        NSMutableArray *jsonArray = [NSMutableArray arrayWithArray:responseObject];
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
    }];
}

-(void)print
{
    for(Product *p in products) {
        NSLog(@"%@", [p getTitle]);
    }
}

@end

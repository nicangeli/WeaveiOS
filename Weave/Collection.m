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

-(void)loadNextCollection
{
    Strings *s= [Strings instance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSDictionary *parameters = @{@"UDID": [self GetUUID]};
    //NSLog(@"%@", [self GetUUID]);
    //NSDictionary *parameters = @{@"UDID": @"nicholasangeli"};
    [manager POST:s.baseAPIURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"I have downloaded the data");

        NSMutableArray *jsonArray = [NSMutableArray arrayWithArray:responseObject];
        for(NSDictionary *dic in jsonArray) {
            Product *p = [[Product alloc] initWithTitle:[dic objectForKey:@"title"] url:[dic objectForKey:@"url"] price:[dic objectForKey:@"price"] shop:[dic objectForKey:@"shop"] brand:[dic objectForKey:@"brand"] type:[dic objectForKey:@"type"] imageUrl:[dic objectForKey:@"imageUrl"]];
            NSLog(@"Made new product object: %@", [p getTitle]);
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


- (NSString *)GetUUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    return (__bridge NSString *)(string);
}



@end

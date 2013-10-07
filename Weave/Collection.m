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

-(id)init
{
    self = [super init];
    if(self != nil) {
       /* NSString *filePath = [[NSBundle mainBundle] pathForResource:@"new_in" ofType:@"json"];
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        
        NSArray *items = [json valueForKeyPath:@"items"];
        NSEnumerator *enumerator = [items objectEnumerator];
        NSDictionary *item;
        products = [[NSMutableArray alloc] initWithCapacity:41];
        
        while(item = (NSDictionary *)[enumerator nextObject]) {
            Product *p = [[Product alloc] initWithTitle:[item objectForKey:@"title"] url:[item objectForKey:@"url"] price:[item objectForKey:@"price"] shop:[item objectForKey:@"shop"] brand:[item objectForKey:@"brand"] type:[item objectForKey:@"type"] imageUrl:[item objectForKey:@"imageUrl"]];
            [products addObject:p];
            
        }
        */
        [self loadNextCollection];
    }
    return self;
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

    //NSDictionary *parameters = @{@"UDID": [self GetUUID]};
    NSDictionary *parameters = @{@"UDID": @"afhifniaej"};
    [manager POST:s.baseAPIURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"I have downloaded the data");

        NSMutableArray *jsonArray = [NSMutableArray arrayWithArray:responseObject];
        for(NSDictionary *dic in jsonArray) {
            Product *p = [[Product alloc] initWithTitle:[dic objectForKey:@"title"] url:[dic objectForKey:@"url"] price:[dic objectForKey:@"price"] shop:[dic objectForKey:@"shop"] brand:[dic objectForKey:@"brand"] type:[dic objectForKey:@"type"] imageUrl:[dic objectForKey:@"imageUrl"]];
            [products addObject:p];
        }
      
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)load
{
    
}

- (NSString *)GetUUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    return (__bridge NSString *)(string);
}



@end

//
//  Collection.m
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "Collection.h"
#import "Product.h"

@implementation Collection

-(id)init
{
    self = [super init];
    if(self != nil) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"new_in" ofType:@"json"];
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
       // products = [[NSMutableArray alloc] initWithObjects:@"shoe1.jpg", @"shoe2.jpg", @"shoe3.jpg", @"shoe4.jpg", @"shoe5.jpg", @"shoe6.jpg", @"shoe7.jpg", @"shoe8.jpg", nil];
    }
    return self;
}


-(Product *)getNextProduct
{
    NSUInteger index = arc4random() % [products count];
    Product *p = [products objectAtIndex:index];
    [products removeObject:p];
    return p;
}



@end

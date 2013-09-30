//
//  Collection.m
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "Collection.h"

@implementation Collection

-(id)init
{
    self = [super init];
    if(self != nil) {
        products = [[NSMutableArray alloc] initWithObjects:@"shoe1.jpg", @"shoe2.jpg", @"shoe3.jpg", @"shoe4.jpg", @"shoe5.jpg", @"shoe6.jpg", @"shoe7.jpg", @"shoe8.jpg", nil];
    }
    return self;
}

-(NSString *)getRandomShoe
{
    NSUInteger randomIndex = arc4random() % [products count];
    return [products objectAtIndex:randomIndex];
}



@end

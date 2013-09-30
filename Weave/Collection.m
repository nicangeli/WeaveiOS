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
        products = [[NSMutableArray alloc] initWithObjects:@"tinder1.png", @"tinder2.png", @"tinder3.png", @"tinder4.png", @"tinder5.png", @"tinder6.png", @"tinder7.png", @"tinder8.png", nil];
    }
    return self;
}

-(NSString *)getRandomShoe
{
    NSUInteger randomIndex = arc4random() % [products count];
    return [products objectAtIndex:randomIndex];
}



@end

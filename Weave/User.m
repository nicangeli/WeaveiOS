//
//  User.m
//  Weave
//
//  Created by Nicholas Angeli on 11/11/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize categoryFilter;

+(User *)instance
{
    static User *user = nil;
    @synchronized(self)
    {
        if(!user) {
            user = [[User alloc] init];
        }
        
        return user;
    }
}

- (id)init {
    if (self = [super init]) {
        NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], nil];
        
        NSArray *keys = [NSArray arrayWithObjects:@"Dresses", @"Coats", @"Shoes", @"Skirts", @"Trousers", @"Jumpers", @"Lingerie", @"Swimwear", @"Accessories", @"Tops",  nil];
        
        categoryFilter = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
    }
    return self;
}

@end

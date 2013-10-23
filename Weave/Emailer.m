//
//  Emailer.m
//  Weave
//
//  Created by Nicholas Angeli on 23/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "Emailer.h"
#import "AFHTTPRequestOperationManager.h"
#import "Strings.h"
@implementation Emailer

-(void)sendEmailTo:(NSString *)emailAddress forBasket:(Basket *)basket
{
    Strings *s = [Strings instance];
    NSLog(@"Sending email to: %@", emailAddress);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"foo": @"bar"};
    
    
    
    [manager POST:s.emailBrandsURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

@end

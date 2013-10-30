//
//  Emailer.m
//  Weave
//
//  Created by Nicholas Angeli on 23/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "Emailer.h"
#import "Basket.h"
#import "AFHTTPRequestOperationManager.h"
#import "Strings.h"
#import "Product.h"

@implementation Emailer

-(void)sendEmailTo:(NSString *)emailAddress forBasket:(Basket *)basket
{
    Strings *s = [Strings instance];
    NSLog(@"Sending email to: %@", emailAddress);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //NSDictionary *parameters = @{@"foo": @"bar"};
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    for(Product *p in basket.products) {
        [urls addObject:[p getUrl]];
    }
    
    NSArray *objects = [NSArray arrayWithObjects:urls, emailAddress, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"urls", @"email", nil];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [manager POST:s.emailBrandsURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // successfully sent email
        [self.delegate didSendEmailForBasket];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

-(void)sendEmailTo:(NSString *)emailAddress forProducts:(NSMutableArray *)products
{
    Strings *s = [Strings instance];
    NSLog(@"Sending email to: %@", emailAddress);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //NSDictionary *parameters = @{@"foo": @"bar"};
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    for(Product *p in products) {
        [urls addObject:[p getUrl]];
    }
    
    NSArray *objects = [NSArray arrayWithObjects:urls, emailAddress, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"urls", @"email", nil];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [manager POST:s.emailBrandsURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // successfully sent email
        [self.delegate didSendEmailForBasket];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

@end

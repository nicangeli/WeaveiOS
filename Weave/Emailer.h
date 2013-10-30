//
//  Emailer.h
//  Weave
//
//  Created by Nicholas Angeli on 23/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Basket;

@protocol EmailerDelegate <NSObject>

-(void)didSendEmailForBasket;
@end

@interface Emailer : NSObject

@property (nonatomic, retain) id<EmailerDelegate> delegate;

-(void)sendEmailTo:(NSString *)emailAddress forBasket:(Basket *)basket;
-(void)sendEmailTo:(NSString *)emailAddress forProducts:(NSMutableArray *)products;

@end

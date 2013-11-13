//
//  User.h
//  Weave
//
//  Created by Nicholas Angeli on 11/11/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSMutableDictionary *categoryFilter;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *facebookUrl;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *email;

+(User *)instance;

-(void)getUserDetails;
-(void)setUser:(User *)user;


@end

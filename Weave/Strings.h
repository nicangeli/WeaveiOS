//
//  English.h
//  Weave
//
//  Created by Nicholas Angeli on 03/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Strings : NSObject

@property (nonatomic, strong) NSString *likeAlertMessage;
@property (nonatomic, strong) NSString *likeAlertTitle;
@property (nonatomic, strong) NSString *dislikeAlertMessage;
@property (nonatomic, strong) NSString *dislikeAlertTitle;

@property (nonatomic, strong) NSString *likeAlertMessageButton;
@property (nonatomic, strong) NSString *likeAlertTitleButton;
@property (nonatomic, strong) NSString *dislikeAlertMessageButton;
@property (nonatomic, strong) NSString *dislikeAlertTitleButton;

@property (nonatomic, strong) NSString *baseAPIURL;
@property (nonatomic, strong) NSString *loadingText;

@property (nonatomic, strong) NSString *brandsTitle;
@property (nonatomic, strong) NSString *brandsMessage;
@property (nonatomic, strong) NSString *productTitle;
@property (nonatomic, strong) NSString *productMessage;

@property (nonatomic, strong) NSString *internetDownTitle;
@property (nonatomic, strong) NSString *internetDownMessage;

+(Strings *)instance;


@end

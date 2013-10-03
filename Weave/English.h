//
//  English.h
//  Weave
//
//  Created by Nicholas Angeli on 03/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface English : NSObject

@property (nonatomic, strong) NSString *likeAlertMessage;
@property (nonatomic, strong) NSString *likeAlertTitle;
@property (nonatomic, strong) NSString *dislikeAlertMessage;
@property (nonatomic, strong) NSString *dislikeAlertTitle;

@property (nonatomic, strong) NSString *likeAlertMessageButton;
@property (nonatomic, strong) NSString *likeAlertTitleButton;
@property (nonatomic, strong) NSString *dislikeAlertMessageButton;
@property (nonatomic, strong) NSString *dislikeAlertTitleButton;

+(English *)instance;


@end

//
//  ReachabilityManager.h
//  Weave
//
//  Created by Nicholas Angeli on 31/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Reachability;

@interface ReachabilityManager : NSObject

@property (strong, nonatomic) Reachability *reachability;
#pragma mark -
#pragma mark Shared Manager
+ (ReachabilityManager *)sharedManager;
#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;
@end

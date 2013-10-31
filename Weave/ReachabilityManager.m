//
//  ReachabilityManager.m
//  Weave
//
//  Created by Nicholas Angeli on 31/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "ReachabilityManager.h"

@implementation ReachabilityManager

+ (ReachabilityManager *)sharedManager {
    static ReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)dealloc {
    // Stop Notifier
    if (_reachability) {
        [_reachability stopNotifier];
    }
}

+ (BOOL)isReachable {
    NSLog(@"Is reachable");
    return [[[ReachabilityManager sharedManager] reachability] isReachable];
}
+ (BOOL)isUnreachable {
    NSLog(@"Is unreachable");
    return ![[[ReachabilityManager sharedManager] reachability] isReachable];
}
+ (BOOL)isReachableViaWWAN {
    NSLog(@"Is reachable via WAN");
    return [[[ReachabilityManager sharedManager] reachability] isReachableViaWWAN];
}
+ (BOOL)isReachableViaWiFi {
    NSLog(@"Is reachable over Wifi");
    return [[[ReachabilityManager sharedManager] reachability] isReachableViaWiFi];
}

- (id)init {
    self = [super init];
    if (self) {
        // Initialize Reachability
        self.reachability = [Reachability reachabilityForInternetConnection];
        // Start Monitoring
        [self.reachability startNotifier];
    }
    return self;
}
@end
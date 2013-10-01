//
//  AppDelegate.h
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Likes.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    Likes *likes;
}

@property (strong, nonatomic) UIWindow *window;

-(Likes *)likes;

@end

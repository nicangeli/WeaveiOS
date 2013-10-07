//
//  English.m
//  Weave
//
//  Created by Nicholas Angeli on 03/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "Strings.h"

@implementation Strings

+ (Strings *)instance // singleton pattern
{
    static Strings *english = nil;
    
    @synchronized(self)
    {
        if (!english) {
            english = [[Strings alloc] init];
        }
        
        return english;
    }
}

-(id)init
{
    self = [super init];
    if(self != nil) {
        self.likeAlertMessage = @"Swiping right likes a product";
        self.likeAlertTitle = @"Liked item";
        self.likeAlertTitleButton = @"Liked Item";
        self.likeAlertMessageButton = @"Clicking like saves this product in your likes";
        self.dislikeAlertTitle = @"Disliked item";
        self.dislikeAlertTitleButton = @"Dislike item";
        self.dislikeAlertMessageButton = @"Clicking dislike means you'll never see this product again";
        self.dislikeAlertMessage = @"Swiping left dislikes a product";
        self.baseAPIURL = @"http://weaveuk.com/api/get";
    }
    return self;
}

@end

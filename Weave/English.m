//
//  English.m
//  Weave
//
//  Created by Nicholas Angeli on 03/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "English.h"

@implementation English

+ (English *)instance // singleton pattern
{
    static English *english = nil;
    
    @synchronized(self)
    {
        if (!english) {
            english = [[English alloc] init];
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
    }
    return self;
}

@end

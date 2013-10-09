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
        self.likeAlertMessage = @"Swiping right indicates that you like this product. It's been saved in your likes.";
        self.likeAlertTitle = @"Great";
        self.likeAlertTitleButton = @"Great";
        self.likeAlertMessageButton = @"Clicking the heart indicates that you like this product. It's been saved in your likes.";
        self.dislikeAlertTitle = @"Great";
        self.dislikeAlertTitleButton = @"Great";
        self.dislikeAlertMessageButton = @"Clicking the heart indicates that you don't like this product.";
        self.dislikeAlertMessage = @"Swiping left indicates that you don't like this product.";
        self.baseAPIURL = @"http://www.weaveuk.com/api/get";
        self.loadingText = @"Weaving...";
        self.brandsTitle = @"Where do you shop?";
        self.brandsMessage = @"Tap the logo of the brands you love to quickly review their new-in products ";
        self.productTitle = @"Do you like?";
        self.productMessage = @"Swipe or use the buttons to review each product. If you like it - save it!";
        self.internetDownTitle = @"Network Connectivity";
        self.internetDownMessage = @"Oh no! Weave needs an internet connection to work!";
    }
    return self;
}

@end

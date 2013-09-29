//
//  ProductView.h
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductViewController.h"

@interface ProductView : UIImageView <UIGestureRecognizerDelegate> {
    CGPoint startLocation;
}

-(IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
-(IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;

@end

//
//  ProductView.m
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "ProductView.h"
#import "ProductViewController.h"

@implementation ProductView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        startLocation = recognizer.view.center;
    }
    CGPoint translation = [recognizer translationInView:self];
    NSLog(@"%f, %f", translation.x, translation.y);
    //translation.x and translation.y are the distance that they've moved
    recognizer.view.center = CGPointMake(recognizer.view.center.x + (translation.x), recognizer.view.center.y + (translation.y));
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint finalPosition = CGPointMake(recognizer.view.center.x, recognizer.view.center.y);
        NSLog(@"Start x: %f y: %f", startLocation.x, startLocation.y);
        NSLog(@"Final x: %f y: %f", finalPosition.x, finalPosition.y);
        //    [self updateImageView:imageView withImageNamed:image];

       // ProductViewController *pvc =  = (ProductViewController *)self.window.rootViewController;
        //[pvc updateImageView:self withImageNamed:@"hello"];
        //[self.window.rootViewController updateImageView:self withImageNamed:@"hello"];
        NSLog(@"%@", self.superview.class);
    }
}


-(IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

/*
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGFloat dx = pt.x - startLocation.x;
    CGFloat dy = pt.y - startLocation.y;
    CGPoint newCenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    self.center = newCenter;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self];
    NSLog(@"Start Location: %f %f End location: %f %f", startLocation.x, startLocation.y, pt.x, pt.y);
    startLocation = pt;

}
 */

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

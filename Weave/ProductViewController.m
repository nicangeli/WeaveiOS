//
//  ProductViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "ProductViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Product.h"

@interface ProductViewController ()

@end

@implementation ProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    shoeCollection = [[Collection alloc] init];
    /*
        Add the product as an image to the polaroid root view (subview so it moves with drag)
     */
    UIImage *product = [UIImage imageNamed:@"shoe1.jpg"];
    UIImageView *productView = [[UIImageView alloc]initWithImage:product];
    [productView setTag:1001];
    productView.frame = CGRectMake(productView.frame.origin.x+50, productView.frame.origin.y+30, 200, 200);
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1002];
    [imageView addSubview:productView];
    
    /*
        Add label for product price and title etc. As subview so it moves with pan
     */
    UILabel *productLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 250, 250, 15)];
    [productLabel setText:@"Shoes"];
    [imageView addSubview:productLabel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)likeItem:(id)sender
{
    NSLog(@"Liking Item");
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
    //[imageView setImage:[UIImage imageNamed:@"shoe2.jpg"]];
    Product *p = [shoeCollection getRandomShoe];
    [self updateImageView:imageView withImageNamed:[p getImageUrl]];
    
}

-(IBAction)dislikeItem:(id)sender
{
    NSLog(@"Disliking item");
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
    Product *p = [shoeCollection getRandomShoe];
    [self updateImageView:imageView withImageNamed:[p getImageUrl]];


}

-(void)updateImageView:(UIImageView *)imageView withImageNamed:(NSString *)name
{
    [imageView setImage:[UIImage imageNamed:name]];
}


-(IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    UIImage *likeImage = [UIImage imageNamed:@"like.png"];
    UIImage *dislikeImage = [UIImage imageNamed:@"dislike.png"];
    UIImageView *likeImageView = [[UIImageView alloc] initWithImage:likeImage];
    UIImageView *dislikeImageView = [[UIImageView alloc] initWithImage:dislikeImage];
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
    
    if(recognizer.state == UIGestureRecognizerStateBegan) { // we have started to "move" the image around
        startLocation = recognizer.view.center;
    }
    
    //imageView.transform = CGAffineTransformMakeRotation(recognizer.view.center.x/(217));
    
    CGPoint translation = [recognizer translationInView:self.view];
    //translation.x and translation.y are the distance that they've moved
    // Are we moving left or right?
    CGPoint newLocation = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    BOOL like;
    if(newLocation.x < startLocation.x) {
        // we must be moving left of origin
        for(UIView *subView in imageView.subviews) { // get rid of the like and dislike image views
            [subView removeFromSuperview];
        }
        like = NO;
        [imageView addSubview:dislikeImageView]; // add the like image to the view
       // NSLog(@"%f, %f", dislikeImageView.center.x, dislikeImageView.center.y);
        dislikeImageView.alpha = 50/newLocation.x;

    } else if(newLocation.x > startLocation.x) {
        // we must be moving right of origin
        for(UIView *subView in imageView.subviews) { // get rid of the like and dislike image views
            [subView removeFromSuperview];
        }
        like = YES;
        [imageView addSubview:likeImageView]; // add the like image to the view
        /*
            Update the opactiy of like button depending on drag distance
         */
        likeImageView.alpha = 0.2;
        if(newLocation.x > 200) {
            likeImageView.alpha = 0.3;
        }
        if(newLocation.x > 220) {
            likeImageView.alpha = 0.4;
        }
        if(newLocation.x > 240) {
            likeImageView.alpha = 0.5;
        }
        if(newLocation.x > 260) {
            likeImageView.alpha = 0.6;
        }
        if(newLocation.x > 270) {
            likeImageView.alpha = 1;
        }
    }
    recognizer.view.center = newLocation;
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateEnded) { // we have "let go" of the image
        for(UIView *subView in imageView.subviews) { // get rid of the like and dislike image views
            [subView removeFromSuperview];
        }
        
        // have we dragged the picture far enough away from the origin to justify the
        BOOL movedEnough = YES;
        NSLog(@"Final location: %f, %f", recognizer.view.center.x, recognizer.view.center.y);
        if(recognizer.view.center.x < 270.0 && like){
            NSLog(@"Not moved far enough like to justify ");
            movedEnough = NO;
        }
        if(recognizer.view.center.x > 57 && !like) {
            NSLog(@"Not moved far enough dislike to justify");
            movedEnough = NO;
        }
        recognizer.view.center = startLocation; // move the image back to the start
        if(like && movedEnough) {
            NSLog(@"Moved enough to like");
            [self likeItem:nil]; // trigger the event that happens when you click on like
        } else if(!like && movedEnough) {
            NSLog(@"Moved enough to dislike");
            [self dislikeItem:nil];
        }
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




@end

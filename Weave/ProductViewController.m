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
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weave-nav.png"]];

	// Do any additional setup after loading the view.
    products = [[Collection alloc] init];
    Product *p = [products getNextProduct];
    
    /*
        Add the product as an image to the polaroid root view (subview so it moves with drag)
     */
    UIImage *product = [UIImage imageNamed:[p getImageUrl]];
    UIImageView *productView = [[UIImageView alloc]initWithImage:product];
    [productView setTag:1001];

    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1002];
    [imageView addSubview:productView];
    productView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect frame = imageView.frame;
    frame.size.width = 260;
    frame.size.height = 250;
    productView.frame = frame;
    productView.center = CGPointMake(168,157); // move the image view to the middle of the polaroid
    
    /*
        Add label for product price and title etc. As subview so it moves with pan
     */
    UILabel *productLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 50, self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [productLabel setTag:1003];
    [productLabel setText:[p getType]];
    [imageView addSubview:productLabel];
    if([[p getType] length] < 10) {
        NSLog(@"Less than 10");
        [productLabel setCenter:CGPointMake(220, imageView.frame.size.height-50)];
    } else if([[p getType] length] < 16) {
        NSLog(@"Less than 16");
        [productLabel setCenter:CGPointMake(200, imageView.frame.size.height-50)];
    } else{
        NSLog(@"More than 16");
        [productLabel setCenter:CGPointMake(180, imageView.frame.size.height-50)];
    }

    [self.view bringSubviewToFront:productLabel];
    
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
    Product *p = [products getNextProduct];
    [self updateImageView:imageView forProduct:p];
    
}

-(IBAction)dislikeItem:(id)sender
{
    NSLog(@"Disliking item");
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
    Product *p = [products getNextProduct];
    [self updateImageView:imageView forProduct:p];


}

-(void)updateImageView:(UIImageView *)imageView forProduct:(Product *)product
{
    [imageView setImage:[UIImage imageNamed:[product getImageUrl]]];
    [self updateLabelsForProduct:product inImageView:imageView];
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

-(void)updateLabelsForProduct:(Product *)product inImageView:(UIImageView *)imageView
{
    UILabel *label = (UILabel *)[self.view viewWithTag:1003]; // 1003 is the label that holds the title
    [label setText:[product getType]];
    if([[product getType] length] < 10) {
        NSLog(@"Less than 10");
        [label setCenter:CGPointMake(220, imageView.frame.size.height+60)];
    } else if([[product getType] length] < 16) {
        NSLog(@"Less than 16");
        [label setCenter:CGPointMake(200, imageView.frame.size.height+60)];
    } else{
        NSLog(@"More than 16");
        [label setCenter:CGPointMake(180, imageView.frame.size.height+60)];
    }
    [self.view bringSubviewToFront:label];

}




@end

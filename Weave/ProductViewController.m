//
//  ProductViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "ProductViewController.h"

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)likeItem:(id)sender
{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
    //[imageView setImage:[UIImage imageNamed:@"shoe2.jpg"]];
    NSString *image = [shoeCollection getRandomShoe];
    [self updateImageView:imageView withImageNamed:image];
    
}

-(IBAction)dislikeItem:(id)sender
{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
    NSString *image = [shoeCollection getRandomShoe];
    [self updateImageView:imageView withImageNamed:image];


}

-(void)updateImageView:(UIImageView *)imageView withImageNamed:(NSString *)name
{
    [imageView setImage:[UIImage imageNamed:name]];
}


-(IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        startLocation = recognizer.view.center;
    }
    CGPoint translation = [recognizer translationInView:self.view];
    NSLog(@"%f, %f", translation.x, translation.y);
    //translation.x and translation.y are the distance that they've moved
    recognizer.view.center = CGPointMake(recognizer.view.center.x + (translation.x), recognizer.view.center.y + (translation.y));
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint finalPosition = CGPointMake(recognizer.view.center.x, recognizer.view.center.y);
        NSLog(@"Start x: %f y: %f", startLocation.x, startLocation.y);
        NSLog(@"Final x: %f y: %f", finalPosition.x, finalPosition.y);
        recognizer.view.center = startLocation;
        [self likeItem:nil];
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

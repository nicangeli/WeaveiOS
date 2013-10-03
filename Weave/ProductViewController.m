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
#import "Likes.h"
#import "AppDelegate.h"
#import "English.h"

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

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder])) {
        [self loadLikes];
    }
       return self;
}

-(void)loadLikes {
    NSString *path = [self dataFilePath];
    NSLog(@"%@", path);
    Likes *likes = [Likes instance];
    // Do any additional setup after loading the view.
    products = [[Collection alloc] init];

    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        Likes *oldLikes = [unarchiver decodeObjectForKey:@"Likes"];
        [likes setLikes:[oldLikes getLikes]];

        [unarchiver finishDecoding];
        //[[delegate likes] getLikes] = [oldLikes getLikes];
    }
}
- (NSString *)GetUUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    return (__bridge NSString *)(string);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weave-nav.png"]];
    //NSLog(@"Documents folder is %@", [self documentsDirectory]);
    //NSLog(@"Data file is: %@", [self dataFilePath]);

    Product *p = [products getNextProduct];
    currentProduct = p;
    /*
        Add the product as an image to the polaroid root view (subview so it moves with drag)
     */
    UIImage *product = [UIImage imageNamed:[p getImageUrl]]; // image of the product on top of pile
    UIImageView *productView = [[UIImageView alloc]initWithImage:product]; // container for the image on top of pile
    [productView setTag:1001];

    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1002]; //the polaroid that sits on top of the stack
    [imageView addSubview:productView]; // add product on top of pile to the polaroid
    productView.contentMode = UIViewContentModeScaleAspectFit; // scale pic to the whole of the avaliable area
    
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
        [productLabel setCenter:CGPointMake(220, imageView.frame.size.height-50)];
    } else if([[p getType] length] < 16) {
        [productLabel setCenter:CGPointMake(200, imageView.frame.size.height-50)];
    } else{
        [productLabel setCenter:CGPointMake(180, imageView.frame.size.height-50)];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)hitLikeButton:(id)sender
{
    English *english = [English instance];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (! [defaults boolForKey:@"likeAlertShownButton"]) {
        // display alert...
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:english.likeAlertTitleButton
                                                        message:english.likeAlertMessageButton
                                                       delegate:nil
                                              cancelButtonTitle:@"Got it"
                                              otherButtonTitles:nil];
        [alert show];
        [defaults setBool:YES forKey:@"likeAlertShownButton"];
    }
    [self likeItem];
}

-(IBAction)hitDislikeButton:(id)sender
{
    English *english = [English instance];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (! [defaults boolForKey:@"dislikeAlertShownButton"]) {
        // display alert...
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:english.dislikeAlertTitleButton
                                                        message:english.dislikeAlertMessageButton
                                                       delegate:nil
                                              cancelButtonTitle:@"Got it"
                                              otherButtonTitles:nil];
        [alert show];
        [defaults setBool:YES forKey:@"dislikeAlertShownButton"];
    }
    [self dislikeItem];
}


-(void)likeItem
{
    Likes *likes = [Likes instance];
    [likes addProduct:currentProduct];
    [likes print];
    
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
    //[imageView setImage:[UIImage imageNamed:@"shoe2.jpg"]];
    Product *p = [products getNextProduct];
    if(p == nil) {
        [self.navigationController performSegueWithIdentifier:@"NoLikesLeft" sender:self];
    }
    currentProduct = p;
    [self saveLikes];
    [self updateImageView:imageView forProduct:p];
}

-(void)dislikeItem
{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
    Product *p = [products getNextProduct];
    if(p == nil){
        [self.navigationController performSegueWithIdentifier:@"NoLikesLeft" sender:self];
    }
    currentProduct = p;
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
        dislikeImageView.center = CGPointMake(220, 60);
        dislikeImageView.transform = CGAffineTransformMakeRotation(1.0);

    } else if(newLocation.x > startLocation.x) {
        // we must be moving right of origin
        for(UIView *subView in imageView.subviews) { // get rid of the like and dislike image views
            [subView removeFromSuperview];
        }
        like = YES;
        [imageView addSubview:likeImageView]; // add the like image to the view
        likeImageView.center = CGPointMake(40, 40);
        likeImageView.transform = CGAffineTransformMakeRotation(-0.7);

    }
    recognizer.view.center = newLocation;
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateEnded) { // we have "let go" of the image
        for(UIView *subView in imageView.subviews) { // get rid of the like and dislike image views
            [subView removeFromSuperview];
        }
        
        // have we dragged the picture far enough away from the origin to justify the
        BOOL movedEnough = YES;
        if(recognizer.view.center.x < 270.0 && like){
            movedEnough = NO;
        }
        if(recognizer.view.center.x > 57 && !like) {
            movedEnough = NO;
        }
        recognizer.view.center = startLocation; // move the image back to the start
        if(like && movedEnough) {
            
            /*
                Display the like alert dialog only onece for swipe
             */
            English *english = [English instance];
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            if (! [defaults boolForKey:@"likeAlertShownSwipe"]) {
                // display alert...
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:english.likeAlertTitleButton
                                                                message:english.likeAlertMessageButton
                                                               delegate:nil
                                                      cancelButtonTitle:@"Got it"
                                                      otherButtonTitles:nil];
                [alert show];
                [defaults setBool:YES forKey:@"likeAlertShownSwipe"];
            }
            [self likeItem]; // trigger the event that happens when you click on like
        } else if(!like && movedEnough) {
            
            /* 
                Display the dislike swipe dialog only once
             */
            English *english = [English instance];
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            if (! [defaults boolForKey:@"dislikeAlertShownSwipe"]) {
                // display alert...
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:english.dislikeAlertTitle
                                                                message:english.dislikeAlertMessage
                                                               delegate:nil
                                                      cancelButtonTitle:@"Got it"
                                                      otherButtonTitles:nil];
                [alert show];
                [defaults setBool:YES forKey:@"dislikeAlertShownSwipe"];
            }
            [self dislikeItem];
        }
    }
}

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Weave.plist"];
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
        [label setCenter:CGPointMake(220, imageView.frame.size.height+60)];
    } else if([[product getType] length] < 16) {
        [label setCenter:CGPointMake(200, imageView.frame.size.height+60)];
    } else{
        [label setCenter:CGPointMake(180, imageView.frame.size.height+60)];
    }
    [self.view bringSubviewToFront:label];

}

-(void)saveLikes
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    /* get likes from appdelegate */
    Likes *likes = [Likes instance];
    NSLog(@"I am saving %d to the plist", [likes count]);
    [archiver encodeObject:likes forKey:@"Likes"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

@end

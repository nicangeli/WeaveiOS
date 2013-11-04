//
//  ProductViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//


#import "ProductViewController.h"
#import "Collection.h"
#import "ImageDownloader.h"
#import "Product.h"
#import "Likes.h"
#import "Strings.h"
#import "ProductDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "NoLikesViewController.h"
#import "LikesPageViewController.h"

@interface ProductViewController ()

@end

@implementation ProductViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    
    if((self = [super initWithCoder:aDecoder])) {
        [[Mixpanel sharedInstance] track:@"Started Playing"];
    }
    NSLog(@"Init With Coder");
       return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"View did load");
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weave-nav.png"]];
    NSLog(@"UDID: %@", [[Mixpanel sharedInstance] distinctId]);
    [self registerForNetworkEvents];
    [self listenToNetwork];
    [self updateView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    Likes *likes = [Likes instance];
    [self updateLikeCountToNumber:[[likes getLikes] count]];
    NSLog(@"View Did appear");
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:@"seenProductsInstructions"]) {
        Strings *s = [Strings instance];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:s.productTitle message:s.productMessage delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil];
        [alert show];
        [defaults setBool:YES forKey:@"seenProductsInstructions"];
    }
    
    
    Collection *c = [Collection instance];
    c.currentProductSelection = [[NSMutableArray alloc] init];
    c = [Collection instance];
    c.currentProductSelection = nil;
    [c setCurrentProductSelectionForBrands:self.brandsSelected];
    NSLog(@"GOT %d products to show.", [[c count] intValue]);
    if(![[c count] isEqualToNumber:[NSNumber numberWithInt:0]]) { // still got products to show
        // show them
        if(currentProduct == nil) { // are we returning from details view page?
            [self showNextProduct];
        }
    } else {
        // update the collection
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LikesPageViewController *controller = (LikesPageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"likesPage"];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self.navigationController presentViewController:navController
                                                animated:YES
                                              completion:nil];
        
    }
    [Flurry logEvent:@"Products_Viewed" timed:YES];
    //params or update existing ones here as well
    //[self getNextProducts];
}

-(void)updateView{
    
    [self disableButtons];
    
    //UIImage *product = [UIImage imageNamed:[currentProduct getImageUrl]]; // image of the product on top of pile
    UIImageView *productView = [[UIImageView alloc]init]; // container for the image on top of pile
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
    UILabel *productLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 285, self.view.frame.size.width, 55)];
    [productLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];

    [productLabel setTag:1003];
    [productLabel setText:@""];

    productLabel.lineBreakMode = NSLineBreakByWordWrapping;
    productLabel.numberOfLines = 2;
    [productLabel setTextAlignment:NSTextAlignmentCenter];
    [imageView addSubview:productLabel];

}


-(void)showNextProduct
{
    Collection *c = [Collection instance];
    Product *p = [c getNextProduct];
    if(p == nil) {
        /*
            Send to the likes page...
         */
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LikesPageViewController *controller = (LikesPageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"likesPage"];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self.navigationController presentViewController:navController
                                                animated:YES
                                              completion:nil];
    }
    currentProduct = p;
    UIImageView *v = (UIImageView *)[self.view viewWithTag:1002];
    [MBProgressHUD showHUDAddedTo:v animated:YES];
    ImageDownloader *img = [[ImageDownloader alloc] init];
    img.delegate = self;
    [img downloadImageForProduct:p];
}

-(void)finishedDownloadingImageForProduct:(Product *)p
{
    UIImageView *v = (UIImageView *)[self.view viewWithTag:1002];

    [MBProgressHUD hideHUDForView:v animated:YES];
    // downloaded the image and saved it to the documents folder - lets display it
    NSLog(@"%@", [p getImageUrl]);
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
    UIImage *image = [UIImage imageWithContentsOfFile:[p getImageUrl]];
    [imageView setImage:image];
    [self updateLabelsForProduct:p inImageView:imageView];
    [self enableButtons];
}

-(IBAction)hitLikeButton:(id)sender
{
    Strings *s = [Strings instance];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (! [defaults boolForKey:@"likeAlertShownButton"]) {
        // display alert...
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:s.likeAlertTitleButton message:s.likeAlertMessageButton delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil];
        [alert show];
        [defaults setBool:YES forKey:@"likeAlertShownButton"];
    }
    [self likeItem];
}

-(IBAction)hitDislikeButton:(id)sender
{
    Strings *s = [Strings instance];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (! [defaults boolForKey:@"dislikeAlertShownButton"]) {
        // display alert...
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:s.dislikeAlertTitleButton
                                                        message:s.dislikeAlertMessageButton
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
    [self disableButtons];
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"Product_Title", [currentProduct getTitle], // Capture author info
     @"Product_Brand", [currentProduct getBrand], // Capture user status
     nil];
    
    [Flurry logEvent:@"Like_Item" withParameters:articleParams];
    Collection *collection = [Collection instance];
    Likes *likes = [Likes instance];
    [likes addProduct:currentProduct];
    [self updateLikeCountToNumber:[[likes getLikes] count]];
    [self saveLikes];
    [self saveProducts];
    [self showNextProduct];
}

-(void)dislikeItem
{
    [self disableButtons];
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"Product_Title", [currentProduct getTitle], // Capture author info
     @"Product_Brand", [currentProduct getBrand], // Capture user status
     nil];
    [ImageDownloader deleteFileAtPath:[currentProduct getImageUrl]];
    
    [Flurry logEvent:@"Dislike_Item" withParameters:articleParams];
    Collection *collection = [Collection instance];
    [self saveProducts];
    [self showNextProduct];
}

-(void)saveProducts
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    Collection *c = [Collection instance];
    [archiver encodeObject:[c getProducts] forKey:@"Products"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

-(void)enableButtons
{
    UIButton *like = (UIButton *)[self.view viewWithTag:3001];
    [like setEnabled:YES];
    
    UIButton *dislike = (UIButton *)[self.view viewWithTag:3002];
    [dislike setEnabled:YES];
    
    UIButton *info = (UIButton *)[self.view viewWithTag:3003];
    [info setEnabled:YES];
}

-(void)disableButtons
{
    UIButton *like = (UIButton *)[self.view viewWithTag:3001];
    [like setEnabled:NO];
    UIButton *dislike = (UIButton *)[self.view viewWithTag:3002];
    [dislike setEnabled:NO];
    UIButton *info = (UIButton *)[self.view viewWithTag:3003];
    [info setEnabled:NO];
}


- (IBAction)handleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"Handle Tap");
    [self performSegueWithIdentifier:@"MoreDetailsSegue" sender:self];
}


-(IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    NSLog(@"%f", location.x);

    UIImageView *v = (UIImageView *)[self.view viewWithTag:1002];
    [MBProgressHUD hideHUDForView:v animated:YES];    UIImage *likeImage = [UIImage imageNamed:@"like.png"];
    UIImage *dislikeImage = [UIImage imageNamed:@"dislike.png"];
    UIImageView *likeImageView = [[UIImageView alloc] initWithImage:likeImage];
    UIImageView *dislikeImageView = [[UIImageView alloc] initWithImage:dislikeImage];
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
   
    CGPoint translation = [recognizer translationInView:self.view];
    //translation.x and translation.y are the distance that they've moved
    // Are we moving left or right?
    CGPoint newLocation = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    if(recognizer.state == UIGestureRecognizerStateBegan) { // we have started to "move" the image around
        startLocation = recognizer.view.center;
        UIImageView *stack = (UIImageView *)[self.view viewWithTag:1002];
        //int random = arc4random() % 2;
        if(location.x < 140) {
            stack.transform = CGAffineTransformMakeRotation(M_PI_4/2);
        } else {
            stack.transform = CGAffineTransformMakeRotation(-M_PI_4/2);
        }
    }
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
        NSLog(@"%f", recognizer.view.center.x);
        if(recognizer.view.center.x > 100 && !like) {
            movedEnough = NO;
        }
        //recognizer.view.center = startLocation; // move the image back to the start
        if(like && movedEnough) {
            
            /*
                Display the like alert dialog only onece for swipe
             */
            Strings *s = [Strings instance];
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            if (! [defaults boolForKey:@"likeAlertShownSwipe"]) {
                // display alert...
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:s.likeAlertTitleButton
                                                                message:s.likeAlertMessageButton
                                                               delegate:nil
                                                      cancelButtonTitle:@"Got it"
                                                      otherButtonTitles:nil];
                [alert show];
                [defaults setBool:YES forKey:@"likeAlertShownSwipe"];
            }
            
            // animate the view here to fly off to the left
            
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 UIImageView *stack = (UIImageView *)[self.view viewWithTag:1002];
                                 //stack.transform = CGAffineTransformMakeRotation(0);
                                 stack.center = CGPointMake(900.0f, recognizer.view.center.y);
                                 //move off to the right
                                 //recognizer.view.center = CGPointMake(900.0f, recognizer.view.center.y);
                                
                             }
                             completion:^(BOOL finished){
                                 NSLog(@"Done!");
                                 UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001]; //the polaroid that sits on top of the stack
                                 imageView.image = [UIImage imageNamed:@""];
                                 recognizer.view.center = startLocation; // move the image back to the start
                                 UIImageView *stack = (UIImageView *)[self.view viewWithTag:1002];
                                 // straighten up
                                 stack.transform = CGAffineTransformMakeRotation(0);
                                 [self likeItem]; // trigger the event that happens when you click on like

                             }];
        } else if(!like && movedEnough) {
            
            /* 
                Display the dislike swipe dialog only once
             */
            Strings *s = [Strings instance];
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            if (! [defaults boolForKey:@"dislikeAlertShownSwipe"]) {
                // display alert...
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:s.dislikeAlertTitle
                                                                message:s.dislikeAlertMessage
                                                               delegate:nil
                                                      cancelButtonTitle:@"Got it"
                                                      otherButtonTitles:nil];
                [alert show];
                [defaults setBool:YES forKey:@"dislikeAlertShownSwipe"];
            }
            
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 UIImageView *stack = (UIImageView *)[self.view viewWithTag:1002];
                                // stack.transform = CGAffineTransformMakeRotation(0);
                                 stack.center = CGPointMake(-200.0f, recognizer.view.center.y);
                             }
                             completion:^(BOOL finished){
                                 NSLog(@"Done!");
                                 UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001]; //the polaroid that sits on top of the stack
                                 imageView.image = [UIImage imageNamed:@""];
                                 recognizer.view.center = startLocation; // move the image back to the start
                                 UIImageView *stack = (UIImageView *)[self.view viewWithTag:1002];
                                 // straighten up
                                 stack.transform = CGAffineTransformMakeRotation(0);
                                 [self dislikeItem];
                             }];
            
            // animate the view here to fly off to the right
  
        } else if(!movedEnough) {
            // animate back to the start location as we haven't moved enough yet
            
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 UIImageView *stack = (UIImageView *)[self.view viewWithTag:1002];
                                 stack.transform = CGAffineTransformMakeRotation(0);
                                 stack.center = startLocation;
                                 //UIImageView *stack = (UIImageView *)[self.view viewWithTag:1002];
                                 //stack.transform = CGAffineTransformMakeRotation(M_PI_4/2);
                             }
                             completion:^(BOOL finished){
                                 //UIImageView *stack = (UIImageView *)[self.view viewWithTag:1002];
                                 // straighten up
                                 //stack.transform = CGAffineTransformMakeRotation(0);
                             }];
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

-(IBAction)hitInfoButton:(id)sender
{
   // ProductDetailViewController *pvc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    NSLog(@"Info Button Hit");
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)updateLabelsForProduct:(Product *)product inImageView:(UIImageView *)imageView
{
    UILabel *label = (UILabel *)[self.view viewWithTag:1003]; // 1003 is the label that holds the title
    [label setText:[product getCategoryToDisplay]];

}

-(void)saveLikes
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    /* get likes from appdelegate */
    Likes *likes = [Likes instance];
    [archiver encodeObject:likes forKey:@"Likes"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)checkNetworkStatus:(NSNotification *)notice
{
    NetworkStatus status = [reachability currentReachabilityStatus];
    switch(status) {
        case NotReachable:
        {
            [self showNetworkError];
            break;
        }
        case ReachableViaWiFi:
        {
            [self hideNetworkError];
            //[self getNextProducts];
            [self showNextProduct];
            break;
        }
        case ReachableViaWWAN:
        {
            [self hideNetworkError];
            //[self getNextProducts];
            [self showNextProduct];
            break;
        }
    }
}

-(void)showNetworkError
{
    Strings *s = [Strings instance];
    UIView *view = [self.view viewWithTag:1002];
    [YRDropdownView showDropdownInView:view
                                 title:s.internetDownTitle
                                detail:s.internetDownMessage];
}

-(void)updateLikeCountToNumber:(NSInteger)newLikeNumber
{
    if(newLikeNumber == 0) {
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"Likes"];
    } else {
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"(%d) Likes", newLikeNumber];
    }
}

-(void)hideNetworkError
{
    UIView *view = [self.view viewWithTag:1002];
    [YRDropdownView hideDropdownInView:view];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([segue.identifier isEqualToString:@"MoreDetailsSegue"])
    {
        ProductDetailViewController *dvc = segue.destinationViewController;
        dvc.product = currentProduct;
    } else if([segue.identifier isEqualToString:@"ReturnToBrandsSegue"]) {
        //Collection *c = [Collection instance];
        //[c clearCollection];
        //currentProduct = nil;
    }
    
}

-(void)listenToNetwork
{
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
}

-(void)displayLoadingHUD
{
    Strings *s = [Strings instance];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = s.loadingText;
}

-(void)registerForNetworkEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
}


@end

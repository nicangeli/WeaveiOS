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
#import "Strings.h"
#import "ProductDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "Collection.h"
#import "NoLikesViewController.h"

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
        [[Mixpanel sharedInstance] track:@"Started Playing"];
    }
       return self;
}

-(void)loadLikes
{
    NSString *path = [self dataFilePath];
    NSLog(@"Path: %@", path);
    Likes *likes = [Likes instance];
    // Do any additional setup after loading the view.
    Collection *collection = [Collection instance];
    collection.calling = self;
    
    [collection loadNextCollectionForBrands];
    //products.calling = (ProductViewController *) self.view; // DELEGATE TODO
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        Likes *oldLikes = [unarchiver decodeObjectForKey:@"Likes"];
        [likes setLikes:[oldLikes getLikes]];
        
        [unarchiver finishDecoding];
        //[[delegate likes] getLikes] = [oldLikes getLikes];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"UDID: %@", [[Mixpanel sharedInstance] distinctId]);
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weave-nav.png"]];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:@"seenProductsInstructions"]) {
        Strings *s = [Strings instance];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:s.productTitle message:s.productMessage delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil];
        [alert show];
        [defaults setBool:YES forKey:@"seenProductsInstructions"];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadLikes];
    NSLog(@"I am dislaying the HUD");
    Strings *s = [Strings instance];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = s.loadingText;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    //NSLog(@"Hello world");
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
}

- (void)checkNetworkStatus:(NSNotification *)notice
{
    Strings *s = [Strings instance];
    NetworkStatus status = [reachability currentReachabilityStatus];
    switch(status) {
        case NotReachable:
        {
            UIView *view = [self.view viewWithTag:1002];
            [YRDropdownView showDropdownInView:view
                                         title:s.internetDownTitle
                                        detail:s.internetDownMessage];
            break;
        }
        case ReachableViaWiFi:
        {
            UIView *view = [self.view viewWithTag:1002];
            [YRDropdownView hideDropdownInView:view];
            Collection *c = [Collection instance];
            c.calling = self;
            [c loadNextCollectionForBrands];
            break;
        }
        case ReachableViaWWAN:
        {
            UIView *view = [self.view viewWithTag:1002];
            [YRDropdownView hideDropdownInView:view];
            Collection *c = [Collection instance];
            c.calling = self;
            [c loadNextCollectionForBrands];
            break;
        }
    }
}

-(void)downloadFinished
{
    [hud hide:YES];

    Collection *collection = [Collection instance];
    NSNumber *numProducts = [collection numberOfProducts];
    if([numProducts isEqualToNumber:[NSNumber numberWithInt:0]]) {
        NSLog(@"NO PRODUCTS TO SHOW");
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NoLikesViewController *controller = (NoLikesViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NoLikes"];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self.navigationController presentViewController:navController
                                                animated:YES
                                              completion:nil];
    } else {
        NSLog(@"%@", [collection numberOfProducts]);
        //[collection print];
        Product *p = [collection getNextProduct];
        currentProduct = p;
        
        NSLog(@"Displaying first products: %@", [p getImageUrl]);
        
        
        UIImage *product = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                   [NSURL URLWithString: [p getImageUrl]]]];
        
        while(product == nil) {
            p = [collection getNextProduct];
            product = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                              [NSURL URLWithString: [p getImageUrl]]]];
        }
        
        //UIImage *product = [UIImage imageNamed:[currentProduct getImageUrl]]; // image of the product on top of pile
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
        [productLabel setText:[currentProduct getType]];
        [imageView addSubview:productLabel];
        if([[currentProduct getType] length] < 10) {
            [productLabel setCenter:CGPointMake(220, imageView.frame.size.height-50)];
        } else if([[currentProduct getType] length] < 16) {
            [productLabel setCenter:CGPointMake(200, imageView.frame.size.height-50)];
        } else{
            [productLabel setCenter:CGPointMake(180, imageView.frame.size.height-50)];
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    Collection *collection = [Collection instance];
    Product *p = [collection getNextProduct];
    Likes *likes = [Likes instance];
    [likes addProduct:currentProduct];
    if(p == nil) {
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
        UILabel *label = (UILabel *)[self.view viewWithTag:1003];
        [imageView removeFromSuperview];
        [label removeFromSuperview];
      
        // no products left, lets recall the API
        [self loadLikes];
        Strings *s = [Strings instance];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = s.loadingText;
       
        
    } else {
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
        //[imageView setImage:[UIImage imageNamed:@"shoe2.jpg"]];
        currentProduct = p;
        [self saveLikes];
        [self updateImageView:imageView forProduct:p];
    }
}

-(void)dislikeItem
{
    Collection *collection = [Collection instance];
    Product *p = [collection getNextProduct];
    if(p == nil){
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
        UILabel *label = (UILabel *)[self.view viewWithTag:1003];

        [imageView removeFromSuperview];
        [label removeFromSuperview];
        //for(UIView *subView in imageView.subviews) { // get rid of the like and dislike image views
          //  [subView removeFromSuperview];
        //}
        //[self.navigationController.topViewController performSegueWithIdentifier:@"NoLikesLeft" sender:self];
        // no products left, lets recall the API
        [self loadLikes];
        Strings *s = [Strings instance];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = s.loadingText;
    } else {
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
        currentProduct = p;
        [self updateImageView:imageView forProduct:p];
    }
}

-(void)updateImageView:(UIImageView *)imageView forProduct:(Product *)product
{
    __block id p = product;
    NSLog(@"Updating image view:");
    Collection *collection = [Collection instance];
    NSLog(@"%@", [p getImageUrl]);
    UIImageView *v = (UIImageView *)[self.view viewWithTag:1002];
    [MBProgressHUD showHUDAddedTo:v animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                 [NSURL URLWithString: [p getImageUrl]]]];
        while(image == nil) {
            p = [collection getNextProduct];
            if(p == nil) {
                //skip to likes page
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                NoLikesViewController *controller = (NoLikesViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NoLikes"];
                
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
                [self.navigationController presentViewController:navController
                                                        animated:YES
                                                      completion:nil];
            }
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                            [NSURL URLWithString: [p getImageUrl]]]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:v animated:YES];
            [imageView setImage:image];


        });
    });

    [self updateLabelsForProduct:p inImageView:imageView];
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
            [self likeItem]; // trigger the event that happens when you click on like
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
    [archiver encodeObject:likes forKey:@"Likes"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

@end

//
//  BrandsPageViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 15/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "BrandsPageViewController.h"
#import "Collection.h"
#import "BrandCell.h"
#import "Brand.h"
#import "ProductViewController.h"
#import "Likes.h"
#import "Strings.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface BrandsPageViewController ()

@end

@implementation BrandsPageViewController{
    NSMutableArray *brands;
}

@synthesize collectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;

    /*
        Set up the ECSlidingViewController
     */
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    [self loadLikes];
    [self loadProducts];
    [self registerForNetworkEvents];
    [self listenToNetwork];
    [self.messageAlert setHidden:YES];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weave-nav.png"]];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    brands = [[NSMutableArray alloc] initWithCapacity:5];
    [brands addObject:[[Brand alloc] initWithName:@"Topshop" andImageName:@"topshopblack.png" andClickedName:@"Asos" andImageClickedName:@"topshopredv2.png" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"Zara" andImageName:@"zarablack.png" andClickedName:@"Zara" andImageClickedName:@"zarared.png" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"H&M" andImageName:@"h&mblack.png" andClickedName:@"H&M" andImageClickedName:@"h&mred.png" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"Mango" andImageName:@"mangoblack.png" andClickedName:@"Mango" andImageClickedName:@"mangoredv2.png" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"ASOS" andImageName:@"asosblackv2.png" andClickedName:@"ASOS" andImageClickedName:@"asosred.png" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"Anthropologie" andImageName:@"antropoblack.png" andClickedName:@"Anthropologie" andImageClickedName:@"antrored.png" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"& other Stories" andImageName:@"otherstoriesblack.png" andClickedName:@"& other Stories" andImageClickedName:@"otherstoriesred.png" andChecked:NO]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [Flurry logEvent:@"Brands_Page_Opened"];
    if([self shouldRefreshCollection]) {
        // refresh collection
        [self refreshCollection];
    } else {
        [self updateLabels];
    }
    [self checkNetworkStatus:nil];
    [self getUserDetails];
}

-(void)getUserDetails
{
    if([FBSession.activeSession isOpen]) {
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            if(!error) {
                NSLog(@"%@", user);
                NSString *gender = [user objectForKey:@"gender"];
                if([gender isEqualToString:@"male"]) {
                    UIAlertView *genderAlert = [[UIAlertView alloc] initWithTitle:@"Male?" message:@"Whoa - For the time being, Weave only has female clothes. Have a play anyway." delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil, nil];
                    [genderAlert show];
                    //[Flurry setUserID:user.email]
                }
                [Flurry setGender:gender];
                [Flurry setUserID:[user objectForKey:@"email"]];

            }
        }];
    }
}

-(void)registerForNetworkEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
}

-(void)listenToNetwork
{
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
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

-(void)loadLikes
{
    NSString *path = [self dataFilePath];
    NSLog(@"Path: %@", path);
    Likes *likes = [Likes instance];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        Likes *oldLikes = [unarchiver decodeObjectForKey:@"Likes"];
        [likes setLikes:[oldLikes getLikes]];
        
        [unarchiver finishDecoding];
    }
}

-(void)loadProducts
{
    NSString *path = [self dataFilePath];
    Collection *c = [Collection instance];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSMutableArray *oldProducts = [unarchiver decodeObjectForKey:@"Products"];
        [c setProducts:oldProducts];
        [unarchiver finishDecoding];
    }
}

-(BOOL)shouldRefreshCollection
{
    Collection *c = [Collection instance];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EE MMM dd YYYY"]; // get date in format Wed Oct 30 2013
    NSString *dateFormatted = [formatter stringFromDate:currentDate];
    if([c.lastSeenDate isEqualToString:dateFormatted]) {
        return NO;
    } else {
        return YES;
    }
}

-(void)refreshCollection
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Weaving...";
    Collection *c = [Collection instance];
    c.delegate = self;
    [c getAllProducts];
}

-(void)updateLabels
{
    [self.collectionView reloadData];
}


//data source and delegate methods


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [brands count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)myCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    BrandCell *cell = [myCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    Brand *b = (Brand *)[brands objectAtIndex:indexPath.item];
    NSLog(@"Displaying brand: %@", [b getName]);
    NSString *label;
    UIImage *image;
    if(b.checked) {
        // is b checked?
        label = [b getClickedName];
        image = [UIImage imageNamed:[b getImageClickedName]];
    } else {
        // b is not checked
        label = [b getName];
        image = [UIImage imageNamed:[b getImageName]];
    }
    Collection *c = [Collection instance];
    NSInteger count = [c numberOfProductsForBrand:b];
    cell.numberOfProductsLabel.text = [NSString stringWithFormat:@"%d", count];
    //NSLog(@" %@", [UIFont fontNamesForFamilyName:@"Joti One"]);
    [cell.numberOfProductsLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
    cell.brandLogo.image = image;
    
        if([[b getName] isEqualToString:@"DUMMY"]) {
            [cell setHidden:YES];
        }
    return cell;
}

-(void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Brand *b = [brands objectAtIndex:indexPath.item];
    NSLog(@"Clicking on brand: %@", [b getName]);
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"Brand", [b getName], // Capture user status
     nil];
    
    [Flurry logEvent:@"Brand_Selected" withParameters:articleParams];
    if(b.checked) {
        // b is checked
        [b setChecked:NO];
    } else {
        [b setChecked:YES];
    }
    if([self isABrandSelected]) {
        [self.messageAlert setHidden:NO];
    } else {
        [self.messageAlert setHidden:YES];
    }
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"ShowProducts"])
    {
        [Flurry logEvent:@"Show_Products_Selected"];
        // Get reference to the destination view controller
        ProductViewController *pvc = [segue destinationViewController];
        pvc.brandsSelected = (NSMutableArray *)[self getSelectedBrands];
        // Pass any objects to the view controller here, like...
    }
}

-(IBAction)showClothes:(id)sender
{
    NSString *identifier = @"Weave";
    //ProductViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    //newTopViewController.brandsSelected = (NSMutableArray *)[self getSelectedBrands];
    
    //[self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        //CGRect frame = self.slidingViewController.topViewController.view.frame;
        //self.slidingViewController.topViewController = newTopViewController;
        //self.slidingViewController.topViewController.view.frame = frame;
        //[self.slidingViewController resetTopView];
    //}];
}

-(BOOL)isABrandSelected
{
    BOOL isABrandSelected = NO;
    for(Brand *b in brands) {
        if([b isChecked]) {
            isABrandSelected = YES;
        }
    }
    return isABrandSelected;
}

-(NSMutableArray *)getSelectedBrands
{
    NSMutableArray *selectedBrands = [[NSMutableArray alloc] initWithCapacity:10];
    for(Brand *b in brands) {
        if([b isChecked]) {
            [selectedBrands addObject:b];
        }
    }
    return selectedBrands;
}

-(void)didDownloadAllProducts
{
    [hud removeFromSuperview];
    NSLog(@"Did download all products");
    [self saveProducts];
    [self updateLabels];
}

-(void)didFailOnDownloadProducts
{
    NSLog(@"Did fail on download products");
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

- (void)checkNetworkStatus:(NSNotification *)notice
{
    NetworkStatus status = [reachability currentReachabilityStatus];
    switch(status) {
        case NotReachable:
        {
            NSLog(@"Not reachable");
            [hud removeFromSuperview];
            [self showNetworkError];
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"Reachable via wifi");
            [self hideNetworkError];
            [hud removeFromSuperview];
            //[self getNextProducts];
            [self refreshCollection];
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"3G");
            [self hideNetworkError];
            [hud removeFromSuperview];
            //[self getNextProducts];
            [self refreshCollection];
            break;
        }
    }
}

-(void)showNetworkError
{
    Strings *s = [Strings instance];
    UIView *view = [self.view viewWithTag:202];
    [YRDropdownView showDropdownInView:view
                                 title:s.internetDownTitle
                                detail:s.internetDownMessage];
}

-(void)hideNetworkError
{
    UIView *view = [self.view viewWithTag:202];
    [YRDropdownView hideDropdownInView:view];
}

@end

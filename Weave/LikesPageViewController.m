//
//  LikesPageViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 01/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "LikesPageViewController.h"
#import "ImageDownloader.h"
#import "ProductDetailViewController.h"
#import "Basket.h"
#import "EmailBasketViewController.h"
#import "Likes.h"
#import "Product.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface LikesPageViewController ()

@end

@implementation LikesPageViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /*
     Set up hamburger
     */
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    //[self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weave-nav.png"]];
    [[Mixpanel sharedInstance] track:@"Likes page loaded"];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Flurry endTimedEvent:@"Products_Viewed" withParameters:nil]; // You can pass in additiona

    
    Likes *likes = [Likes instance];
    NSString *count = [NSString stringWithFormat:@"%d", [likes count]];
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"Num_Likes", count, // Capture author info
     nil];
    
    [Flurry logEvent:@"Likes_Viewed" withParameters:articleParams];
    [self.tableView reloadData];
}


-(IBAction)handleTap:(UITapGestureRecognizer *)recognizer
{
    Likes *l = [Likes instance];
    NSMutableArray *likes = [l getLikes];
    CGPoint point = [recognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    int index  = [likes count] - indexPath.row -1;

    Product *p = [likes objectAtIndex:index];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ProductDetailViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    viewController.product = p;
    [self.navigationController pushViewController:viewController animated:YES];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"num of rows called now");
    Likes *likes = [Likes instance];
    // Return the number of rows in the section.
    //NSLog(@"items num %d", [likes count]);
    
    return [likes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Likes *likes = [Likes instance];
    static NSString *CellIdentifier = @"ProductCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int index  = [likes count] - indexPath.row -1;
    Product *p = [likes objectAtIndex:index];
    UIImageView *thumbnailView = (UIImageView *)[cell viewWithTag:100];
    //thumbnailView.image = [UIImage imageNamed:[p getImageUrl]];
    //thumbnailView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: [p getImageUrl]]]];
    thumbnailView.image = [UIImage imageWithContentsOfFile:[p getImageUrl]];
    thumbnailView.contentMode = UIViewContentModeScaleAspectFit;

    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
    [titleLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];

    titleLabel.text = [p getTitle];
        
    UILabel *brandLabel = (UILabel *)[cell viewWithTag:103];
    [brandLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];

    brandLabel.text = [p getBrand];
    
    UILabel *priceLavel = (UILabel *)[cell viewWithTag:104];
    [priceLavel setFont:[UIFont fontWithName:@"Raleway" size:17]];

    priceLavel.text = [p getPrice];
    
    UIButton *basketButton = (UIButton *)[cell viewWithTag:109];
    
    if([p getIsInBasket]) {
        [basketButton setBackgroundImage:[UIImage imageNamed:@"basketClicked.png"] forState:UIControlStateNormal];
    } else {
        [basketButton setBackgroundImage:[UIImage imageNamed:@"basket.png"] forState:UIControlStateNormal];
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(IBAction)deleteLike:(id)sender
{
    NSLog(@"Deleting like...");
   
    [Flurry logEvent:@"Delete_Like"];
    Likes *l = [Likes instance];
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    Product *p = [l objectAtIndex:[l count] - indexPath.row -1];
    for(NSString *image in [p getImageUrls]){
        [ImageDownloader deleteFileAtPath:image];
    }
    [l removeProduct:p];
    [self saveLikes];
    [self.tableView reloadData];
}

-(void)saveLikes
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];

    Likes *likes = [Likes instance];
    [archiver encodeObject:likes forKey:@"Likes"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
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

-(IBAction)moreDetailsPressed:(UIButton *)sender {
    NSString *link = [sender accessibilityHint];
    
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"url", link, // Capture author info
     nil];
    
    [Flurry logEvent:@"Product_Shop_Visited" withParameters:articleParams];
    NSString *trimmedString;
    if([link hasPrefix:@" "]) {
        NSLog(@"I start with a space");
    }
    if([link hasPrefix:@"\r\n"]) {
        NSLog(@"I start with newline characters");
        trimmedString = [link stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    } else {
        trimmedString = link;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trimmedString]];
}

-(IBAction)addToBasket:(UIButton *)sender
{
    
    [Flurry logEvent:@"Add_To_Basket_Hit"];
    Basket *b = [Basket instance];
    Likes *l = [Likes instance];
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    int index  = [l count] - indexPath.row -1;
    Product *p = [l objectAtIndex:index];
    
    if([p getIsInBasket]) {
        // remove and set to clicked image
        [p setIsInBasket:NO];
        [b removeProduct:p];
        //[sender setBackgroundImage:[UIImage imageNamed:@"basket.png"] forState:UIControlStateNormal];
    } else {
        // add and set to not clicked image
        [p setIsInBasket:YES];
        //[sender setBackgroundImage:[UIImage imageNamed:@"basketClicked.png"] forState:UIControlStateNormal];
        [b addProduct:p];
    }
    [self.tableView reloadData];
}

-(IBAction)shareLike:(id)sender
{
    NSLog(@"Share Like");
    Likes *l = [Likes instance];
    [Flurry logEvent:@"Share_Like_Hit"];
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    int index = [l count] - indexPath.row -1;
    Product *p = [l objectAtIndex:index];
    // p is the product we clicked on
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    EmailBasketViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"emailPage"];
    viewController.products = [NSMutableArray arrayWithObject:p];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end

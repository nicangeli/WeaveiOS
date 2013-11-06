//
//  BasketViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 23/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "BasketViewController.h"
#import "Basket.h"
#import "Product.h"
#import "EmailBasketViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface BasketViewController ()

@end

@implementation BasketViewController

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
    self.navigationController.navigationBar.translucent = NO;

    /*
     Set up hamburger
     */
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weave-nav.png"]];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [Flurry logEvent:@"Basket_Loaded"];
    [super viewDidAppear:animated];
    Basket *b = [Basket instance];
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"£%g", [b basketTotal]]];
    [self.tableView reloadData];
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
    NSLog(@"NUM of rows in basket");
    Basket *basket = [Basket instance];
    // Return the number of rows in the section.
    NSLog(@"NUM of rows in basket: %d", [basket.products count]);
    return [basket.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Basket *basket = [Basket instance];
    static NSString *CellIdentifier = @"BasketCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int index  = [basket.products count] - indexPath.row -1;
    Product *p = [basket.products objectAtIndex:index];
    UIImageView *thumbnailView = (UIImageView *)[cell viewWithTag:100];
    thumbnailView.image = [UIImage imageWithContentsOfFile:[p getImageUrl]];
    thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:101];
    [priceLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];

    priceLabel.text = [p getPrice];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:102];
    [titleLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];

    titleLabel.text = [p getTitle];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(IBAction)deleteButtonClicked:(id)sender
{
    Basket *b = [Basket instance];
    [Flurry logEvent:@"Delete_From_Basket"];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    NSMutableArray *products = [b products];
    
    Product *p = [[b products] objectAtIndex:[products count] - indexPath.row -1];
    [products removeObject:p];
    [p setIsInBasket:NO];
    [self.tableView reloadData];
}

-(IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

-(IBAction)mailAllLikes:(id)sender
{
    NSLog(@"Mailing all likes");
    [Flurry logEvent:@"Hit_Mail_All_Likes_From_Basket"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    EmailBasketViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"emailPage"];
    viewController.products = [[Basket instance] products];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end

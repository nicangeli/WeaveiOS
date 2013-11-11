//
//  MenuViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 05/11/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "MenuViewController.h"
#import "ECSlidingViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "User.h"
#import "Collection.h"


@interface MenuViewController ()

@end

@implementation MenuViewController

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
    
    [self.slidingViewController setAnchorRightRevealAmount:200.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    [self.weaveLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
    [self.findsLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
    [self.loginLogoutButton setFont:[UIFont fontWithName:@"Raleway" size:17]];
    
    [self.dressesLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
    [self.coatsLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
    [self.shoesLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
    [self.skirtsLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
    [self.trousersLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
    [self.jumpersLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
    [self.lingerieLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
    [self.swimwearLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
    [self.accessoriesLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
    [self.topsLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLoginLabel];
}

-(void)updateLoginLabel
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if([appDelegate.session isOpen]) {
        self.loginLogoutButton.text = @"Logout";
    } else {
        self.loginLogoutButton.text = @"Login";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"Will select");
    if ( indexPath.row > 2 ) return nil;
    
    return indexPath;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    switch (indexPath.row) {
        case 0:
            identifier = @"Weave";
            break;
        case 1:
            identifier = @"Likes";
            break;
        case 2:
            // logout
            NSLog(@"Logging you in/out");
            UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];

            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate.session closeAndClearTokenInformation];
            [self presentViewController:newTopViewController animated:YES completion:nil];
            break;
    }
    if(identifier != nil) {
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }
    NSLog(@"%d", indexPath.row);
}

- (void)logoutButton {
    // get the app delegate so that we can access the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate.session closeAndClearTokenInformation];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    [self.navigationController pushViewController:lvc animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"LoginLogout"]) {
        if([FBSession.activeSession isOpen]) {
            [FBSession.activeSession closeAndClearTokenInformation];
        }
    }
}

-(IBAction)dressesSwitchHit:(id)sender
{
    User *u = [User instance];
    BOOL selectedDresses = [[u.categoryFilter objectForKey:@"Dresses"] boolValue];
    if(selectedDresses) {
        NSLog(@"Dresses was on - now you are off");
        [u.categoryFilter setObject:[NSNumber numberWithBool:NO] forKey:@"Dresses"];
    } else {
        NSLog(@"Dresses was off - now you are on");
        [u.categoryFilter setObject:[NSNumber numberWithBool:YES] forKey:@"Dresses"];
    }
    Collection *c = [Collection instance];
    [c updateSelectionForCategories];
}

-(IBAction)coatsSwitchHit:(id)sender
{
    User *u = [User instance];
    BOOL selectedCoats = [[u.categoryFilter objectForKey:@"Coats"] boolValue];
    if(selectedCoats) {
        NSLog(@"Coats was on - now you are off");
        [u.categoryFilter setObject:[NSNumber numberWithBool:NO] forKey:@"Coats"];
    } else {
        NSLog(@"Coats was off - now you are on");
        [u.categoryFilter setObject:[NSNumber numberWithBool:YES] forKey:@"Coats"];
    }
    Collection *c = [Collection instance];
    [c updateSelectionForCategories];
}

-(IBAction)shoesSwitchHit:(id)sender
{
    User *u = [User instance];
    BOOL selectedShoes = [[u.categoryFilter objectForKey:@"Shoes"] boolValue];
    if(selectedShoes) {
        NSLog(@"Shoes was on - now you are off");
        [u.categoryFilter setObject:[NSNumber numberWithBool:NO] forKey:@"Shoes"];
    } else {
        NSLog(@"Coats was off - now you are on");
        [u.categoryFilter setObject:[NSNumber numberWithBool:YES] forKey:@"Shoes"];
    }
    Collection *c = [Collection instance];
    [c updateSelectionForCategories];
}

-(IBAction)skirtsSwitchHit:(id)sender
{
    User *u = [User instance];
    BOOL selectedSkirts = [[u.categoryFilter objectForKey:@"Skirts"] boolValue];
    if(selectedSkirts) {
        NSLog(@"Skirts was on - now you are off");
        [u.categoryFilter setObject:[NSNumber numberWithBool:NO] forKey:@"Skirts"];
    } else {
        NSLog(@"Skirts was off - now you are on");
        [u.categoryFilter setObject:[NSNumber numberWithBool:YES] forKey:@"Skirts"];
    }
    Collection *c = [Collection instance];
    [c updateSelectionForCategories];
}

-(IBAction)trousersSwitchHit:(id)sender
{
    User *u = [User instance];
    BOOL selectedTrousers = [[u.categoryFilter objectForKey:@"Trousers"] boolValue];
    if(selectedTrousers) {
        NSLog(@"Trousers was on - now you are off");
        [u.categoryFilter setObject:[NSNumber numberWithBool:NO] forKey:@"Trousers"];
    } else {
        NSLog(@"Trousers was off - now you are on");
        [u.categoryFilter setObject:[NSNumber numberWithBool:YES] forKey:@"Trousers"];
    }
    Collection *c = [Collection instance];
    [c updateSelectionForCategories];
}


-(IBAction)jumpersSwitchHit:(id)sender
{
    User *u = [User instance];
    BOOL selectedJumpers = [[u.categoryFilter objectForKey:@"Jumpers"] boolValue];
    if(selectedJumpers) {
        NSLog(@"Jumpers was on - now you are off");
        [u.categoryFilter setObject:[NSNumber numberWithBool:NO] forKey:@"Jumpers"];
    } else {
        NSLog(@"Jumpers was off - now you are on");
        [u.categoryFilter setObject:[NSNumber numberWithBool:YES] forKey:@"Jumpers"];
    }
    Collection *c = [Collection instance];
    [c updateSelectionForCategories];
}

-(IBAction)lingerieSwitchHit:(id)sender
{
    User *u = [User instance];
    BOOL selectedLingerie = [[u.categoryFilter objectForKey:@"Jumpers"] boolValue];
    if(selectedLingerie) {
        NSLog(@"Lingerie was on - now you are off");
        [u.categoryFilter setObject:[NSNumber numberWithBool:NO] forKey:@"Lingerie"];
    } else {
        NSLog(@"Lingerie was off - now you are on");
        [u.categoryFilter setObject:[NSNumber numberWithBool:YES] forKey:@"Lingerie"];
    }
    Collection *c = [Collection instance];
    [c updateSelectionForCategories];
}

-(IBAction)swimwearSwitchHit:(id)sender
{
    User *u = [User instance];
    BOOL selectedSwimwear = [[u.categoryFilter objectForKey:@"Swimwear"] boolValue];
    if(selectedSwimwear) {
        NSLog(@"Swimwear was on - now you are off");
        [u.categoryFilter setObject:[NSNumber numberWithBool:NO] forKey:@"Swimwear"];
    } else {
        NSLog(@"Swimwear was off - now you are on");
        [u.categoryFilter setObject:[NSNumber numberWithBool:YES] forKey:@"Swimwear"];
    }
    Collection *c = [Collection instance];
    [c updateSelectionForCategories];
}

-(IBAction)accessoriesSwitchHit:(id)sender
{
    User *u = [User instance];
    BOOL selectedAccessories = [[u.categoryFilter objectForKey:@"Accessories"] boolValue];
    if(selectedAccessories) {
        NSLog(@"Accessories was on - now you are off");
        [u.categoryFilter setObject:[NSNumber numberWithBool:NO] forKey:@"Accessories"];
    } else {
        NSLog(@"Accessories was off - now you are on");
        [u.categoryFilter setObject:[NSNumber numberWithBool:YES] forKey:@"Accessories"];
    }
    Collection *c = [Collection instance];
    [c updateSelectionForCategories];
}

-(IBAction)topsSwitchHit:(id)sender
{
    User *u = [User instance];
    BOOL selectedTops = [[u.categoryFilter objectForKey:@"Tops"] boolValue];
    if(selectedTops) {
        NSLog(@"Tops was on - now you are off");
        [u.categoryFilter setObject:[NSNumber numberWithBool:NO] forKey:@"Tops"];
    } else {
        NSLog(@"Tops was off - now you are on");
        [u.categoryFilter setObject:[NSNumber numberWithBool:YES] forKey:@"Tops"];
    }
    Collection *c = [Collection instance];
    [c updateSelectionForCategories];
}


@end

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
    [self.shoesLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
    [self.jeansLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
    [self.lingerieLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
    [self.topsLabel setFont:[UIFont fontWithName:@"Raleway" size:17]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLoginLabel];
}

-(void)updateLoginLabel
{
    if([FBSession.activeSession isOpen]) {
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
            
            /*[self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
                CGRect frame = self.slidingViewController.topViewController.view.frame;
                self.slidingViewController.topViewController = newTopViewController;
                self.slidingViewController.topViewController.view.frame = frame;
                [self.slidingViewController resetTopView];
            }];
             */
            //[self.navigationController popToRootViewControllerAnimated:YES];
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


@end

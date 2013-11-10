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
        case 3:
            // logout
            NSLog(@"Logout functionality...");
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"LoginLogout"]) {
        if([FBSession.activeSession isOpen]) {
            [FBSession.activeSession closeAndClearTokenInformation];
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

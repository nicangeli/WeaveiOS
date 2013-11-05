//
//  SlideMenu.m
//  Weave
//
//  Created by Nicholas Angeli on 30/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "SlideMenu.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"

@interface SlideMenu() <SASlideMenuDataSource,SASlideMenuDelegate>

@end

@implementation SlideMenu

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([FBSession.activeSession isOpen]) {
        [self.loginLogoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    } else {
        [self.loginLogoutButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark SASlideMenuDataSource

-(NSIndexPath*) selectedIndexPath{
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

-(NSString*) segueIdForIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return @"brands";
    }else if (indexPath.row == 1){
        return @"basket";
    }else if(indexPath.row == 2) {
        return @"likes";
    } else {
        return nil;
    }
}

-(IBAction)logout:(id)sender
{
    // on log out we reset the main view controller
    //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[appDelegate logout];
    [FBSession.activeSession closeAndClearTokenInformation];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *controller = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    
    [self presentViewController:controller animated:NO completion:nil];
    // send back to home screen
}

-(Boolean) allowContentViewControllerCachingForIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(Boolean) disablePanGestureForIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        return YES;
    }
    return NO;
}

-(void) configureMenuButton:(UIButton *)menuButton{
    menuButton.frame = CGRectMake(0, 0, 40, 29);
    [menuButton setImage:[UIImage imageNamed:@"menuicon"] forState:UIControlStateNormal];
}

-(void) configureSlideLayer:(CALayer *)layer{
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.3;
    layer.shadowOffset = CGSizeMake(-5, 0);
    layer.shadowRadius = 5;
    layer.masksToBounds = NO;
    layer.shadowPath =[UIBezierPath bezierPathWithRect:layer.bounds].CGPath;
}

-(CGFloat) leftMenuVisibleWidth{
    return 260;
}
-(void) prepareForSwitchToContentViewController:(UINavigationController *)content{
    UIViewController* controller = [content.viewControllers objectAtIndex:0];
}


#pragma mark -
#pragma mark SASlideMenuDelegate


-(void) slideMenuWillSlideIn:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuWillSlideIn");
}
-(void) slideMenuDidSlideIn:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuDidSlideIn");
}
-(void) slideMenuWillSlideToSide:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuWillSlideToSide");
}
-(void) slideMenuDidSlideToSide:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuDidSlideToSide");
}
-(void) slideMenuWillSlideOut:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuWillSlideOut");
}
-(void) slideMenuDidSlideOut:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuDidSlideOut");
}
-(void) slideMenuWillSlideToLeft:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuWillSlideToLeft");
}
-(void) slideMenuDidSlideToLeft:(UINavigationController *)selectedContent{
    NSLog(@"slideMenuDidSlideToLeft");
}

@end

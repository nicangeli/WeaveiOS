//
//  MenuViewController.h
//  Weave
//
//  Created by Nicholas Angeli on 05/11/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UILabel *weaveLabel;
@property (nonatomic, strong) IBOutlet UILabel *findsLabel;
@property (nonatomic, strong) IBOutlet UILabel *loginLogoutButton;
@property (nonatomic, strong) IBOutlet UILabel *shoesLabel;
@property (nonatomic, strong) IBOutlet UILabel *topsLabel;
@property (nonatomic, strong) IBOutlet UILabel *lingerieLabel;
@property (nonatomic, strong) IBOutlet UILabel *jeansLabel;

-(IBAction)loginLogout:(id)sender;

@end

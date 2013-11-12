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
@property (nonatomic, strong) IBOutlet UILabel *filterByLabel;

@property (nonatomic, strong) IBOutlet UILabel *dressesLabel;
@property (nonatomic, strong) IBOutlet UISwitch *dressesSwitch;

@property (nonatomic, strong) IBOutlet UILabel *coatsLabel;
@property (nonatomic, strong) IBOutlet UISwitch *coatsSwitch;

@property (nonatomic, strong) IBOutlet UILabel *shoesLabel;
@property (nonatomic, strong) IBOutlet UISwitch *shoesSwitch;

@property (nonatomic, strong) IBOutlet UILabel *skirtsLabel;
@property (nonatomic, strong) IBOutlet UISwitch *skirtsSwitch;

@property (nonatomic, strong) IBOutlet UILabel *trousersLabel;
@property (nonatomic, strong) IBOutlet UISwitch *trousersSwitch;

@property (nonatomic, strong) IBOutlet UILabel *jumpersLabel;
@property (nonatomic, strong) IBOutlet UISwitch *jumpersSwitch;

@property (nonatomic, strong) IBOutlet UILabel *lingerieLabel;
@property (nonatomic, strong) IBOutlet UISwitch *lingerieSwitch;

@property (nonatomic, strong) IBOutlet UILabel *swimwearLabel;
@property (nonatomic, strong) IBOutlet UISwitch *swimwearSwitch;

@property (nonatomic, strong) IBOutlet UILabel *accessoriesLabel;
@property (nonatomic, strong) IBOutlet UISwitch *accessoriesSwitch;

@property (nonatomic, strong) IBOutlet UILabel *topsLabel;
@property (nonatomic, strong) IBOutlet UISwitch *topsSwitch;

-(IBAction)loginLogout:(id)sender;

-(IBAction)dressesSwitchHit:(id)sender;
-(IBAction)coatsSwitchHit:(id)sender;



@end

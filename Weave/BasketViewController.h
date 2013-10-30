//
//  BasketViewController.h
//  Weave
//
//  Created by Nicholas Angeli on 23/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Basket;

@interface BasketViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Basket *basket;
@property (nonatomic, strong) IBOutlet UILabel *totalPriceLabel;

-(IBAction)mailAllLikes:(id)sender;

@end

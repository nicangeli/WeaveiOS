//
//  NoLikesViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 03/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "NoLikesViewController.h"

@interface NoLikesViewController ()

@end

@implementation NoLikesViewController

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
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weave-nav.png"]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

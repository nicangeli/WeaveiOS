//
//  EmailBasketViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 23/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "EmailBasketViewController.h"
#import "Emailer.h"
#import "Basket.h"

@interface EmailBasketViewController ()

@end

@implementation EmailBasketViewController

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

-(IBAction)emailButtonHit:(UIButton *)sender
{
    Basket *b = [Basket instance];
    Emailer *e = [[Emailer alloc] init];
    e.delegate = self;
    [e sendEmailForBasket:b];
}

-(void)didSendEmailForBasket
{
    // called when the email is sent successfully...
}

@end

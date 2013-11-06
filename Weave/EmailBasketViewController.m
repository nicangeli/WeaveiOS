//
//  EmailBasketViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 23/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "EmailBasketViewController.h"
#import "Basket.h"
#import "Strings.h"
#import "LikesPageViewController.h"
#import "Emailer.h"
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


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
    if(SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    } else {
        self.navigationController.navigationBar.translucent = NO;
    }
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weave-nav.png"]];

	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [defaults objectForKey:@"email"];
    if(email != nil) {
        self.emailAddressField.text = email;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)emailButtonHit:(UIButton *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.emailAddressField.text forKey:@"email"];
    Strings *s = [Strings instance];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = s.loadingText;
    Emailer *e = [[Emailer alloc] init];
    e.delegate = self;
    //[e sendEmailTo:self.emailAddressField.text forBasket:b];
    [e sendEmailTo:self.emailAddressField.text forProducts:self.products];
}

-(IBAction)emailTextChange:(UITextField *)sender
{
    NSLog(@"Email text changed and is now: %@", sender.text);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //You code here...
    NSString *email = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if([self validateEmail:email]) {
        // valid email address
        self.submitEmailButton.enabled = YES;
        self.submitEmailButton.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:58.0f/255.0f blue:66.0f/255.0f alpha:1.0f];
    } else {
        self.submitEmailButton.enabled = NO;
        self.submitEmailButton.backgroundColor = [UIColor grayColor];
    }
    return YES;
}

- (BOOL)validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(void)didSendEmailForBasket
{
    // called when the email is sent successfully...
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [defaults objectForKey:@"email"];
    [Flurry setUserID:email];
    [hud setHidden:YES];
   [hud removeFromSuperview];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    LikesPageViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"likesPage"];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end

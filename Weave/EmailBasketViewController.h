//
//  EmailBasketViewController.h
//  Weave
//
//  Created by Nicholas Angeli on 23/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Emailer.h"

@interface EmailBasketViewController : UIViewController <EmailerDelegate, UITextFieldDelegate>
{
    MBProgressHUD *hud;
}

@property (nonatomic, strong) IBOutlet UITextField *emailAddressField;
@property (nonatomic, strong) IBOutlet UIButton *submitEmailButton;

-(IBAction)emailButtonHit:(UIButton *)sender;
-(IBAction)emailTextChange:(UITextField *)sender;

@end

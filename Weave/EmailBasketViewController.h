//
//  EmailBasketViewController.h
//  Weave
//
//  Created by Nicholas Angeli on 23/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Emailer.h"

@interface EmailBasketViewController : UIViewController <EmailerDelegate>

-(IBAction)emailButtonHit:(UIButton *)sender;

@end

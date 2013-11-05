//
//  LikesPageViewController.h
//  Weave
//
//  Created by Nicholas Angeli on 01/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LikesPageViewController : UITableViewController

-(IBAction)handleTap:(UITapGestureRecognizer *)recognizer;
-(IBAction)moreDetailsPressed:(UIButton *)sender;
-(IBAction)addToBasket:(UIButton *)sender;

-(IBAction)shareLike:(id)sender;
-(IBAction)deleteLike:(id)sender;

-(IBAction)revealMenu:(id)sender;

@end

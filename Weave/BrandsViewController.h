//
//  BrandsViewController.h
//  Weave
//
//  Created by Nicholas Angeli on 07/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandsViewController : UIViewController

@property (nonatomic, assign) BOOL topshopClicked;
@property (nonatomic, assign) BOOL asosClicked;
@property (nonatomic, assign) BOOL hmClicked;
@property (nonatomic, assign) BOOL newlookClicked;
@property (nonatomic, assign) BOOL otherStoriesClicked;


-(IBAction)topshopClicked:(id)sender;
-(IBAction)asosClicked:(id)sender;
-(IBAction)hmClicked:(id)sender;
-(IBAction)newlookClicked:(id)sender;
-(IBAction)otherStoriesClicked:(id)sender;


@end

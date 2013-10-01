//
//  ProductViewController.h
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Collection.h"

@interface ProductViewController : UIViewController {
    Collection *products;
    CGPoint startLocation;
}

-(IBAction)likeItem:(id)sender;
-(IBAction)dislikeItem:(id)sender;

-(void)updateLabelsForProduct:(Product *)product inImageView:(UIImageView *)imageView;

@end

//
//  ProductViewController.h
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Collection.h"

@class Collection;

@interface ProductViewController : UIViewController {
    CGPoint startLocation;
    Product *currentProduct;
    MBProgressHUD *hud;
}

-(IBAction)hitDislikeButton:(id)sender;
-(IBAction)hitLikeButton:(id)sender;
-(IBAction)hitInfoButton:(id)sender;


-(void)updateLabelsForProduct:(Product *)product inImageView:(UIImageView *)imageView;
-(void)downloadFinished;

@end

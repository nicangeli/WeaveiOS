//
//  ProductViewController.h
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"
#import "Collection.h"

@class Product;
@class Reachability;
@class Reachability;

@interface ProductViewController : UIViewController <ImageDownloaderProtocol, CollectionDelegate> {
    CGPoint startLocation;
    Product *currentProduct;
    MBProgressHUD *hud;
    Reachability *reachability;
}

@property (nonatomic, strong) NSMutableArray *brandsSelected;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *likesButton;

-(IBAction)hitDislikeButton:(id)sender;
-(IBAction)hitLikeButton:(id)sender;
-(IBAction)hitInfoButton:(id)sender;


-(void)updateLabelsForProduct:(Product *)product inImageView:(UIImageView *)imageView;
-(void)downloadFinished;

-(void)showNetworkError;
-(void)hideNetworkError;
-(IBAction)revealMenu:(id)sender;


@end

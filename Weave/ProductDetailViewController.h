//
//  ProductDetailViewController.h
//  Weave
//
//  Created by Nicholas Angeli on 03/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "Product.h"
#import "ImageDownloader.h"

@interface ProductDetailViewController : UIViewController <iCarouselDataSource, iCarouselDelegate, ImageDownloaderProtocol>
{
    MBProgressHUD *hud;
}

@property (nonatomic, strong) NSMutableArray *productImages;
@property (strong, nonatomic) IBOutlet iCarousel *aCarousel;
@property (nonatomic, strong) NSArray *animals;
@property (nonatomic, strong) Product *product;
@property (strong, nonatomic) IBOutlet UILabel *productLabel;

@end

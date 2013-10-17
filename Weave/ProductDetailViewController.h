//
//  ProductDetailViewController.h
//  Weave
//
//  Created by Nicholas Angeli on 03/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface ProductDetailViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>;

@property (nonatomic, strong) NSMutableArray *productImages;
@property (nonatomic) BOOL wrap;
@property (strong, nonatomic) IBOutlet iCarousel *carousel;

@end

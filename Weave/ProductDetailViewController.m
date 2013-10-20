//
//  ProductDetailViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 03/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

@synthesize productImages;
@synthesize aCarousel;
@synthesize animals;

- (void)awakeFromNib
{
    //set up data
    //your carousel should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
    self.animals = [NSMutableArray arrayWithObjects:@"Bear.png",
                    @"Zebra.png",
                    @"Tiger.png",
                    @"Goat.png",
                    @"Birds.png",
                    @"Giraffe.png",
                    @"Chimp.png",
                    nil];
    
    self.productImages = [[NSMutableArray alloc] initWithCapacity:5];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.productLabel.text = [self.product getCategory];
    self.productPrice.text = [self.product getPrice];
    ImageDownloader *img = [[ImageDownloader alloc] init];
    [img downloadBatchOfImagesForProduct:self.product];
    img.delegate = self;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    
    NSLog(@"Product: %@", [self.product getTitle]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weave-nav.png"]];

    aCarousel.type = iCarouselTypeLinear;
}

-(void)finishedDownloadingBatchOfImagesForProduct:(Product *)p
{
    NSLog(@"Did finish downloading batch of images");
    for(NSString *str in [p getImageUrls]) {
        NSLog(@"%@", str);
    }
    self.productImages = [p getImageUrls];
    [hud hide:YES];
    self.pageControl.numberOfPages = [[p getImageUrls] count];
    self.pageControl.currentPage = 0;
    [aCarousel reloadData];
   // [self.view setNeedsDisplay];
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 200;
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [productImages count];
}

- (UIView*)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    // create a numbered view
    //view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[productImages objectAtIndex:index]]];
    view = (UIImageView *)[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
    view.contentMode = UIViewContentModeScaleAspectFit; // scale pic to the whole of the avaliable area
    [(UIImageView *)view setImage:[UIImage imageWithContentsOfFile:[productImages objectAtIndex:index]]];
    //self.pageControl.currentPage = index;
    return view;
}

-(void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    self.pageControl.currentPage = carousel.currentItemIndex / [productImages count];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

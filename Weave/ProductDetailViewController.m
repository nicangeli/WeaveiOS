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

    aCarousel.type = iCarouselTypeRotary;
}

-(void)finishedDownloadingBatchOfImagesForProduct:(Product *)p
{
    NSLog(@"Did finish downloading batch of images");
    for(NSString *str in [p getImageUrls]) {
        NSLog(@"%@", str);
    }
    self.productImages = [p getImageUrls];
    [hud hide:YES];
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
    view = (UIImageView *)[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    view.contentMode = UIViewContentModeScaleAspectFit; // scale pic to the whole of the avaliable area
    [(UIImageView *)view setImage:[UIImage imageWithContentsOfFile:[productImages objectAtIndex:index]]];
    return view;
}
/*
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    UIImageView *imageView = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        //((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
        view.contentMode = UIViewContentModeCenter;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        
        imageView = [[UIImageView alloc] init];
        imageView.tag = 2;
        
        [view addSubview:imageView];
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
        imageView = (UIImageView *)[view viewWithTag:2];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = [items[index] stringValue];
    //imageView.image = [UIImage imageNamed:@"one.jpg"];
    imageView.image = [[UIImage alloc] initWithContentsOfFile:@"one.jpg"];
    
    return view;
}
 */



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

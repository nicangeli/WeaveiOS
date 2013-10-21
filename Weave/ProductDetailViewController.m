//
//  ProductDetailViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 03/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()

@property (nonatomic, strong) NSMutableArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end

@implementation ProductDetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.pageImages = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Weaving...";
    if([[self.product getImageUrls] count] == 1) {
        [self setUp];
    } else {
        BOOL allLocal = YES;
        for(NSString *str in [self.product getImageUrls]) {
            if(![[str substringToIndex:1] isEqualToString:@"/"]) {
                allLocal = NO;
            }
        }
        if(!allLocal){
            ImageDownloader *img = [[ImageDownloader alloc] init];
            img.delegate = self;
            [img downloadBatchOfImagesForProduct:self.product];
        } else {
            [self setUp];
        }
    }
}

-(void)setUp
{
    [hud removeFromSuperview];
    for(NSString *url in [self.product getImageUrls]) {
        [self.pageImages addObject:[UIImage imageWithContentsOfFile:url]];
    }

    
    NSInteger pageCount = self.pageImages.count;
    
    // 2
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // 3
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
    
    
    // 4
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, 200);
    
    // 5
    //[self.view setNeedsDisplay];
    [self loadVisiblePages];
}

-(void)loadPage:(NSInteger)page
{
    if(page < 0 || page >= self.pageImages.count) {
        return;
    }
    
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if((NSNull *)pageView == [NSNull null]) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
        
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    
	// Load pages in our range
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    
	// Purge anything after the last page
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}


-(void)finishedDownloadingBatchOfImagesForProduct:(Product *)p
{
    NSLog(@"Did finish downloading batch of images");
    self.product = p;
    [hud removeFromSuperview]; 
    [self setUp];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

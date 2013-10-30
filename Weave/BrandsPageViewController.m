//
//  BrandsPageViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 15/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "BrandsPageViewController.h"
#import "Collection.h"
#import "BrandCell.h"
#import "Brand.h"
#import "ProductViewController.h"

@interface BrandsPageViewController ()

@end

@implementation BrandsPageViewController{
    NSMutableArray *brands;
}

@synthesize collectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.messageAlert setHidden:YES];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weave-nav.png"]];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    brands = [[NSMutableArray alloc] initWithCapacity:5];
    [brands addObject:[[Brand alloc] initWithName:@"Topshop" andImageName:@"topshopblack.png" andClickedName:@"Asos" andImageClickedName:@"topshopredv2.png" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"Zara" andImageName:@"zarablack.png" andClickedName:@"Zara" andImageClickedName:@"zarared.png" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"H&M" andImageName:@"h&mblack.png" andClickedName:@"H&M" andImageClickedName:@"h&mred.png" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"Mango" andImageName:@"mangoblack.png" andClickedName:@"Mango" andImageClickedName:@"mangoredv2.png" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"ASOS" andImageName:@"asosblackv2.png" andClickedName:@"ASOS" andImageClickedName:@"asosred.png" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"Anthropogie" andImageName:@"antropoblack.png" andClickedName:@"Anthropogie" andImageClickedName:@"antrored.png" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"& other Stories" andImageName:@"otherstoriesblack.png" andClickedName:@"& other Stories" andImageClickedName:@"otherstoriesred.png" andChecked:NO]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [Flurry logEvent:@"Brands_Page_Opened"];
    if([self shouldRefreshCollection]) {
        // refresh collection
        [self refreshCollection];
    } else {
        [self updateLabels];
    }
}

-(BOOL)shouldRefreshCollection
{
    Collection *c = [Collection instance];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EE MMM dd YYYY"]; // get date in format Wed Oct 30 2013
    NSString *dateFormatted = [formatter stringFromDate:currentDate];
    if([c.lastSeenDate isEqualToString:dateFormatted]) {
        return NO;
    } else {
        return YES;
    }
}

-(void)refreshCollection
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Weaving...";
    Collection *c = [Collection instance];
    c.delegate = self;
    [c getAllProducts];
}

-(void)updateLabels
{
    [self.collectionView reloadData];
}


//data source and delegate methods


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [brands count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)myCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    BrandCell *cell = [myCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    Brand *b = (Brand *)[brands objectAtIndex:indexPath.item];
    NSString *label;
    UIImage *image;
    if(b.checked) {
        // is b checked?
        label = [b getClickedName];
        image = [UIImage imageNamed:[b getImageClickedName]];
    } else {
        // b is not checked
        label = [b getName];
        image = [UIImage imageNamed:[b getImageName]];
    }
    Collection *c = [Collection instance];
    cell.numberOfProductsLabel.text = [NSString stringWithFormat:@"%d", [c numberOfProductsForBrand:b]];
    //cell.brandNameLabel.text = label;
    cell.brandLogo.image = image;
    return cell;
}

-(void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Brand *b = [brands objectAtIndex:indexPath.item];
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"Brand", [b getName], // Capture user status
     nil];
    
    [Flurry logEvent:@"Brand_Selected" withParameters:articleParams];
    if(b.checked) {
        // b is checked
        [b setChecked:NO];
    } else {
        [b setChecked:YES];
    }
    if([self isABrandSelected]) {
        [self.messageAlert setHidden:NO];
    } else {
        [self.messageAlert setHidden:YES];
    }
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"ShowProducts"])
    {
        [Flurry logEvent:@"Show_Products_Selected"];
        // Get reference to the destination view controller
        ProductViewController *pvc = [segue destinationViewController];
        pvc.brandsSelected = (NSMutableArray *)[self getSelectedBrands];
        // Pass any objects to the view controller here, like...
    }
}

-(BOOL)isABrandSelected
{
    BOOL isABrandSelected = NO;
    for(Brand *b in brands) {
        if([b isChecked]) {
            isABrandSelected = YES;
        }
    }
    return isABrandSelected;
}

-(NSMutableArray *)getSelectedBrands
{
    NSMutableArray *selectedBrands = [[NSMutableArray alloc] initWithCapacity:10];
    for(Brand *b in brands) {
        if([b isChecked]) {
            [selectedBrands addObject:b];
        }
    }
    return selectedBrands;
}

-(void)didDownloadAllProducts
{
    [hud removeFromSuperview];
    NSLog(@"Did download all products");
    [self updateLabels];
}

-(void)didFailOnDownloadProducts
{
    NSLog(@"Did fail on download products");
}

@end

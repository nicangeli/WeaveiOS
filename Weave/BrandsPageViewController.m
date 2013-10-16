//
//  BrandsPageViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 15/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "BrandsPageViewController.h"
#import "BrandCell.h"
#import "Brand.h"
#import "ProductViewController.h"

@interface BrandsPageViewController ()

@end

@implementation BrandsPageViewController{
    //NSArray *descriptions;
    //NSArray *clickedDescriptions;
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
    [brands addObject:[[Brand alloc] initWithName:@"ASOS" andImageName:@"topshop.png" andClickedName:@"Asos Clicked" andImageClickedName:@"ASOS-CLICKED.jpg" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"H&M" andImageName:@"topshop.png" andClickedName:@"H&M Clicked" andImageClickedName:@"" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"New Look" andImageName:@"topshop.png" andClickedName:@"New Look Clicked" andImageClickedName:@"" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"TopShop" andImageName:@"topshop.png" andClickedName:@"TopShop Clicked" andImageClickedName:@"" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"ASOS" andImageName:@"topshop.png" andClickedName:@"Asos Clicked" andImageClickedName:@"ASOS-CLICKED.jpg" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"H&M" andImageName:@"topshop.png" andClickedName:@"H&M Clicked" andImageClickedName:@"" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"New Look" andImageName:@"topshop.png" andClickedName:@"New Look Clicked" andImageClickedName:@"" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"TopShop" andImageName:@"topshop.png" andClickedName:@"TopShop Clicked" andImageClickedName:@"" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"ASOS" andImageName:@"topshop.png" andClickedName:@"Asos Clicked" andImageClickedName:@"ASOS-CLICKED.jpg" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"H&M" andImageName:@"topshop.png" andClickedName:@"H&M Clicked" andImageClickedName:@"" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"New Look" andImageName:@"topshop.png" andClickedName:@"New Look Clicked" andImageClickedName:@"" andChecked:NO]];
    [brands addObject:[[Brand alloc] initWithName:@"TopShop" andImageName:@"topshop.png" andClickedName:@"TopShop Clicked" andImageClickedName:@"" andChecked:NO]];
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
    //cell.brandNameLabel.text = label;
    cell.brandLogo.image = image;
    return cell;
}

-(void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Brand *b = [brands objectAtIndex:indexPath.item];
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

@end

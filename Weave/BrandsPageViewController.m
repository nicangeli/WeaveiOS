//
//  BrandsPageViewController.m
//  Weave
//
//  Created by Nicholas Angeli on 15/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "BrandsPageViewController.h"
#import "BrandCell.h"

@interface BrandsPageViewController ()

@end

@implementation BrandsPageViewController{
    NSArray *descriptions;
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
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weave-nav.png"]];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    descriptions = [[NSArray alloc] initWithObjects:@"Topshop", @"H&M", @"& Other Stories", nil];
	// Do any additional setup after loading the view.
}

//data source and delegate methods


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [descriptions count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)myCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    BrandCell *cell = [myCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.brandNameLabel.text = [descriptions objectAtIndex:indexPath.item];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

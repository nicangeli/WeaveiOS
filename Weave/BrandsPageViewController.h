//
//  BrandsPageViewController.h
//  Weave
//
//  Created by Nicholas Angeli on 15/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandsPageViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

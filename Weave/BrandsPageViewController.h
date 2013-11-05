//
//  BrandsPageViewController.h
//  Weave
//
//  Created by Nicholas Angeli on 15/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Collection.h"

@interface BrandsPageViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, CollectionDelegate>
{
    MBProgressHUD *hud;
    Reachability *reachability;
}

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *messageAlert;

-(IBAction)revealMenu:(id)sender;
-(IBAction)showClothes:(id)sender;

@end

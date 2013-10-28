//
//  BrandCell.h
//  Weave
//
//  Created by Nicholas Angeli on 15/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *brandLogo;
@property (strong, nonatomic) IBOutlet UILabel *numberOfProductsLabel;

@end

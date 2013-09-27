//
//  ProductViewController.h
//  Weave
//
//  Created by Nicholas Angeli on 27/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Collection.h"

@interface ProductViewController : UIViewController {
    Collection *shoeCollection;
}

-(IBAction)likeItem:(id)sender;
-(IBAction)dislikeItem:(id)sender;

@end

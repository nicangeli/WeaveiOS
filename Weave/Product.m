//
//  Product.m
//  Weave
//
//  Created by Nicholas Angeli on 30/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "Product.h"

@implementation Product

-(id)initWithTitle:(NSString *)myTitle url:(NSString *)myUrl price:(NSString *)myPrice shop:(NSString *)myShop brand:(NSString *)myBrand type:(NSString *)myType imageUrl:(NSString *)myImageUrl {
    
    self = [super init];
    if(self != nil) {
        title = myTitle;
        url = myUrl;
        price = myPrice;
        shop = myShop;
        brand = myBrand;
        type = myType;
        imageUrl = myImageUrl;
    }
    
    return self;
}

-(NSString *)getImageUrl {
    return imageUrl;
}


@end

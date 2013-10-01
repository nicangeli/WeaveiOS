//
//  Product.h
//  Weave
//
//  Created by Nicholas Angeli on 30/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject {
    NSString *title;
    NSString *url;
    NSString *price;
    NSString *shop;
    NSString *brand;
    NSString *type;
    NSString *imageUrl;
}

-(id)initWithTitle:(NSString *)myTitle url:(NSString *)myUrl price:(NSString *)myPrice shop:(NSString *)myShop brand:(NSString *)myBrand type:(NSString *)myType imageUrl:(NSString *)myImageUrl;

-(NSString *)getImageUrl;
-(NSString *)getTitle;
-(NSString *)getType;
-(NSString *)getPrice;
-(NSString *)getBrand;
-(NSString *)getUrl;

@end

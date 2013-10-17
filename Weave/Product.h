//
//  Product.h
//  Weave
//
//  Created by Nicholas Angeli on 30/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject <NSCoding> {
    NSString *title;
    NSString *url;
    NSString *price;
    NSString *shop;
    NSString *brand;
    NSString *category;
    NSString *subcategory;
    NSString *materials;
    NSMutableArray *imageUrls;
    NSString *collectionDate;
}

-(id)initWithTitle:(NSString *)myTitle url:(NSString *)myUrl price:(NSString *)myPrice shop:(NSString *)myShop brand:(NSString *)myBrand imageUrls:(NSMutableArray *)myImageUrls category:(NSString *)myCategory subcategory:(NSString *)mySubcategory materials:(NSString *)myMaterials collectionDate:(NSString *)myCollectionDate;

-(NSArray *)getImageUrls;
-(NSString *)getImageUrl;
-(void)setImageUrl:(NSString *)newImageURL;
-(NSString *)getTitle;
-(NSString *)getPrice;
-(NSString *)getBrand;
-(NSString *)getUrl;
-(NSString *)getCategory;
-(NSString *)getSubCategory;
-(NSString *)getMaterials;
-(NSString *)getCollectionDate;

@end

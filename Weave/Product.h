//
//  Product.h
//  Weave
//
//  Created by Nicholas Angeli on 30/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Collection;

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
    BOOL isInBasket;
}



-(id)initWithTitle:(NSString *)myTitle url:(NSString *)myUrl price:(NSString *)myPrice shop:(NSString *)myShop brand:(NSString *)myBrand imageUrls:(NSMutableArray *)myImageUrls category:(NSString *)myCategory subcategory:(NSString *)mySubcategory materials:(NSString *)myMaterials collectionDate:(NSString *)myCollectionDate;

-(NSMutableArray *)getImageUrls;
-(NSString *)getImageUrl;
-(void)setImageUrl:(NSString *)newImageURL;
-(void)replaceOldImageUrl:(NSString *)oldUrl withNewImageUrl:(NSString *)newImageUrl;
-(NSString *)getTitle;
-(NSString *)getPrice;
-(NSString *)getShop;
-(NSString *)getBrand;
-(NSString *)getUrl;
-(NSString *)getCategory;
-(NSString *)getSubCategory;
-(NSString *)getMaterials;
-(NSString *)getCollectionDate;
-(NSString *)getCategoryToDisplay;
-(void)setIsInBasket:(BOOL)toState;
-(float)getNumberPrice;
-(BOOL)doesNotExistInCollection:(Collection *)c;
-(BOOL)getIsInBasket;

@end

//
//  Product.m
//  Weave
//
//  Created by Nicholas Angeli on 30/09/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "Product.h"

@implementation Product

-(id)initWithTitle:(NSString *)myTitle url:(NSString *)myUrl price:(NSString *)myPrice shop:(NSString *)myShop brand:(NSString *)myBrand imageUrls:(NSMutableArray *)myImageUrls category:(NSString *)myCategory subcategory:(NSString *)mySubcategory materials:(NSString *)myMaterials collectionDate:(NSString *)myCollectionDate {
    
    self = [super init];
    if(self != nil) {
        title = myTitle;
        url = myUrl;
        price = myPrice;
        shop = myShop;
        brand = myBrand;
        imageUrls = myImageUrls;
        category = myCategory;
        subcategory = mySubcategory;
        materials = myMaterials;
        collectionDate = myCollectionDate;
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:url forKey:@"url"];
    [aCoder encodeObject:price forKey:@"price"];
    [aCoder encodeObject:shop forKey:@"shop"];
    [aCoder encodeObject:brand forKey:@"brand"];
    [aCoder encodeObject:imageUrls forKey:@"imageUrls"];
    [aCoder encodeObject:category forKey:@"category"];
    [aCoder encodeObject:subcategory forKey:@"subcategory"];
    [aCoder encodeObject:materials forKey:@"materials"];
    [aCoder encodeObject:collectionDate forKey:@"collectionDate"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        title = [aDecoder decodeObjectForKey:@"title"];
        url   = [aDecoder decodeObjectForKey:@"url"];
        price = [aDecoder decodeObjectForKey:@"price"];
        shop = [aDecoder decodeObjectForKey:@"shop"];
        brand = [aDecoder decodeObjectForKey:@"brand"];
        imageUrls = [aDecoder decodeObjectForKey:@"imageUrls"];
        category = [aDecoder decodeObjectForKey:@"category"];
        subcategory = [aDecoder decodeObjectForKey:@"subcategory"];
        materials = [aDecoder decodeObjectForKey:@"materials"];
        collectionDate = [aDecoder decodeObjectForKey:@"collectionDate"];
    }
    return self;
}

-(NSMutableArray *)getImageUrls {
    return imageUrls;
}

-(void)setImageUrl:(NSString *)newImageURL
{
    [imageUrls replaceObjectAtIndex:0 withObject:newImageURL];
}

-(void)replaceOldImageUrl:(NSString *)oldUrl withNewImageUrl:(NSString *)newImageUrl
{
    // find the oldUrl index
    //replace it with the new url
    for(NSInteger i = 0; i < [imageUrls count]; i++) {
        NSString *myUrl = [imageUrls objectAtIndex:i];
        if([myUrl isEqualToString:oldUrl]) {
            [imageUrls replaceObjectAtIndex:i withObject:newImageUrl];
        }
    }
}

-(NSString *)getCategoryToDisplay
{
    if(title == nil) {
        return category;
    } else {
        return title;
    }
}

-(NSString *)getCategory {
    return category;
}
-(NSString *)getSubCategory {
    return subcategory;
}
-(NSString *)getMaterials {
    return materials;
}



-(NSString *) getCollectionDate
{
    return collectionDate;
}



-(NSString *)getImageUrl
{
    return [imageUrls objectAtIndex:0];
}

-(NSString *)getTitle {
    return title;
}

-(NSString *)getPrice
{
    return price;
}

-(NSString *)getBrand
{
    return brand;
}

-(NSString *)getUrl
{
    return url;
}

-(float)getNumberPrice
{
    if([price hasPrefix:@"£"]) {
        return [[price substringFromIndex:1] floatValue];
    } else {
        return [price floatValue];
    }
}


@end

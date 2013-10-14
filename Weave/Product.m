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

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:url forKey:@"url"];
    [aCoder encodeObject:price forKey:@"price"];
    [aCoder encodeObject:shop forKey:@"shop"];
    [aCoder encodeObject:brand forKey:@"brand"];
    [aCoder encodeObject:type forKey:@"type"];
    [aCoder encodeObject:imageUrl forKey:@"imageUrl"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        title = [aDecoder decodeObjectForKey:@"title"];
        url   = [aDecoder decodeObjectForKey:@"url"];
        price = [aDecoder decodeObjectForKey:@"price"];
        shop = [aDecoder decodeObjectForKey:@"shop"];
        brand = [aDecoder decodeObjectForKey:@"brand"];
        type = [aDecoder decodeObjectForKey:@"type"];
        imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
        
    }
    return self;
}

-(NSString *)getImageUrl {
    return imageUrl;
}
-(void)setImageUrl:(NSString *)newImageURL
{
    imageUrl = newImageURL;
}

-(NSString *)getTitle {
    return title;
}

-(NSString *)getType
{
    return type;
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


@end

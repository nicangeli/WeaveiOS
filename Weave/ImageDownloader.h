//
//  ImageDownloader.h
//  Weave
//
//  Created by Nicholas Angeli on 13/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Product;

@protocol ImageDownloaderProtocol <NSObject>

-(void)finishedDownloadingImageForProduct:(Product *)p;
-(void)finishedDownloadingBatchOfImagesForProduct:(Product *)p;
@end

@interface ImageDownloader : NSObject

@property (nonatomic, retain) id<ImageDownloaderProtocol> delegate;
-(void)downloadImageForProduct:(Product *)p;
+(void)deleteFileAtPath:(NSString *)path;
-(void)downloadBatchOfImagesForProduct:(Product *)p;
-(NSString *)getNextFileNameAtPath:(NSString *)path;

@end

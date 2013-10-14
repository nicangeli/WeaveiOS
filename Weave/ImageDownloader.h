//
//  ImageDownloader.h
//  Weave
//
//  Created by Nicholas Angeli on 13/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@protocol ImageDownloaderProtocol <NSObject>

@required
-(void)finishedDownloadingImageForProduct:(Product *)p;
@end

@interface ImageDownloader : NSObject

@property (nonatomic, retain) id<ImageDownloaderProtocol> delegate;
-(void)downloadImageForProduct:(Product *)p;
+(void)deleteFileAtPath:(NSString *)path;
-(NSString *)getNextFileNameAtPath:(NSString *)path;

@end

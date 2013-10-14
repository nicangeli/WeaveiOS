//
//  ImageDownloader.m
//  Weave
//
//  Created by Nicholas Angeli on 13/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "ImageDownloader.h"
#import "AFURLSessionManager.h"
#import "AFURLConnectionOperation.h"
#import "AFHTTPRequestOperation.h"
#import "Product.h"
#import "Collection.h"

@implementation ImageDownloader

-(void)downloadImageForProduct:(Product *)p{
    NSLog(@"Download started");
    NSString *path = [p getImageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    NSLog(@"Downloading image: %@", path);
    AFURLConnectionOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    int count = [self listFileAtPath:[paths objectAtIndex:0]];
    NSString *imagePath = [NSString stringWithFormat:@"%d.jpg", count];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imagePath];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    [operation setCompletionBlock:^{
        [p setImageUrl:filePath];
        [self.delegate finishedDownloadingImageForProduct:p];
    }];
    [operation start];
}

-(int)listFileAtPath:(NSString *)path
{
    
    int count;
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        //NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return count+1;
}

@end

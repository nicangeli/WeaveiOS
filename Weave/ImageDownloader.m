//
//  ImageDownloader.m
//  Weave
//
//  Created by Nicholas Angeli on 13/10/2013.
//  Copyright (c) 2013 Nicholas Angeli. All rights reserved.
//

#import "ImageDownloader.h"
#import "Product.h"
#import "AFURLSessionManager.h"
#import "AFURLConnectionOperation.h"
#import "AFHTTPRequestOperation.h"
#import "Collection.h"

@implementation ImageDownloader

-(void)downloadImageForProduct:(Product *)p{
    NSString *path = [p getImageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    AFURLConnectionOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *imagePath = [self getNextFileNameAtPath:[paths objectAtIndex:0]];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imagePath];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    [operation setCompletionBlock:^{
        [p setImageUrl:filePath];
        [self.delegate finishedDownloadingImageForProduct:p];
    }];
    [operation start];
}

-(void)downloadBatchOfImagesForProduct:(Product *)p
{
    NSMutableArray *filesToDownload = [p getImageUrls];
    [filesToDownload removeObjectAtIndex:0];
    
    /*
        Get the next n product names
     */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSInteger start = [self getNextFileNumberAtPath:[paths objectAtIndex:0]];
    
    NSMutableArray *newFilePaths = [[NSMutableArray alloc] initWithCapacity:10];

    for(NSInteger i = start; i < start + [filesToDownload count]; i++) {
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", i]];
        [newFilePaths addObject:filePath];
    }
    
    NSMutableArray *mutableOperations = [NSMutableArray array];
    for(NSInteger i = 0; i < [filesToDownload count]; i++) {
        NSString *fileURL = [filesToDownload objectAtIndex:i];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileURL]];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        //NSString *imagePath = [self getNextFileNameAtPath:[paths objectAtIndex:0]];
        //NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imagePath];
        NSString *filePath = [newFilePaths objectAtIndex:i];
        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
        [mutableOperations addObject:operation];
    }
    
    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:mutableOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
    } completionBlock:^(NSArray *operations) {
        NSLog(@"All operations in batch complete");
        for(NSInteger i = 0; i < [filesToDownload count]; i++) {
            NSString *url = [filesToDownload objectAtIndex:i];
            [p replaceOldImageUrl:url withNewImageUrl:[newFilePaths objectAtIndex:i]];
        }
        // call delegate method here...
        [self.delegate finishedDownloadingBatchOfImagesForProduct:p];
    }];
    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
}

-(NSString *)getNextFileNameAtPath:(NSString *)path
{
    int count;
    int highestSeen = 0;
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for(count = 0; count < (int)[directoryContent count]; count++) {
        NSString *file = [directoryContent objectAtIndex:count];
        NSArray *fileBits = [file componentsSeparatedByString:@"."];
        int number = [[fileBits objectAtIndex:0] intValue];
        if(number > highestSeen) {
            highestSeen = number;
        }
    }
    if(highestSeen == 0) {
        highestSeen = 1;
    } else {
        highestSeen = highestSeen +1;
    }
    NSString *newPath = [NSString stringWithFormat:@"%d.jpg", highestSeen];
    return newPath;
}

-(NSInteger)getNextFileNumberAtPath:(NSString *)path
{
    int count;
    int highestSeen = 0;
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for(count = 0; count < (int)[directoryContent count]; count++) {
        NSString *file = [directoryContent objectAtIndex:count];
        NSArray *fileBits = [file componentsSeparatedByString:@"."];
        int number = [[fileBits objectAtIndex:0] intValue];
        if(number > highestSeen) {
            highestSeen = number;
        }
    }
    if(highestSeen == 0) {
        highestSeen = 1;
    } else {
        highestSeen = highestSeen +1;
    }
    return highestSeen;
}

+(void)deleteFileAtPath:(NSString *)path
{
    NSError *error;
    
    // Create file manager
    NSFileManager *fileMgr = [NSFileManager defaultManager];

    // Attempt to delete the file at filePath2
    if ([fileMgr removeItemAtPath:path error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
}

@end

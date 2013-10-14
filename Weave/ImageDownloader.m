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

-(NSString *)getNextFileNameAtPath:(NSString *)path
{
    int count;
    int highestSeen = 0;
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for(count = 0; count < (int)[directoryContent count]; count++) {
        NSLog(@"File at: %@", [directoryContent objectAtIndex:count]);
        NSString *file = [directoryContent objectAtIndex:count];
        NSArray *fileBits = [file componentsSeparatedByString:@"."];
        //NSLog(@"First Bit: %@", [fileBits objectAtIndex:0]);
        int number = [[fileBits objectAtIndex:0] intValue];
        if(number > highestSeen) {
            //NSLog(@"True");
            highestSeen = number;
        }
        //NSLog(@"Number: %d", number);
    }
    if(highestSeen == 0) {
        highestSeen = 1;
    } else {
        highestSeen = highestSeen +1;
    }
    NSString *newPath = [NSString stringWithFormat:@"%d.jpg", highestSeen];
    return newPath;
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

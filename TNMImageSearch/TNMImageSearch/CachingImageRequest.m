//
//  CachingImageRequest.m
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/4/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import "CachingImageRequest.h"
#import "ImageSearchError.h"

@interface CachingImageRequest () <NSURLSessionDownloadDelegate>

@property (nonatomic) NSURL *imageURL;
@property (nonatomic, copy) ImageRequestCompletionBlock completion;

@end

// Image download cache.
static const NSCache<NSString *,UIImage *> *cache;

@implementation CachingImageRequest

+ (void)initialize {
    cache = [[NSCache alloc] init];
}

- (instancetype)initWithImageURL:(NSURL *)imageURL {
    if (self = [super init]) {
        self.imageURL = imageURL;
    }
    return self;
}

- (void)performRequestWithCompletion:(ImageRequestCompletionBlock)completion {
    // If image found in cache, return it.
    UIImage *cachedImage = [cache objectForKey:[self.imageURL absoluteString]];
    if (cachedImage) {
        return completion(cachedImage, 1, nil);
    }
    self.completion = completion;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:nil];
    NSURLSessionDownloadTask *downloadtask = [session downloadTaskWithRequest:[NSURLRequest requestWithURL:self.imageURL]];
    [downloadtask resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!image) {
            weakSelf.completion(nil, 1, [NSError errorWithDomain:ImageSearchErrorDomain code:1 userInfo:nil]);
            return;
        }
        [cache setObject:image forKey:[weakSelf.imageURL absoluteString]];
        weakSelf.completion(image, 1, nil);
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (totalBytesExpectedToWrite > 0) {
            weakSelf.completion(nil, totalBytesWritten / (float)totalBytesExpectedToWrite, nil);
        }
    });
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        __weak typeof (self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.completion(nil, 0, [NSError errorWithDomain:ImageSearchErrorDomain code:ImageSearchErrorCodeNetworkError userInfo:@{ NSUnderlyingErrorKey : error }]);
        });
    }
}

@end

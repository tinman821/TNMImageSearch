//
//  SearchRequest.m
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/4/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import <sys/utsname.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "SearchRequest.h"
#import "ImageSearchError.h"

@interface SearchRequest ()

@property (nonatomic) NSURL *searchURL;
@property (nonatomic) NSInteger startIndex;

@end

const NSInteger kMaxStartIndex = 60;    // Google API limit.

@implementation SearchRequest

- (instancetype)initWithSearchTerm:(NSString *)searchTerm
                        startIndex:(NSInteger)startIndex
                        resultSize:(NSInteger)resultSize {
    if (self = [super init]) {
        self.startIndex = startIndex;
        if (startIndex <= kMaxStartIndex) {
            NSURLComponents *components = [NSURLComponents componentsWithURL:[NSURL URLWithString:@"https://ajax.googleapis.com/ajax/services/search/images"]
                                                     resolvingAgainstBaseURL:NO];
            NSURLQueryItem *v = [NSURLQueryItem queryItemWithName:@"v" value:@"1.0"];
            NSURLQueryItem *q = [NSURLQueryItem queryItemWithName:@"q" value:searchTerm];
            NSURLQueryItem *rsz = [NSURLQueryItem queryItemWithName:@"rsz" value:[NSString stringWithFormat:@"%@", @(resultSize)]];
            NSURLQueryItem *start = [NSURLQueryItem queryItemWithName:@"start" value:[NSString stringWithFormat:@"%@", @(startIndex)]];
            NSURLQueryItem *userip = [NSURLQueryItem queryItemWithName:@"userip" value:[self ipAddress]];
            components.queryItems = @[v,q,userip,rsz,start];
            self.searchURL = components.URL;
        }
    }
    return self;
}

- (void)performRequestWithCompletion:(void (^)(SearchResult *result, NSError *error))completion {
    if (self.startIndex > kMaxStartIndex) {
        // Return a search result with no image results.
        completion([SearchResult new], nil);
        return;
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:self.searchURL]
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        if (error) {
                                                            completion(nil, [NSError errorWithDomain:ImageSearchErrorDomain code:ImageSearchErrorCodeNetworkError userInfo:@{ NSUnderlyingErrorKey : error }]);
                                                            return;
                                                        }
                                                        NSError *jsonError = nil;
                                                        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                                                        if (jsonError) {
                                                            completion(nil, [NSError errorWithDomain:ImageSearchErrorDomain code:ImageSearchErrorCodeJSONError userInfo:@{ NSUnderlyingErrorKey : jsonError}]);
                                                            return;
                                                        }
                                                        if ([jsonObj[@"responseStatus"] integerValue] != 200) {
                                                            NSString *errorMessage = jsonObj[@"responseDetails"];
                                                            completion(nil, [NSError errorWithDomain:ImageSearchErrorDomain code:ImageSearchErrorCodeServerError userInfo:errorMessage ? @{ NSLocalizedDescriptionKey : errorMessage } : nil]);
                                                            return;
                                                        }
                                                        completion([[SearchResult alloc] initWithJSONObject:jsonObj], nil);
                                                    });
                                                }];
    [dataTask resume];
}

- (NSString *)ipAddress {
    struct ifaddrs *networkDevices = NULL;
    struct ifaddrs *temp = NULL;
    NSString *wifiAddress = nil;
    NSString *cellularAddress = nil;

    // Do we have any interfaces?
    if (!getifaddrs(&networkDevices)) {

        // Ok, let's iterate over the list and see if we can find either
        // the WiFi or Cellular interface
        temp = networkDevices;
        while (temp != NULL) {
            // get interface family.  We only want IPv4 and IPv6
            sa_family_t sa_type = temp->ifa_addr->sa_family;

            if (sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp->ifa_name];

                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp->ifa_addr)->sin_addr)];

                if ([name isEqualToString:@"en0"]) { // WiFi
                    wifiAddress = addr;
                } else if ([name isEqualToString:@"pdp_ip0"]) { // Cellular
                    cellularAddress = addr;
                }
            }
            temp = temp->ifa_next;
        }

        // This list is not ARC memory so we must free it
        freeifaddrs(networkDevices);
    }

    NSString *ipAddress = wifiAddress ? wifiAddress : cellularAddress;
    
    return ipAddress ? ipAddress : @"0.0.0.0";
}

@end

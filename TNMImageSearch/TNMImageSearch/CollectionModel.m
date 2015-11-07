//
//  CollectionModel.m
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/4/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import "CollectionModel.h"

@implementation CollectionData

@end

@interface CollectionModel () <NSCacheDelegate>

@property (nonatomic) NSMutableArray<CollectionData *> *collectionData;

@end

@implementation CollectionModel

- (instancetype)init {
    if (self = [super init]) {
        self.collectionData = [NSMutableArray new];
    }
    return self;
}

- (void)addData:(CollectionData *)data {
    [self.collectionData addObject:data];
}

- (NSArray<CollectionData *> *)data {
    return self.collectionData;
}

@end

//
//  CollectionViewController.m
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/4/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import "CollectionViewController.h"
#import "ImageViewController.h"
#import "CollectionModel.h"
#import "SearchRequest.h"
#import "SearchResult.h"
#import "CachingImageRequest.h"
#import "ImageCell.h"
#import "ImageSearchError.h"

@interface CollectionViewController () {
    dispatch_semaphore_t loadingSemaphore;
    dispatch_queue_t loadingQueue;
}

@property (nonatomic) NSInteger searchIndex;
@property (nonatomic) CollectionModel *model;
@property (nonatomic) BOOL hasMoreImages;

@end

@implementation CollectionViewController

const NSInteger kSearchSize = 8;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasMoreImages = YES;
    // Only allow one loading cell at a time.
    loadingSemaphore = dispatch_semaphore_create(1);
    loadingQueue = dispatch_queue_create("com.tinman821.CollectionViewController.queue", NULL);
    self.model = [CollectionModel new];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ImageViewController *viewController = segue.destinationViewController;
    NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:sender];
    CollectionData *data = self.model.data[selectedIndexPath.row];
    viewController.imageURL = data.fullURL;
    viewController.title = data.title;
}

#pragma mark - UICollectionViewDelegate/DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.data.count + (self.hasMoreImages ? 1 : 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.model.data.count && self.hasMoreImages) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LoadingCell" forIndexPath:indexPath];
        return cell;
    }
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    CollectionData *data = self.model.data[indexPath.row];
    if (data.image) {
        cell.image = data.image;
        cell.percentageVisible = NO;
    } else if (data.loading) {
        cell.image = nil;
        cell.percentageComplete = data.completionPercentage;
        cell.percentageVisible = YES;
    } else if (!data.loading) {
        cell.image = nil;
        // Refetch, image was evicted from cache.
        [self loadImageForData:data];
        cell.percentageComplete = data.completionPercentage;
        cell.percentageVisible = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell.reuseIdentifier isEqualToString:@"LoadingCell"]) {
        __weak typeof (self) weakSelf = self;
        dispatch_async(loadingQueue, ^{
            // Wait for any previous loading operation to complete before starting a new one.
            dispatch_semaphore_wait(loadingSemaphore, DISPATCH_TIME_FOREVER);
            dispatch_async(dispatch_get_main_queue(), ^{
                SearchRequest *request = [[SearchRequest alloc] initWithSearchTerm:self.searchTerm
                                                                        startIndex:self.searchIndex
                                                                        resultSize:kSearchSize];
                [request performRequestWithCompletion:^(SearchResult *result, NSError *error) {
                    if (error) {
                        [ImageSearchError presentErrorOnViewController:self error:error];
                    } else {
                        if (result.imageResults.count == 0) {
                            weakSelf.hasMoreImages = NO;
                            [weakSelf.collectionView reloadData];
                        } else {
                            weakSelf.searchIndex += kSearchSize;
                            for (ImageResult *imageResult in result.imageResults) {
                                CollectionData *data = [CollectionData new];
                                data.thumbnailURL = imageResult.thumbnailURL;
                                data.fullURL = imageResult.imageURL;
                                data.title = imageResult.title;
                                [weakSelf.model addData:data];
                                [weakSelf loadImageForData:data];
                            }
                            [weakSelf.collectionView reloadData];
                        }
                    }
                    dispatch_semaphore_signal(loadingSemaphore);
                }];
            });
        });
    }
}

#pragma mark - Private methods

- (void)loadImageForData:(CollectionData *)data {
    __weak typeof (self) weakSelf = self;
    data.completionPercentage = 0.0f;
    data.loading = YES;
    CachingImageRequest *imageRequest = [[CachingImageRequest alloc] initWithImageURL:data.thumbnailURL];
    [imageRequest performRequestWithCompletion:^(UIImage *image, float completionPercentage, NSError *error) {
        if (error) {
            [ImageSearchError presentErrorOnViewController:self error:error];
            return;
        }
        data.completionPercentage = completionPercentage;
        if (image) {
            data.image = image;
            data.loading = NO;
        }
        [weakSelf.collectionView reloadData];
    }];
}

@end

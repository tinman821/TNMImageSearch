//
//  ImageViewController.m
//  TNMImageSearch
//
//  Created by Tran, Tin on 11/6/15.
//  Copyright © 2015 tinman821. All rights reserved.
//

#import "ImageViewController.h"
#import "CachingImageRequest.h"
#import "ImageSearchError.h"

@interface ImageViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *percentageCompleteLabel;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CachingImageRequest *request = [[CachingImageRequest alloc] initWithImageURL:self.imageURL];
    [request performRequestWithCompletion:^(UIImage *image, float completionPercentage, NSError *error) {
        if (error) {
            self.percentageCompleteLabel.hidden = YES;
            [ImageSearchError presentErrorOnViewController:self error:error];
        }
        else if (image) {
            self.percentageCompleteLabel.hidden = YES;
            self.imageView.image = image;
            [self.imageView sizeToFit];
            self.scrollView.contentSize = image.size;
            [self setupZoomScaleForViewSize:CGSizeMake(CGRectGetWidth(self.view.bounds),
                                                       CGRectGetHeight((self.view.bounds)))];
            [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
        } else if (!self.imageView.image) {
            self.percentageCompleteLabel.text = [NSString stringWithFormat:@"%@%%", @((int)(completionPercentage * 100))];
        }

    }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self setupZoomScaleForViewSize:size];
    __weak typeof (self) weakSelf = self;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [weakSelf.scrollView setZoomScale:weakSelf.scrollView.minimumZoomScale animated:YES];
    } completion:nil];
}

#pragma mark - Actions

- (IBAction)zoomMinMax:(id)sender {
    if (fabs(self.scrollView.zoomScale - self.scrollView.minimumZoomScale) < FLT_EPSILON) {
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    } else {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - Private methods

- (void)setupZoomScaleForViewSize:(CGSize)size {
    if (self.imageView.image.size.height > size.height ||
        self.imageView.image.size.width > size.width) {
        self.scrollView.maximumZoomScale = 1.0f;
        self.scrollView.minimumZoomScale = MIN(size.height / self.imageView.image.size.height, size.width / self.imageView.image.size.width);

    } else {
        self.scrollView.minimumZoomScale = 1.0f;
        self.scrollView.maximumZoomScale = MAX(size.height / self.imageView.image.size.height, size.width / self.imageView.image.size.width);
    }
}

@end
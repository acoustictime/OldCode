//
//  ImageViewController.m
//  ShutterBug
//
//  Created by James Small on 8/26/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "ImageViewController.h"
#import "AttributedStringViewController.h"
#import "PhotoCacheManager.h"

@interface ImageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (strong, nonatomic) UIPopoverController *urlPopOver;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ImageViewController

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"ShowURL"]) {
        return self.imageURL && !self.urlPopOver.popoverVisible ? YES : NO;
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }  
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowURL"]) {
        if ([segue.destinationViewController isKindOfClass:[AttributedStringViewController class]]) {
            AttributedStringViewController *asc = (AttributedStringViewController *)segue.destinationViewController;
            asc.text = [[NSAttributedString alloc] initWithString:[self.imageURL description]];
            if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
                self.urlPopOver = ((UIStoryboardPopoverSegue *)segue).popoverController;
            }
        }
    }
}

- (void)setTitle:(NSString *)title
{
    super.title = title;
    self.titleBarButtonItem.title = title;
}


- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

- (UIImageView *)imageView
{
    if (!_imageView)
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.scrollView addSubview:self.imageView];    
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    self.titleBarButtonItem.title = self.title;
    [self resetImage];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void) viewDidLayoutSubviews {
    [self resetImage];
}

- (void)resetImage
{
    if (self.scrollView) {
        
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        [self.spinner setColor:[UIColor blackColor]];
        [self.spinner startAnimating];
        
        NSURL *imageURL = self.imageURL;
        
        dispatch_queue_t imageFetchQ = dispatch_queue_create("image fetcher", NULL);
        
        dispatch_async(imageFetchQ, ^{
            
            NSData *imageData = [PhotoCacheManager getPhotoFromCacheFor:imageURL];
     
            if (!imageData) {
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                
                imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             
            }
  
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            
            if (self.imageURL == imageURL) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    if (image) {
                        
                        self.scrollView.contentSize = image.size;
                        
                        self.imageView.image = image;
                        
                        self.imageView.frame = CGRectMake(0,0,image.size.width,image.size.height);
                        
                        CGFloat scaleWidth = self.scrollView.bounds.size.width / self.imageView.bounds.size.width;
                        CGFloat scaleHeight = self.scrollView.bounds.size.height / self.imageView.bounds.size.height;
                        
                        if (!scaleWidth == 0 && !scaleHeight == 0) {
                            self.scrollView.minimumZoomScale = MIN(scaleWidth, scaleHeight);
                            self.scrollView.zoomScale = MAX(scaleWidth, scaleHeight);
                        }      
                    }
                    [self.spinner stopAnimating];
                    
                    [PhotoCacheManager addPhotoToCacheFor:self.imageURL andPhotoData:imageData];

                });     
            }
        });
    }
}

@end

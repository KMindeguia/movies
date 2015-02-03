//
//  KMNetworkLoadingViewController.h
//  BigCentral
//
//  Created by Kevin Mindeguia on 19/11/2013.
//  Copyright (c) 2013 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMActivityIndicator.h"

@protocol KMNetworkLoadingViewDelegate <NSObject>

-(void)retryRequest;

@end

@interface KMNetworkLoadingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet KMActivityIndicator *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIView *noContentView;

@property (weak, nonatomic) id <KMNetworkLoadingViewDelegate> delegate;

- (IBAction)retryRequest:(id)sender;

- (void)showLoadingView;
- (void)showNoContentView;
- (void)showErrorView;


@end

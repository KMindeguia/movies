//
//  KMPhotoTimelineMapCellCell.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface KMMovieDetailsDescriptionCell : UITableViewCell

+ (KMMovieDetailsDescriptionCell*) movieDetailsDescriptionCell;

@property (weak, nonatomic) IBOutlet UILabel *movieDescriptionLabel;

@end

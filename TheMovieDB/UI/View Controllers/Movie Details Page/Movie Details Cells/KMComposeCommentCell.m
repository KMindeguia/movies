//
//  KMComposeCommentCell.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMComposeCommentCell.h"

@implementation KMComposeCommentCell

#pragma mark -
#pragma mark Cell Init Methods

+ (KMComposeCommentCell*) composeCommentsCell
{
    KMComposeCommentCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"KMComposeCommentCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark -
#pragma mark Cell Methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark View Lifecycle

- (void)awakeFromNib
{
    self.composeCommentButton.layer.borderColor =  [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0].CGColor;
    self.composeCommentButton.layer.borderWidth = 1.0f;
    self.composeCommentButton.layer.cornerRadius = 15.0f;
}

@end

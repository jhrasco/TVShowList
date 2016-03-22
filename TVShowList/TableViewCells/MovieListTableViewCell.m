//
//  MovieListTableViewCell.m
//  TVShowList
//
//  Created by John Harold Rasco on 22/03/2016.
//  Copyright © 2016 JRasco™. All rights reserved.
//

#import "MovieListTableViewCell.h"

#import "Movie.h"

@interface MovieListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *channelImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;

@end

@implementation MovieListTableViewCell


#pragma mark - Public Methods

- (void)setMovie:(Movie *)movie {
    _movie = movie;
    
    self.movieTitleLabel.text = movie.name;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@", movie.startTime, movie.endTime];
    
    NSString *channelImageName = [NSString stringWithFormat:@"Station%@", movie.channel];
    self.channelImageView.image = [UIImage imageNamed:channelImageName];
    
    NSString *ratingImageName = [NSString stringWithFormat:@"Rating%@", movie.rating];
    self.ratingImageView.image = [UIImage imageNamed:ratingImageName];
}

@end

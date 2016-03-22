//
//  MovieListHeaderTableViewCell.m
//  TVShowList
//
//  Created by John Harold Rasco on 22/03/2016.
//  Copyright © 2016 JRasco™. All rights reserved.
//

#import "MovieListHeaderTableViewCell.h"

@interface MovieListHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MovieListHeaderTableViewCell

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

@end

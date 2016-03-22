//
//  MovieListTableViewCell.h
//  TVShowList
//
//  Created by John Harold Rasco on 22/03/2016.
//  Copyright © 2016 JRasco™. All rights reserved.
//

#import "TableViewCell.h"

@class Movie;

@interface MovieListTableViewCell : TableViewCell

@property (strong, nonatomic) Movie *movie;

@end

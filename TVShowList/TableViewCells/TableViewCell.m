//
//  TableViewCell.m
//  TVShowList
//
//  Created by John Harold Rasco on 22/03/2016.
//  Copyright © 2016 JRasco™. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

+ (NSString *)cellIdentifier {
    return [NSStringFromClass([self class]) stringByAppendingString:@"_cellID"];
}

@end

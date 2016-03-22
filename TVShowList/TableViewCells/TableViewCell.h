//
//  TableViewCell.h
//  TVShowList
//
//  Created by John Harold Rasco on 22/03/2016.
//  Copyright © 2016 JRasco™. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

/**
 *  Returns the default cell identifier. Can be overridden by the subclass.
 *  The default identifier format is <Name of the class>_cellID.
 *
 *  @return The identifier of the cell.
 */
+ (NSString *)cellIdentifier;

@end

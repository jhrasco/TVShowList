//
//  UIAlertController+Convenience.h
//  TVShowList
//
//  Created by John Harold Rasco on 22/03/2016.
//  Copyright © 2016 JRasco™. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Convenience)

+ (void)showAlertWithViewController:(UIViewController *)viewController
                              title:(NSString *)title
                            message:(NSString *)message;


@end

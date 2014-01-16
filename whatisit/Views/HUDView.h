//
//  HUDView.h
//  Anagrams
//
//  Created by Abhishek Mishra on 4/14/13.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopWatchView.h"

@interface HUDView : UIView

//inside the interface declaration
@property (strong, nonatomic) StopWatchView* stopwatch;
+(instancetype)viewWithRect:(CGRect)r;

@end

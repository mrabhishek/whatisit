//
//  StopWatchView.m
//  Anagrams
//
//  Created by Abhishek Mishra on 4/14/13.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "config.h"
#import "StopWatchView.h"

@implementation StopWatchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.font = kFontHUDBig;
        //self.font = [UIFont fontWithName:@"comic andy" size:62.0];
    }
    return self;
}

//helper method that implements time formatting
//to an int parameter (eg the seconds left)
-(void)setSeconds:(int)seconds
{
    self.text = [NSString stringWithFormat:@" %02.f : %02i", round(seconds / 60), seconds % 60 ];
}

@end

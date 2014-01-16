//
//  HUDView.m
//  Anagrams
//
//  Created by Abhishek Mishra on 4/14/13.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "HUDView.h"
#import "config.h"

@implementation HUDView

+(instancetype)viewWithRect:(CGRect)r
{
    //create the hud layer
    HUDView* hud = [[HUDView alloc] initWithFrame:r];
    
    hud.userInteractionEnabled = NO;
    
    //the stopwatch
    hud.stopwatch = [[StopWatchView alloc] initWithFrame: CGRectMake(kScreenWidth/2-150, 0, 300, 100)];
    hud.stopwatch.seconds = 0;
    [hud addSubview: hud.stopwatch];
    
    return hud;
}

@end

//
//  config.h
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#ifndef configed

//UI defines
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

//add more definitions here


//handy math functions
#define rad2deg(x) x * 180 / M_PI
#define deg2rad(x) x * M_PI / 180
#define randomf(minX,maxX) ((float)(arc4random() % (maxX - minX + 1)) + (float)minX)


#define configed 1

#define kTileWidthMargin 10 //Remove the hardcoding
#define kTileHeightMargin 10 //Remove the hardcoding

#define kFontHUD [UIFont fontWithName:@"comic andy" size:32.0] //change values
#define kFontHUDBig [UIFont fontWithName:@"comic andy" size:60.0]//change values

#endif
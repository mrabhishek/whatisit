//
//  ApplicationConstants.h
//  clearway
//
//  Created by Abhishek Mishra on 7/5/13.
//
//

#import <Foundation/Foundation.h>

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

//Convert any cocos2D dimension to a Box2D dimension
#define _X(x) ((float)x)/PTM_RATIO

#define TAG_HUD  201
#define TAG_OVERLAY_MENU 301
#define TAG_LEVEL_MENU 401
#define TAG_GAME_LAYER_TEXT 501
#define TAG_GAME_CONTROLLER_TEXT 601
#define TAG_EPISODE_SELECT_MENU 701
#define TAG_LEVEL_SELECT_MENU 801

//Fonts to use
#define kFontNormal [UIFont fontWithName:@"comic andy" size:32.0] //change values
#define kFontBig [UIFont fontWithName:@"comic andy" size:60.0]//change values
#define kFontName @"comic andy"//change values
#define kSupportedObstacles 20
#define kSupportedJoints 20
#define kCircleRadius 25
#define kPlusWidth 10
#define kPlusHeight 40
#define kPlusWidthSmall 2
#define kPlusHeightSmall 8
#define kBallRestitution 0.80f
#define kHorizontalWallHeight 10
#define kVerticalWallWidth 10
#define kHorizontalSideWallHeight 2.5
#define kVerticalSideWallWidth 2.5 //1/4 of the image box
#define kTotalNumberOfEpisodes 4 //go on adding episodes
#define kLevelsPerEpisode 5
#define kFontFileName @"Comic_Andy.ttf"
#define iPadMultiplier 1 //change this value 

@interface ApplicationConstants : NSObject

enum ShapeType
{
    unknown = 0,
    circle,
    chain,
    plus,
    plus_small,
    hwall_quarter,
    hwall_half,
    hwall_full,
    vwall_quarter,
    vwall_half,
    vwall_full,
};

enum ResultType
{
    noResult =0,
    levelComplete,
    levelFailed
};

@end

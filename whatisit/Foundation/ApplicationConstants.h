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

//Fonts to use
#define kFontNormal [UIFont fontWithName:@"comic andy" size:32.0] //change values
#define kFontBig [UIFont fontWithName:@"comic andy" size:60.0]//change values
#define kFontName @"comic andy"//change values

@interface ApplicationConstants : NSObject

@end

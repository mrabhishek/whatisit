//
//  CoordinateHelper.h
//  whatisit
//
//  Created by Abhishek Mishra on 1/5/14.
//
//

#import "cocos2d.h"

@interface CoordinateHelper : NSObject

+(CGPoint) screenPositionToLevelPosition:(CGPoint) position;
+(CGPoint) levelPositionToScreenPosition:(CGPoint) position;

@end

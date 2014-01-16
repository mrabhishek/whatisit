//
//  CoordinateHelper.m
//  whatisit
//
//  Created by Abhishek Mishra on 1/5/14.
//
//

#import "CoordinateHelper.h"

@implementation CoordinateHelper

+(CGPoint) screenPositionToLevelPosition:(CGPoint) position {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    return CGPointMake(position.x / winSize.width, position.y / winSize.height);
}

+(CGPoint) levelPositionToScreenPosition:(CGPoint) position {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    return CGPointMake(position.x * winSize.width, position.y * winSize.height);
}

@end

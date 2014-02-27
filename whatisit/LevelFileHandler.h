//
//  LevelFileHandler.h
//  whatisit
//
//  Created by Abhishek Mishra on 1/5/14.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "box2DHelper.h"
#import "ApplicationConstants.h"

@class Player, Target,Obstacle;

@interface LevelFileHandler : NSObject

@property Player* player;
@property Target* target;
@property NSMutableArray* obstacles;

+(CGPoint) levelPositionToScreenPosition:(CGPoint) position;
- (id)initWithFileName:(NSString*) fileName;

@end

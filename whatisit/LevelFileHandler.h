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

@class Player, Target,Obstacle,RevoluteJoint;

@interface LevelFileHandler : NSObject

@property (retain) Player* player;
@property (retain) Target* target;
@property (retain) NSMutableArray* obstacles;
@property (retain) NSMutableArray* revoluteJoints;

+(CGPoint) levelPositionToScreenPosition:(CGPoint) position;
- (id)initWithFileName:(NSString*) fileName;

@end

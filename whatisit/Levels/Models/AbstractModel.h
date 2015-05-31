//
//  AbstractModel.h
//  whatisit
//
//  Created by Abhishek Mishra on 1/5/14.
//
//

#import <Foundation/Foundation.h>
#import "ApplicationConstants.h"
#include <Box2D/Box2D.h>

@interface AbstractModel : NSObject

@property int Id;
@property CGPoint Position;
@property b2BodyType bodyType;
@property ShapeType shape;
@property int points;
@property bool die;
@property bool sensor;
@property bool killerwall;
@property bool bonus;
@property bool movingx;
@property bool movingy;
@property CGPoint from;
@property CGPoint to;
@property b2Vec2 vel;
@property int angularVelocity;
@property float density;


@end

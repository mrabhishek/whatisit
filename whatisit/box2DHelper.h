//
//  box2DHelper.h
//  whatisit
//
//  Created by Abhishek Mishra on 1/19/14.
//
//

#import <Foundation/Foundation.h>
#include"Box2D/Box2D.h"
#include "ApplicationConstants.h"

@interface box2DHelper : NSObject

+(b2BodyType)bodyTypeFrombodyTypeString :(NSString*) bodyTypeStr;
+(ShapeType)shapeFromShapeString :(NSString*) shapeStr;



@end

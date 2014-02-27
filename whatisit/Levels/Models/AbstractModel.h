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

@end

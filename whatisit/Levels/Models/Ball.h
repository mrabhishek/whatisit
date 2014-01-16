//
//  Ball.h
//  whatisit
//
//  Created by Abhishek Mishra on 12/29/13.
//
//

#import <Foundation/Foundation.h>

#include <Box2D/Box2D.h>
#include "ApplicationConstants.h"

@interface Ball : NSObject
{
    b2Body* box2DBody;
    
}

-(void)setBody: (b2Body*) body;

@end

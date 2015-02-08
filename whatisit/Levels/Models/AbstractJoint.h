//
//  AbstractJoint.h
//  whatisit
//
//  Created by Abhishek Mishra on 7/7/14.
//
//

#import <Foundation/Foundation.h>
#import "ApplicationConstants.h"
#include <Box2D/Box2D.h>

@interface AbstractJoint : NSObject

@property int Id;
@property NSString* jointType;
@property bool collideConnected;

@end

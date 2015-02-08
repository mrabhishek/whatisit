//
//  Joint.h
//  whatisit
//
//  Created by Abhishek Mishra on 7/7/14.
//
//

#import <Foundation/Foundation.h>
#import "AbstractJoint.h"

@interface RevoluteJoint : AbstractJoint

@property int IdBodyA;
@property int IdBodyB;

@end

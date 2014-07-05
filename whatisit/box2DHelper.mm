//
//  box2DHelper.m
//  whatisit
//
//  Created by Abhishek Mishra on 1/19/14.
//
//

#import "box2DHelper.h"

@implementation box2DHelper

+(ShapeType)shapeFromShapeString :(NSString*) shapeStr
{
    ShapeType shape = unknown;
    
    if([shapeStr isEqualToString:@"circle"])
    {
        shape = circle;
    }
    else if ([shapeStr isEqualToString:@"plus"])
    {
        shape = plus;
    }
    else if ([shapeStr isEqualToString:@"plus_small"])
    {
        shape = plus_small;
    }
    else if ([shapeStr isEqualToString:@"hwall_half"])
    {
        shape = hwall_half;
    }
    else if ([shapeStr isEqualToString:@"hwall_full"])
    {
        shape = hwall_full;
    }
    else if ([shapeStr isEqualToString:@"vwall_half"])
    {
        shape = vwall_half;
    }
    else if ([shapeStr isEqualToString:@"vwall_full"])
    {
        shape = vwall_full;
    }
    else if ([shapeStr isEqualToString:@"hwall_quarter"])
    {
        shape = hwall_quarter;
    }
    else if ([shapeStr isEqualToString:@"vwall_quarter"])
    {
        shape = vwall_quarter;
    }
    
    return shape;
}

+(b2BodyType)bodyTypeFrombodyTypeString :(NSString*) bodyTypeStr
{
    b2BodyType type = b2_dynamicBody;
    
    if([bodyTypeStr isEqualToString:@"kinematic"])
    {
        type = b2_kinematicBody;
    }
    else if ([bodyTypeStr isEqualToString:@"dynamic"])
    {
        type = b2_dynamicBody;
    }
    else if ([bodyTypeStr isEqualToString:@"static"])
    {
        type = b2_staticBody;
    }
    
    return type;
}



@end

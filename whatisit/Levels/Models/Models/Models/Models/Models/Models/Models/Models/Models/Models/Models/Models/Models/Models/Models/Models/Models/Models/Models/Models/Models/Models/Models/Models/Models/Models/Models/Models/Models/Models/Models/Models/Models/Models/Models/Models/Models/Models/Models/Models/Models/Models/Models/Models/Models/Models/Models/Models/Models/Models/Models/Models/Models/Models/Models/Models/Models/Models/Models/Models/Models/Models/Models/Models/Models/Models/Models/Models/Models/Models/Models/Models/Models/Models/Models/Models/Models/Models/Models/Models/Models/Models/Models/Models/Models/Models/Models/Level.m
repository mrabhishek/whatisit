//
//  Level.m
//  Anagrams
//
//  Created by Abhishek Mishra on 4/13/13.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "Level.h"

@implementation Level

+(instancetype)levelWithNum:(int)levelNum;
{
    //1 find .plist file for this level
    NSString* fileName = [NSString stringWithFormat:@"level%i.plist", levelNum];
    NSString* levelPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    
    //2 load .plist file
    NSDictionary* levelDict = [NSDictionary dictionaryWithContentsOfFile:levelPath];
    
    //3 validation
    NSAssert(levelDict, @"level config file not found");
    
    //4 create Level instance
    Level* l = [[Level alloc] init];
    
    //5 initialize the object from the dictionary
    l.pointsPerTile = [levelDict[@"pointsPerTile"] intValue];
    l.anagrams = levelDict[@"anagrams"];
    l.timeToSolve = [levelDict[@"timeToSolve"] intValue];
    
    return l;
}


@end

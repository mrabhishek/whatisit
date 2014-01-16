//
//  GameIPAHelper.m
//  Rocket Singh
//
//  Created by Abhishek Mishra on 11/7/12.
//
//

#import "GameIAPHelper.h"

@implementation GameIAPHelper

static GameIAPHelper * _sharedHelper;

+ (GameIAPHelper *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[GameIAPHelper alloc] init];
    return _sharedHelper;
    
}

- (id)init {
    
    NSSet *productIdentifiers = [NSSet setWithObjects:
                                 @"com.amishra.tutuescape.stars",
                                 //@"com.amishra.tutuescape.10lives",
                                 //@"com.amishra.tutuescape.directtospace",
                                 /*@"com.raywenderlich.inapprage.itunesconnectrage",
                                  @"com.raywenderlich.inapprage.nightlyrage",
                                  @"com.raywenderlich.inapprage.studylikeaboss",
                                  @"com.raywenderlich.inapprage.updogsadness",*/
                                 nil];
    
    if ((self = [super initWithProductIdentifiers:productIdentifiers])) {
        
    }
    return self;
    
}

-(void)dealloc {
    [_sharedHelper release];
    [super dealloc];
}

@end
//
//  MOMSceneUtils.h
//  Mami Weather
//
//  Created by Laura Sirvent Collado on 29/5/16.
//  Copyright © 2016 Qult. All rights reserved.
//

#import <Foundation/Foundation.h>

@import SceneKit;

@interface MOMSceneUtils : NSObject

+ (CAAnimation *)loadAnimationFromSceneNamed:(NSString *)sceneName;

@end

//
//  MOMSceneUtils.m
//  Mami Weather
//
//  Created by Laura Sirvent Collado on 29/5/16.
//  Copyright © 2016 Qult. All rights reserved.
//

#import "MOMSceneUtils.h"

@implementation MOMSceneUtils

+ (CAAnimation *)loadAnimationFromSceneNamed:(NSString *)sceneName {
    SCNScene *scene = [SCNScene sceneNamed:sceneName];
    
    // find top level animation
    __block CAAnimation *animation = nil;
    [scene.rootNode enumerateChildNodesUsingBlock:^(SCNNode *child, BOOL *stop) {
        if (child.animationKeys.count > 0) {
            animation = [child animationForKey:child.animationKeys[0]];
            *stop = YES;
        }
    }];
    
    return animation;
}

@end

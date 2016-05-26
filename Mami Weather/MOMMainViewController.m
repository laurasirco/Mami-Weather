//
//  MOMMainViewController.m
//  Mami Weather
//
//  Created by Laura Sirvent Collado on 23/5/16.
//  Copyright © 2016 Qult. All rights reserved.
//

#import "MOMMainViewController.h"

@interface MOMMainViewController (){
    CAAnimation * windAnimation;
}

@end

@implementation MOMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupScene];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupScene {
    
    SCNScene * scene = [SCNScene sceneNamed:@"3DAssets.scnassets/planta.scn"];
    self.scene.scene = scene;
    self.scene.playing = YES;
    self.scene.allowsCameraControl = YES;
    self.scene.backgroundColor = [UIColor blackColor];
    
    SCNNode *armature = [scene.rootNode childNodeWithName:@"Armature" recursively:YES];
    windAnimation = [self loadAnimationFromSceneNamed:@"3DAssets.scnassets/PlantaAnim.scn"];
    windAnimation.speed = 1;
    windAnimation.repeatCount = FLT_MAX;
    windAnimation.usesSceneTimeBase = NO;
    [armature addAnimation:windAnimation forKey:@"wind"];
}

#pragma mark - Utils

- (CAAnimation *)loadAnimationFromSceneNamed:(NSString *)sceneName {
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

//
//  MOMMainViewController.m
//  Mami Weather
//
//  Created by Laura Sirvent Collado on 23/5/16.
//  Copyright © 2016 Qult. All rights reserved.
//

#import "MOMMainViewController.h"
#import "MOMSceneUtils.h"

@interface MOMMainViewController (){
    CAAnimation * lowWindAnimation;
    CAAnimation * highWindAnimation;
    SCNNode * plantArmature;
    SCNScene * windowScene;
}

@end

@implementation MOMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setup {
    
    [self setupScene];
    
    [self setupAmbientColors];
}

#pragma mark - Window Scene Configuration

- (void) setupScene {
    
    windowScene = [SCNScene sceneNamed:@"3DAssets.scnassets/windowNoAnim.scn"];
    self.sceneView.scene = windowScene;
    self.sceneView.playing = YES;
    //self.sceneView.allowsCameraControl = YES;
    
    self.sceneView.backgroundColor = [UIColor clearColor];
    
    plantArmature = [windowScene.rootNode childNodeWithName:@"windowNoAnim-1" recursively:YES];

    [self loadAnimations];
    [self startLowWindAnimation];
}

- (void) loadAnimations {
    
    lowWindAnimation = [MOMSceneUtils loadAnimationFromSceneNamed:@"3DAssets.scnassets/lowWind.scn"];
    lowWindAnimation.speed = 1;
    lowWindAnimation.repeatCount = FLT_MAX;
    lowWindAnimation.usesSceneTimeBase = NO;
    
    highWindAnimation = [MOMSceneUtils loadAnimationFromSceneNamed:@"3DAssets.scnassets/highWind.scn"];
    highWindAnimation.speed = 1;
    highWindAnimation.repeatCount = FLT_MAX;
    highWindAnimation.usesSceneTimeBase = NO;
}

- (void) startLowWindAnimation {
    
    [plantArmature addAnimation:lowWindAnimation forKey:@"lowWindAnimation"];
}

- (void) stopLowWindAnimation {
    
    [plantArmature removeAnimationForKey:@"lowWindAnimation"];
}

- (void) startHighWindAnimation {
    
    [plantArmature addAnimation:highWindAnimation forKey:@"highWindAnimation"];
}

- (void) stopHighWindAnimation {
    
    [plantArmature removeAnimationForKey:@"highWindAnimation"];
}

- (void) setupAmbientColors {
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.3 green:0.6 blue:0.95 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:1.0 green:0.5 blue:0.1 alpha:1.0] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

@end

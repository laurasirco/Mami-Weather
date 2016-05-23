//
//  MOMMainViewController.m
//  Mami Weather
//
//  Created by Laura Sirvent Collado on 23/5/16.
//  Copyright © 2016 Qult. All rights reserved.
//

#import "MOMMainViewController.h"

@interface MOMMainViewController ()

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
    
    SCNScene * scene = [SCNScene sceneNamed:@"3DAssets.scnassets/scene.scn"];
    self.scene.scene = scene;
    self.scene.playing = YES;
}

@end

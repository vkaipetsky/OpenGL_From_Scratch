//
//  AppDelegate.h
//  OpenGL_From_Scratch
//
//  Created by Vladislav Kaipetskiy on 02/02/2015.
//  Copyright (c) 2015 Vladislav Kaipetskiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKView.h>
#import <GLKit/GLKViewController.h>

#import <GLKit/GLKBaseEffect.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, GLKViewDelegate, GLKViewControllerDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GLKBaseEffect *effect;


@end


//
//  AppDelegate.m
//  OpenGL_From_Scratch
//
//  Created by Vladislav Kaipetskiy on 02/02/2015.
//  Copyright (c) 2015 Vladislav Kaipetskiy. All rights reserved.
//

#import "AppDelegate.h"

#import <GLKit/GLKit.h>

#import <OpenGLES/ES1/gl.h> // for glOrthof

#import <Foundation/NSArray.h>



@interface Person : NSObject
{
    NSString *firstName;
    NSString *lastName;
    int age;
}

-(void) woop;
@end


@implementation Person

-(void) woop
{
    
}

@end



@interface ClickLocation : NSObject
{
@public
    CGPoint loc;
}

@end

@implementation ClickLocation


@end



@interface AppDelegate ()

@end

@implementation AppDelegate
{
    float m_curRed;
    bool m_increasing;
}

@synthesize effect = _effect;

- (void)glkViewControllerUpdate:(GLKViewController *)controller
{
    if(m_increasing)
    {
        m_curRed += 0.01f;
        if(m_curRed > 1.0f)
        {
            m_curRed = 1.0f;
            m_increasing = false;
        }
    }
    else
    {
        m_curRed -= 0.01f;
        if (m_curRed < 0.0f)
        {
            m_curRed = 0.0f;
            m_increasing = true;
        }
    }
}

typedef struct {
    float Position[3];
    float Color[4];
} Vertex;

const Vertex Vertices[] = {
    {{ 5, -5, 0}, {1, 0, 0, 1}},
    {{ 5,  5, 0}, {0, 1, 0, 1}},
    {{-5,  5, 0}, {0, 0, 1, 1}},
    {{-5, -5, 0}, {0, 0, 0, 1}}
};

const GLubyte Indices[] = {
    0, 1, 2,
    2, 3, 0
};

//CGPoint locations[1000];
//CGPoint* locations = 0;
//int numLocations;

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(m_curRed, 1.0, 1.0, 1.0);
//    glClear(GL_COLOR_BUFFER_BIT);
    
//    GLfloat aspect = fabsf(view.drawableWidth / view.drawableHeight);
    
//    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 4.0f, 10.0f);
    GLKMatrix4 projectionMatrix =
        GLKMatrix4MakeOrtho((GLfloat)0.0f, (GLfloat)view.drawableWidth,
                            (GLfloat)0.0f, (GLfloat)view.drawableHeight, (GLfloat)-1.0f, (GLfloat)1.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
//    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(15, 15, 0);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    
//    glOrthof( (GLfloat)0.0f, (GLfloat)view.drawableWidth,
//              (GLfloat)0.0f, (GLfloat)view.drawableHeight, (GLfloat)-1.0f, (GLfloat)1.0f );
    
//    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    
    [self.effect prepareToDraw];
    
    // TODO: this is already done in setup!
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));
    
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
/*
    for ( int i = 0;  i < 5;  i++ )
    {
        GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(i*30, 200, 0);
        self.effect.transform.modelviewMatrix = modelMatrix;
        
        [self.effect prepareToDraw];
        
        glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    }
*/
    
    /*
    for ( int i = 0;  i < numLocations;  i++ )
    {
        GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(2*locations[i].x, view.drawableHeight - 2*locations[i].y, 0);
        self.effect.transform.modelviewMatrix = modelMatrix;
        
        [self.effect prepareToDraw];
        
        glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    }
    */
    
    /*
//    for ( CGPoint *curLoc in locationsDyn )
    for ( int i = 0;  i < numLocations;  i++ )
    {
        CGPoint* curLoc = (__bridge CGPoint *)(locationsDyn[i]);
        GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(2*curLoc->x, view.drawableHeight - 2*curLoc->y, 0);
        self.effect.transform.modelviewMatrix = modelMatrix;
        
        [self.effect prepareToDraw];
        
        glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    }
    */
    
    for (ClickLocation *curLoc in clickLocations) {
        GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(2*curLoc->loc.x, view.drawableHeight - 2*curLoc->loc.y, 0);
        self.effect.transform.modelviewMatrix = modelMatrix;
        
        [self.effect prepareToDraw];
        
        glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    }
    
//    glBegin(GL_LINES);
//    glVertex3f();
//    glEnd();
}

//- (void)render:(CADisplayLink*)displayLink {
//    GLKView * view = [self.window.subviews objectAtIndex:0];
//    [view display];
//}

GLuint _vertexBuffer;
GLuint _indexBuffer;
NSMutableArray *locationsDyn;
NSMutableArray *clickLocations;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    EAGLContext * context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; // 1
    GLKView *view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; // 2
    view.context = context; // 3
    view.delegate = self; // 4
    [self.window addSubview:view]; // 5
    
 //    view.enableSetNeedsDisplay = NO; // VLAD TODO: what does this do? is it ever needed?
//    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
//    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    GLKViewController * viewController = [[GLKViewController alloc] initWithNibName:nil bundle:nil]; // 1
    viewController.view = view; // 2
    viewController.delegate = self; // 3
    viewController.preferredFramesPerSecond = 60; // 4
    self.window.rootViewController = viewController; // 5
    
    [EAGLContext setCurrentContext:view.context];
    self.effect = [[GLKBaseEffect alloc] init];
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
//    [self.window makeKeyAndVisible]; // VLAD TODO: what does this do? is it ever needed?
    m_curRed = 0.0f;
    m_increasing = true;
    
//    locations = malloc( sizeof(CGPoint) * 10000 );
//    numLocations = 0;
    
//    locationsDyn = [[NSMutableArray alloc] init];
    /*
    // Test working with a dynamic array
    {
        NSMutableArray *ppl = [[NSMutableArray alloc] init];
        Person* newPerson = [[Person alloc] init];
        [ppl addObject:newPerson];
        
        for (Person *onePerson in ppl) {
            [onePerson woop];
        }
    }
    */
    clickLocations = [[NSMutableArray alloc] init];
    
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    for (UITouch *touch in allTouches)
    {
        CGPoint location = [touch locationInView:touch.view];
//        locations[numLocations++] = location;
        
        ClickLocation* locDyn = [[ClickLocation alloc] init];
        locDyn->loc = location;
        [clickLocations addObject:locDyn];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
//    locations[numLocations++] = location;

    ClickLocation* locDyn = [[ClickLocation alloc] init];
    locDyn->loc = location;
    [clickLocations addObject:locDyn];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    lastButton = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
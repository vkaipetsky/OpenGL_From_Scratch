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



@interface TouchSequenceForASingleFinger : NSObject
{
@public
    UITouch* touch;
    NSMutableArray* locations;
}

@end

@implementation TouchSequenceForASingleFinger


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
    {{ 25, -25, 0}, {1, 0, 0, 1}},
    {{ 25,  25, 0}, {0, 1, 0, 1}},
    {{-25,  25, 0}, {0, 0, 1, 1}},
    {{-25, -25, 0}, {0, 0, 0, 1}}
};

const GLubyte Indices[] = {
    0, 1, 2,
    2, 3, 0
};

CGPoint locations[1000];
//CGPoint* locations = 0;
int numLocations = 0;

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.3f*m_curRed, 0.3f*1.0f, 0.3f*1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
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
    
    for (ClickLocation *curLoc in clickLocations) {
        GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(2*curLoc->loc.x, view.drawableHeight - 2*curLoc->loc.y, 0);
        self.effect.transform.modelviewMatrix = modelMatrix;
        
        [self.effect prepareToDraw];
        
        glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    }
    
    for (int i = 0;  i < numLocations; i++) {
        GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(2*locations[i].x, view.drawableHeight - 2*locations[i].y, 0);
        self.effect.transform.modelviewMatrix = modelMatrix;
        
        [self.effect prepareToDraw];
        
        glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    }
    
//    glBegin(GL_LINES);
//    glVertex3f();
//    glEnd();

    {
        // Move back to identity
        self.effect.transform.modelviewMatrix = GLKMatrix4Identity;

        // Let's color the line
        self.effect.useConstantColor = GL_TRUE;
        
        // Apparently not enough to do the above! Must also do this:
        glDisableVertexAttribArray(GLKVertexAttribColor);
        
        // Make the line a cyan color
        self.effect.constantColor = GLKVector4Make(0.0f, // Red
                                                   1.0f, // Green
                                                   1.0f, // Blue
                                                   1.0f);// Alpha
        
        [self.effect prepareToDraw];
        
        NSUInteger screenH = view.drawableHeight;
        NSUInteger screenW = view.drawableWidth;
        
        const GLfloat line[] =
        {
            1.0f, 1.0f, //point A
            1.0f, screenH-2, //point B
            
            1.0f, 1.0f,
            screenW-2, 1.0f,
            
            screenW-2, 1.0f, //point A
            screenW-2, screenH-2, //point B
            
            1.0f, screenH-2,
            screenW-2, screenH-2,
        };
        
        // Create an handle for a buffer object array
        GLuint bufferObjectNameArray;
        
        // Have OpenGL generate a buffer name and store it in the buffer object array
        glGenBuffers(1, &bufferObjectNameArray);
        
        // Bind the buffer object array to the GL_ARRAY_BUFFER target buffer
        glBindBuffer(GL_ARRAY_BUFFER, bufferObjectNameArray);
        
        // Send the line data over to the target buffer in GPU RAM
        glBufferData(GL_ARRAY_BUFFER,   // the target buffer
                     sizeof(line),      // the number of bytes to put into the buffer
                     line,              // a pointer to the data being copied
                     GL_STATIC_DRAW);   // the usage pattern of the data
        
        // Enable vertex data to be fed down the graphics pipeline to be drawn
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        
        // Specify how the GPU looks up the data
        glVertexAttribPointer(GLKVertexAttribPosition, // the currently bound buffer holds the data
                              2,                       // number of coordinates per vertex
                              GL_FLOAT,                // the data type of each component
                              GL_FALSE,                // can the data be scaled
                              2*4,                     // how many bytes per vertex (2 floats per vertex)
                              NULL);                   // offset to the first coordinate, in this case 0 
        
        glDrawArrays(GL_LINES, 0, 8); // render
        
if(1)
{
    if (1)
    {
        NSUInteger memorySize = sizeof(GLfloat) * 2 * ( (numLocations+1) * 2 - 1 );
        GLfloat *linesMemory = malloc( memorySize );
        
        int curLocInMemory = 0;
        for (int i = 0;  i < numLocations;  i++)
        {
            linesMemory[ curLocInMemory ] = 2*locations[i].x;
            linesMemory[ curLocInMemory + 1 ] = view.drawableHeight - 2*locations[i].y;
            
            curLocInMemory += 2;
        }

        // Close the contour
        linesMemory[ curLocInMemory ] = 2*locations[0].x;
        linesMemory[ curLocInMemory + 1 ] = view.drawableHeight - 2*locations[0].y;
        curLocInMemory += 2;
        
        // Create an handle for a buffer object array
        GLuint bufferObjectNameArray;
        
        // Have OpenGL generate a buffer name and store it in the buffer object array
        glGenBuffers(1, &bufferObjectNameArray);
        
        // Bind the buffer object array to the GL_ARRAY_BUFFER target buffer
        glBindBuffer(GL_ARRAY_BUFFER, bufferObjectNameArray);
        
        // Send the line data over to the target buffer in GPU RAM
        glBufferData(GL_ARRAY_BUFFER,   // the target buffer
                     sizeof(GLfloat) * 2 * (numLocations+1),      // the number of bytes to put into the buffer
                     linesMemory,              // a pointer to the data being copied
                     GL_DYNAMIC_DRAW);   // the usage pattern of the data
        
        // Enable vertex data to be fed down the graphics pipeline to be drawn
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        
        // Specify how the GPU looks up the data
        glVertexAttribPointer(GLKVertexAttribPosition, // the currently bound buffer holds the data
                              2,                       // number of coordinates per vertex
                              GL_FLOAT,                // the data type of each component
                              GL_FALSE,                // can the data be scaled
                              2*4,                     // how many bytes per vertex (2 floats per vertex)
                              NULL);                   // offset to the first coordinate, in this case 0
        
        glDrawArrays(GL_LINE_STRIP, 0, curLocInMemory/2); // render
        
        free( linesMemory );
    }
    else
    {
    for (TouchSequenceForASingleFinger *curTrackedTouchSeq in trackedTouches)
    {
        NSUInteger numLocs = curTrackedTouchSeq->locations.count;
        
        if (numLocs)
        {
            NSUInteger memorySize = sizeof(GLfloat) * 2 * ( numLocs * 2 - 1 );
            GLfloat *linesMemory = malloc( memorySize );
            
            int curLocInMemory = 0;
            for (ClickLocation *curLoc in curTrackedTouchSeq->locations)
            {
                linesMemory[ curLocInMemory ] = 2*curLoc->loc.x;
                linesMemory[ curLocInMemory + 1 ] = view.drawableHeight - 2*curLoc->loc.y;
                
                curLocInMemory += 2;
            }
            
            // Create an handle for a buffer object array
            GLuint bufferObjectNameArray;
            
            // Have OpenGL generate a buffer name and store it in the buffer object array
            glGenBuffers(1, &bufferObjectNameArray);
            
            // Bind the buffer object array to the GL_ARRAY_BUFFER target buffer
            glBindBuffer(GL_ARRAY_BUFFER, bufferObjectNameArray);
            
            // Send the line data over to the target buffer in GPU RAM
            glBufferData(GL_ARRAY_BUFFER,   // the target buffer
                         sizeof(GLfloat) * 2 * numLocs,      // the number of bytes to put into the buffer
                         linesMemory,              // a pointer to the data being copied
                         GL_DYNAMIC_DRAW);   // the usage pattern of the data
            
            // Enable vertex data to be fed down the graphics pipeline to be drawn
            glEnableVertexAttribArray(GLKVertexAttribPosition);
            
            // Specify how the GPU looks up the data
            glVertexAttribPointer(GLKVertexAttribPosition, // the currently bound buffer holds the data
                                  2,                       // number of coordinates per vertex
                                  GL_FLOAT,                // the data type of each component
                                  GL_FALSE,                // can the data be scaled
                                  2*4,                     // how many bytes per vertex (2 floats per vertex)
                                  NULL);                   // offset to the first coordinate, in this case 0
            
            glDrawArrays(GL_LINE_STRIP, 0, curLocInMemory/2); // render
            
            free( linesMemory );
        }
    }
    }
    
}
else
{
        // Now try drawing the touched path
        NSUInteger numLocs = clickLocations.count;
 
        if (numLocs)
        {
            NSUInteger memorySize = sizeof(GLfloat) * 2 * ( numLocs * 2 - 1 );
            GLfloat *linesMemory = malloc( memorySize );
            
            int curLocInMemory = 0;
            for (ClickLocation *curLoc in clickLocations)
            {
                linesMemory[ curLocInMemory ] = 2*curLoc->loc.x;
                linesMemory[ curLocInMemory + 1 ] = view.drawableHeight - 2*curLoc->loc.y;
                
                curLocInMemory += 2;
            }

            // Create an handle for a buffer object array
            GLuint bufferObjectNameArray;
            
            // Have OpenGL generate a buffer name and store it in the buffer object array
            glGenBuffers(1, &bufferObjectNameArray);
            
            // Bind the buffer object array to the GL_ARRAY_BUFFER target buffer
            glBindBuffer(GL_ARRAY_BUFFER, bufferObjectNameArray);
            
            // Send the line data over to the target buffer in GPU RAM
            glBufferData(GL_ARRAY_BUFFER,   // the target buffer
                         sizeof(GLfloat) * 2 * numLocs,      // the number of bytes to put into the buffer
                         linesMemory,              // a pointer to the data being copied
                         GL_DYNAMIC_DRAW);   // the usage pattern of the data
            
            // Enable vertex data to be fed down the graphics pipeline to be drawn
            glEnableVertexAttribArray(GLKVertexAttribPosition);
            
            // Specify how the GPU looks up the data
            glVertexAttribPointer(GLKVertexAttribPosition, // the currently bound buffer holds the data
                                  2,                       // number of coordinates per vertex
                                  GL_FLOAT,                // the data type of each component
                                  GL_FALSE,                // can the data be scaled
                                  2*4,                     // how many bytes per vertex (2 floats per vertex)
                                  NULL);                   // offset to the first coordinate, in this case 0
            
            glDrawArrays(GL_LINE_STRIP, 0, curLocInMemory/2); // render
            
            free( linesMemory );
        }
}
    }
}

//- (void)render:(CADisplayLink*)displayLink {
//    GLKView * view = [self.window.subviews objectAtIndex:0];
//    [view display];
//}

GLuint _vertexBuffer;
GLuint _indexBuffer;
NSMutableArray *locationsDyn;
NSMutableArray *clickLocations;
NSMutableArray* trackedTouches;

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
    
    trackedTouches = [[NSMutableArray alloc] init];
    
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*
     NSSet *allTouches = [event allTouches];
    for (UITouch *touch in allTouches)
    {
        CGPoint location = [touch locationInView:touch.view];
//        locations[numLocations++] = location;
        
        ClickLocation* locDyn = [[ClickLocation alloc] init];
        locDyn->loc = location;
        [clickLocations addObject:locDyn];
    }
     */
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    
    numLocations = 0;
    
    for (UITouch *touch in allTouches)
    {
        TouchSequenceForASingleFinger *foundTrackedTouchSeq = 0;
        
        for (TouchSequenceForASingleFinger *curTrackedTouchSeq in trackedTouches)
        {
            if (touch == curTrackedTouchSeq->touch)
            {
                foundTrackedTouchSeq = curTrackedTouchSeq;
                break;
            }
        }
        
        if ( foundTrackedTouchSeq == 0 )
        {
            TouchSequenceForASingleFinger* newTrackedTouch = [[TouchSequenceForASingleFinger alloc] init];
            newTrackedTouch->touch = touch;
            [trackedTouches addObject:newTrackedTouch];
            foundTrackedTouchSeq = newTrackedTouch;
        }
        
        CGPoint location = [touch locationInView:touch.view];
        
        locations[numLocations++] = location;
        
        ClickLocation* locDyn = [[ClickLocation alloc] init];
        locDyn->loc = location;
        
        [foundTrackedTouchSeq->locations addObject:locDyn];
    }
    /*
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
//    locations[numLocations++] = location;

    ClickLocation* locDyn = [[ClickLocation alloc] init];
    locDyn->loc = location;
    [clickLocations addObject:locDyn];
    */
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

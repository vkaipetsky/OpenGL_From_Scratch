//
//  C++Wrapper.mm
//  OpenGL_From_Scratch
//
//  Created by Vladislav Kaipetskiy on 10/09/2015.
//  Copyright (c) 2015 Vladislav Kaipetskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "C++Wrapper.h"

#include "C++Try1.h"


@implementation CPP_Wrapper


-(void) woop
{
    TempC<unsigned long>* newTempC = try2();
    delete newTempC;
}


@end

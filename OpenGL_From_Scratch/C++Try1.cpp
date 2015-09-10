//
//  C++Try1.cpp
//  OpenGL_From_Scratch
//
//  Created by Vladislav Kaipetskiy on 10/09/2015.
//  Copyright (c) 2015 Vladislav Kaipetskiy. All rights reserved.
//

#include "C++Try1.h"

#include <stdio.h>




void try1( void )
{
    TempC<unsigned long>* newTempC = new TempC<unsigned long>;
    delete newTempC;
    
    return;
}

TempC<unsigned long>* try2( void )
{
    TempC<unsigned long>* newTempC = new TempC<unsigned long>;
    
    return newTempC;
}

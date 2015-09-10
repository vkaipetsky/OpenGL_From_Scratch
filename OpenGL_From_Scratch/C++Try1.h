//
//  C++Try1.h
//  OpenGL_From_Scratch
//
//  Created by Vladislav Kaipetskiy on 10/09/2015.
//  Copyright (c) 2015 Vladislav Kaipetskiy. All rights reserved.
//

#ifndef __OpenGL_From_Scratch__C__Try1__
#define __OpenGL_From_Scratch__C__Try1__

template <typename T>
class TempC
{
public:
    TempC()
    {
    }
    void* m_ptr;
};

//#ifdef __cplusplus
//extern "C" {
//#endif
    
void try1( void );
    
class TempC<unsigned long>* try2( void );

//#ifdef __cplusplus
//}
//#endif

#endif /* defined(__OpenGL_From_Scratch__C__Try1__) */

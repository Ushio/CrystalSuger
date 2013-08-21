/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


#ifndef CrystalSuger_KompeitoConstants_h
#define CrystalSuger_KompeitoConstants_h

static const GLKVector4 kKompeitoColorValues[] =
{
    {1.0f, 1.0f, 1.0f, 1.0f}, /*白*/
    {1.0f, 0.9, 0.4f, 1.0f}, /*黄*/
    {0.64f, 0.9f, 0.9f, 1.0f}, /*青*/
    {0.95, 0.7f, 0.87f, 1.0f}, /*赤*/
    {0.65f, 1.0f, 0.65f, 1.0f}, /*緑*/
};

static const int kProbabilityKompeitos[] =
{
    40,
    15,
    15,
    15,
    15,
};

static int random_kompeito_selection()
{
    int r = rand() % 100;
    int count = 0;
    for(int i = 0 ; i < (sizeof(kKompeitoColorValues) / sizeof(kKompeitoColorValues[0])) ; ++i)
    {
        count += kProbabilityKompeitos[i];
        if(count > r)
        {
            return i;
        }
    }
    
    NSCAssert(1, @"");
    return INT_MIN;
}

static const int kMaxKompeito = 100;

#endif

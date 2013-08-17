//
//  KompeitoConstants.h
//  CrystalSuger
//
//  Created by ushiostarfish on 2013/08/14.
//  Copyright (c) 2013年 Ushio. All rights reserved.
//

#ifndef CrystalSuger_KompeitoConstants_h
#define CrystalSuger_KompeitoConstants_h

//enum USKKompeitoColor
//{
//    USK_KOMPEITO_COLOR_YELLO = 0,
//    USK_KOMPEITO_COLOR_WHITE,
//    USK_KOMPEITO_COLOR_BLUE,
//};

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

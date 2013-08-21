/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class USKKompeito, USKRoot;

@interface USKPage : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSSet *kompeitos;
@property (nonatomic, retain) USKRoot *root;
@end

@interface USKPage (CoreDataGeneratedAccessors)

- (void)addKompeitosObject:(USKKompeito *)value;
- (void)removeKompeitosObject:(USKKompeito *)value;
- (void)addKompeitos:(NSSet *)values;
- (void)removeKompeitos:(NSSet *)values;

@end

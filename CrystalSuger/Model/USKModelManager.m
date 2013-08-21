/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


#import "USKModelManager.h"

#import "NSManagedObject+Helper.h"

static NSString *const kSchema = @"USKModel";

static NSString *document_path()
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
static NSURL *storage_url()
{
    NSString *documentPath = document_path();
    NSString *storageName = [documentPath stringByAppendingPathComponent:@"usk.sqlite"];
    return [NSURL fileURLWithPath:storageName];
}
static BOOL isExistDatabase()
{
    return [[NSFileManager defaultManager] fileExistsAtPath:storage_url().path];
}

@interface USKModelManager()
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) USKRoot *root;
@end

@implementation USKModelManager
{
    NSManagedObjectModel *_model;
    NSPersistentStoreCoordinator *_storage;
}

- (id)init
{
    if(self = [super init])
    {
//        [self deleteDatabase];
        BOOL isExist = isExistDatabase();
        [self openDatabase];
        
        if(!isExist)
        {
            _root = [USKRoot createInstanceWithContext:_context];
            
            USKPage *newPage = [USKPage createInstanceWithContext:_context];
            newPage.order = @0;
            [_root addPagesObject:newPage];
            [self save];
        }
        else
        {
            NSArray *objects = [USKRoot fetchWithContext:_context predicate:nil];
            if(objects.count == 0)
            {
                _root = [USKRoot createInstanceWithContext:_context];
            }
            else if(objects.count == 1)
            {
                _root = objects.lastObject;
            }
            else
            {
                NSAssert(0, @"multiple");
            }
        }
    }
    return self;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if(_model == nil)
    {
        NSURL *modelurl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:kSchema ofType:@"momd"]];
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelurl];
    }
    return _model;
}
- (void)openDatabase
{
    _storage = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSURL *storageUrl = storage_url();
    
    __autoreleasing NSError *error;
    [_storage addPersistentStoreWithType:NSSQLiteStoreType
                           configuration:nil
                                     URL:storageUrl options:nil error:&error];
    
    NSAssert(error == nil, @"can't open database file.");
    
    _context = [[NSManagedObjectContext alloc] init];
    _context.persistentStoreCoordinator = _storage;
}
- (void)deleteDatabase
{
    /*データベース本体*/
    __autoreleasing NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:storage_url().path error:&error];
}
- (void)save
{
    NSError *error;
    [_context save:&error];
    NSAssert(error == nil, error.description);
}
@end

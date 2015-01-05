/**
 *  Copyright (C) 2010-2014 The Catrobat Team
 *  (http://developer.catrobat.org/credits)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  An additional term exception under section 7 of the GNU Affero
 *  General Public License, version 3, is available at
 *  (http://developer.catrobat.org/license_additional_term)
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

#import "XMLSerializerAbstractTest.h"
#import "GDataXMLElement+CustomExtensions.h"
#import "CBXMLSerializer.h"

@implementation XMLSerializerAbstractTest

// TODO: use and implement this
- (BOOL)isXMLElement:(GDataXMLElement*)xmlElement equalToXMLElementForXPath:(NSString*)xPath inProgramForXML:(NSString*)program
{
    GDataXMLDocument *document = [self getXMLDocumentForPath:[self getPathForXML:program]];
    GDataXMLElement *xml = [document rootElement];
    
    NSArray *array = [xml nodesForXPath:xPath error:nil];
    XCTAssertEqual([array count], 1);
    
    GDataXMLElement *xmlElementFromFile = [array objectAtIndex:0];
    return [xmlElement isEqualToElement:xmlElementFromFile];
}

- (void)saveProgram:(Program*)program
{
    // TODO: find correct serializer class dynamically
    NSString *xmlPath = [NSString stringWithFormat:@"%@%@", [program projectPath], kProgramCodeFileName];
    id<CBSerializerProtocol> serializer = [[CBXMLSerializer alloc] initWithPath:xmlPath];
    [serializer serializeProgram:program];
}

@end

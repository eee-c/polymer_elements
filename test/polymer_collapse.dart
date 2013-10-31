// Copyright (c) 2013, the polymer_elements.dart project authors.  Please see 
// the AUTHORS file for details. All rights reserved. Use of this source code is 
// governed by a BSD-style license that can be found in the LICENSE file.
// This work is a port of the polymer-elements from the Polymer project, 
// http://www.polymer-project.org/. 


library polymer_collapse;

import "dart:html";
import "dart:async";
import "package:unittest/unittest.dart";
import "package:unittest/html_enhanced_config.dart";
import "package:polymer_elements/polymer_collapse/polymer_collapse.dart";

/**
 * Sanitizer which does nothing.
 */
class NullTreeSanitizer implements NodeTreeSanitizer {
  void sanitizeTree(Node node) {}
}

void main() { 
  //return;
  useHtmlEnhancedConfiguration();

  test("polymer-collapse", () {
    Duration delay = new Duration(milliseconds: 300);
    var done = expectAsync0((){});
    Timer.run(() {
      var c = document.querySelector('#collapse') as PolymerCollapse;
      expect(c.closed, isFalse);
      new Future.delayed(delay, () {
        var origH = getBoxComputedHeight();
        expect(origH, isNot(equals(0)));
        c.closed = true;
        new Future.delayed(delay, () {
          // after closed, height is 0
          expect(getBoxComputedHeight(), equals(0));
          // should be set to display: none
          expect(getBoxComputedStyle().display, equals('none'));
          c.closed = false;
          new Future.delayed(delay, () {
            // verify computed height
            expect(getBoxComputedHeight(), equals(origH));
            // after opened, height is set to 'auto'
            expect(document.querySelector('#box').style.height, equals('auto'));
            done();
          });
        });
      });
    });
  });
}

  
dynamic getBoxComputedStyle() {
  HtmlElement b = document.querySelector('#box');
  return b.getComputedStyle();
}

int getBoxComputedHeight() {
  String h = getBoxComputedStyle().height;
  String digits = new RegExp(r"^(\d+).*$").firstMatch(h).group(1);
  return int.parse(digits);
}

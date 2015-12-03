## 0.4.2 - Improve load time
* Improve load time by requiring dependencies on package activation

## 0.4.1 - Explicit consumedServices in package.json
* If you are having problems with 0.4.0 please update to this one.

## 0.4.0 - Adhere to the Services API for consuming the status-bar
* The plugin changed the way it relates with the `status-bar`, now it consumes the newly introduced status-bar API via the Atom [Services](http://blog.atom.io/2015/03/25/new-services-API.html) spec.
* The plugin is no longer compatible with Atom < 1.1.0
* Should solve the problem some users are having with the status-bar `appendLeft` error.

## 0.3.1 - Add the status-bar as formal dependency
* The status-bar will be installed if not present before the package activates.
* If the status bar isn't enabled the package won't show.

## 0.3.0 - New feature arrival - Additional info on click
* Implements a popup that appears when clicking the `filesize` component.
* The popup contains additional information about the file opened in the editor.
* `filesize` now shows when opening images as well.

## 0.2.0 - Updates the package to conform with Atom API 1.0+
* Fix the code implementing the new API and getting rid of deprecation alerts;
* Fix the testes as well

## 0.1.1 - Minor bug fix
* Fix a problem that occurred when you opened a 0 byte file.

## 0.1.0 - First Release
* Atom package that displays the current file's size on the status bar

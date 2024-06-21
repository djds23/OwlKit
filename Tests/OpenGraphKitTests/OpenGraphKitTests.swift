import XCTest
@testable import OpenGraphKit

final class OpenGraphKitTests: XCTestCase {
    func testExample() throws {
        let output = Parser().parse(document: testData)
        print(output)
    }
}

let testData = """
<!doctype html>
<html class="no-js" lang="">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title></title>
  <link rel="stylesheet" href="css/style.css">
  <meta name="description" content="">

  <meta property ="og:title" content="Foo">
  <meta property="og:type" content="website">
  <meta property="og:url" content="fart.biz/whatup">
  <meta property="og:image" content="lol.png">
  <meta property="og:image:alt" content="dang">

  <link rel="icon" href="/favicon.ico" sizes="any">
  <link rel="icon" href="/icon.svg" type="image/svg+xml">
  <link rel="apple-touch-icon" href="icon.png">

  <link rel="manifest" href="site.webmanifest">
  <meta name="theme-color" content="#fafafa">
</head>

<body>

  <!-- Add your site or application content here -->
  <p>Hello world! This is HTML5 Boilerplate.</p>
  <script src="js/app.js"></script>

</body>

</html>
""".data(using: .utf8)

import XCTest
@testable import Maccy

class SearchTests: XCTestCase {
  let savedFuzzySearch = UserDefaults.standard.fuzzySearch
  var items: Search.Searchable!

  override func setUp() {
    CoreDataManager.inMemory = true
    super.setUp()
    items = [
      Menu.IndexedItem(value: "foo bar baz", item: nil, menuItems: []),
      Menu.IndexedItem(value: "foo bar zaz", item: nil, menuItems: []),
      Menu.IndexedItem(value: "xxx yyy zzz", item: nil, menuItems: [])
    ]
  }

  override func tearDown() {
    super.tearDown()
    CoreDataManager.inMemory = false
    UserDefaults.standard.fuzzySearch = savedFuzzySearch
  }

  func testSimpleSearch() {
    UserDefaults.standard.fuzzySearch = false

    XCTAssertEqual(search(""), items)
    XCTAssertEqual(search("z"), items)
    XCTAssertEqual(search("foo"), [items[0], items[1]])
    XCTAssertEqual(search("za"), [items[1]])
    XCTAssertEqual(search("yyy"), [items[2]])
    XCTAssertEqual(search("fbb"), [])
    XCTAssertEqual(search("m"), [])
  }

  func testFuzzySearch() {
    UserDefaults.standard.fuzzySearch = true

    XCTAssertEqual(search(""), items)
    XCTAssertEqual(search("z"), [items[1], items[2], items[0]])
    XCTAssertEqual(search("foo"), [items[0], items[1]])
    XCTAssertEqual(search("za"), [items[1], items[0], items[2]])
    XCTAssertEqual(search("yyy"), [items[2]])
    XCTAssertEqual(search("fbb"), [items[0], items[1]])
    XCTAssertEqual(search("m"), [])
  }

  private func search(_ string: String) -> Search.Searchable {
    return Search().search(string: string, within: items)
  }
}

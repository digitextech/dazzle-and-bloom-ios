
import Foundation

// MARK: - AllProducts
struct AllProducts: Codable {
    var code: Int?
    var message: [Message]?
}

// MARK: - Message
struct Message: Codable {
    var id: Int?
    var postAuthor, postDate, postDateGmt, postContent: String?
    var postTitle, postExcerpt: String?
    var postStatus: MessagePostStatus?
    var commentStatus: CommentStatus?
    var pingStatus: PingStatus?
    var postPassword, postName, toPing, pinged: String?
    var postModified, postModifiedGmt, postContentFiltered: String?
    var postParent: Int?
    var guid: String?
    var menuOrder: Int?
    var postType: MessagePostType?
    var postMIMEType, commentCount: String?
    var filter: Filter?
    var expirationDate, orderDate: String?
    var status: Status?
    var listingCreated, contactEmail: String?
    var categories, locations, tags: [Category]?
    var featured: Int?
    var package: Package?
    var fields: [String: Field]?
    var images: [String: Image]?
    var logoImage: Int?
    var videos: String?

    enum CodingKeys: String, CodingKey {
        case id
        case postAuthor
        case postDate
        case postDateGmt
        case postContent
        case postTitle
        case postExcerpt
        case postStatus
        case commentStatus
        case pingStatus
        case postPassword
        case postName
        case toPing
        case pinged
        case postModified
        case postModifiedGmt
        case postContentFiltered
        case postParent
        case guid
        case menuOrder
        case postType
        case postMIMEType
        case commentCount
        case filter
        case expirationDate
        case orderDate
        case status
        case listingCreated
        case contactEmail
        case categories, locations, tags, featured, package, fields, images
        case logoImage
        case videos
    }
}

// MARK: - Category
struct Category: Codable {
    var termID: Int?
    var name, slug: String?
    var termGroup, termTaxonomyID: Int?
    var taxonomy: Taxonomy?
    var categoryDescription: Description?
    var parent, count: Int?
    var filter: Filter?
    var termOrder: String?

    enum CodingKeys: String, CodingKey {
        case termID
        case name, slug
        case termGroup
        case termTaxonomyID
        case taxonomy
        case categoryDescription
        case parent, count, filter
        case termOrder
    }
}

enum Description: String, Codable {
    case empty = ""
    case kids = "Kids"
    case men = "Men"
    case women = "Women"
}

enum Filter: String, Codable {
    case raw = "raw"
}

enum Taxonomy: String, Codable {
    case directorypressCategory = "directorypress-category"
    case directorypressLocation = "directorypress-location"
    case directorypressTag = "directorypress-tag"
}

enum CommentStatus: String, Codable {
    case commentStatusOpen = "open"
}

// MARK: - Field
struct Field: Codable {
    var id, isCoreField, orderNum: String?
    var name: FieldName?
    var slug: Slug?
    var fieldDescription, fieldwidth, fieldwidthArchive: String?
    var type: TypeEnum?
    var iconImage: IconImage?
    var isRequired, isOrdered, isHideName, isFieldInLine: String?
    var isHideNameOnGrid, isHideNameOnList: IsHideNameOn?
    var isHideNameOnSearch, onExerptPage, onExerptPageList, onListingPage: String?
    var onMap: String?
    var categories: [JSONAny]?
    var options: OptionsUnion?
    var searchOptions: SearchOptionsUnion?
    var groupID: String?
    var value: String?
    var onSearchForm: String?
    var onSearchFormArchive, onSearchFormWidget: Bool?
    var advancedSearchForm: String?
    var maxLength: MaxLength?
    var regex: String?
    var isPhone: Int?
    var isMultiselect: Int?
    var currencySymbol: CurrencySymbol?
    var decimalSeparator: DecimalSeparator?
    var thousandsSeparator, symbolPosition, hideDecimals: String?
    var hasInputOptions, hasFrontendCurrency: Int?
    var priceFieldType: String?
    var rangeOptions: [CurrencySymbol]?
    var data: DataClass?
    var selectionItems: SelectionItems?
    var htmlEditor, doShortcodes: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case isCoreField
        case orderNum
        case name, slug
        case fieldDescription
        case fieldwidth
        case fieldwidthArchive
        case type
        case iconImage
        case isRequired
        case isOrdered
        case isHideName
        case isFieldInLine
        case isHideNameOnGrid
        case isHideNameOnList
        case isHideNameOnSearch
        case onExerptPage
        case onExerptPageList
        case onListingPage
        case onMap
        case categories, options
        case searchOptions
        case groupID
        case value
        case onSearchForm
        case onSearchFormArchive
        case onSearchFormWidget
        case advancedSearchForm
        case maxLength
        case regex
        case isPhone
        case isMultiselect
        case currencySymbol
        case decimalSeparator
        case thousandsSeparator
        case symbolPosition
        case hideDecimals
        case hasInputOptions
        case hasFrontendCurrency
        case priceFieldType
        case rangeOptions
        case data
        case selectionItems
        case htmlEditor
        case doShortcodes
    }
}

enum CurrencySymbol: String, Codable {
    case currencySymbol = "££"
    case empty = "£"
    case purple = "£££"
}

// MARK: - DataClass
struct DataClass: Codable {
    var value, value2, rangeOptions, optionSelection: String?
    var frontendCurrency: String?

    enum CodingKeys: String, CodingKey {
        case value
        case value2
        case rangeOptions
        case optionSelection
        case frontendCurrency
    }
}

enum DecimalSeparator: String, Codable {
    case empty = "."
}

enum IconImage: String, Codable {
    case alspFaEnvelopeO = "alsp-fa-envelope-o"
    case alspFaMapMarker = "alsp-fa-map-marker"
    case empty = ""
}

enum IsHideNameOn: String, Codable {
    case hide = "hide"
    case showIconLabel = "show_icon_label"
    case showOnlyLabel = "show_only_label"
}

enum MaxLength: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(MaxLength.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MaxLength"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

enum FieldName: String, Codable {
    case address = "Address"
    case categories = "categories"
    case email = "Email"
    case featuresList = "Features List"
    case listingTags = "Listing Tags"
    case listingType = "Listing Type"
    case nameDescription = "Description"
    case phone = "Phone"
    case price = "Price"
    case summary = "Summary"
    case website = "Website"
    case whatsappNumber = "Whatsapp Number"
}

enum OptionsUnion: Codable {
    case optionsClass(OptionsClass)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(OptionsClass.self) {
            self = .optionsClass(x)
            return
        }
        throw DecodingError.typeMismatch(OptionsUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for OptionsUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .optionsClass(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - OptionsClass
struct OptionsClass: Codable {
    var isMultiselect: Int?
    var currencySymbol: CurrencySymbol?
    var decimalSeparator: DecimalSeparator?
    var thousandsSeparator, symbolPosition, hideDecimals: String?
    var hasInputOptions, hasFrontendCurrency: Int?
    var priceFieldType: String?
    var rangeOptions: [CurrencySymbol]?
    var maxLength, regex: String?
    var isPhone: Int?
    var selectionItems: SelectionItems?
    var htmlEditor, doShortcodes: Int?

    enum CodingKeys: String, CodingKey {
        case isMultiselect
        case currencySymbol
        case decimalSeparator
        case thousandsSeparator
        case symbolPosition
        case hideDecimals
        case hasInputOptions
        case hasFrontendCurrency
        case priceFieldType
        case rangeOptions
        case maxLength
        case regex
        case isPhone
        case selectionItems
        case htmlEditor
        case doShortcodes
    }
}

// MARK: - SelectionItems
struct SelectionItems: Codable {
    var the1: The1?

    enum CodingKeys: String, CodingKey {
        case the1
    }
}

enum The1: String, Codable {
    case sell = "Sell"
}

enum SearchOptionsUnion: Codable {
    case searchOptionsClass(SearchOptionsClass)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(SearchOptionsClass.self) {
            self = .searchOptionsClass(x)
            return
        }
        throw DecodingError.typeMismatch(SearchOptionsUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for SearchOptionsUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .searchOptionsClass(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - SearchOptionsClass
struct SearchOptionsClass: Codable {
    var mode: Mode?
    var minMaxOptions: [String]?
    var sliderStep1_Min, sliderStep1_Max: String?

    enum CodingKeys: String, CodingKey {
        case mode
        case minMaxOptions
        case sliderStep1_Min
        case sliderStep1_Max
    }
}

enum Mode: String, Codable {
    case range = "range"
}

enum Slug: String, Codable {
    case address = "address"
    case categoriesList = "categories_list"
    case content = "content"
    case email = "email"
    case featuresList = "features-list"
    case listingTags = "listing_tags"
    case listingType = "listing-type"
    case phone = "phone"
    case price = "price"
    case summary = "summary"
    case website = "website"
    case whatsappNumber = "Whatsapp-number"
}

enum TypeEnum: String, Codable {
    case address = "address"
    case categories = "categories"
    case content = "content"
    case email = "email"
    case price = "price"
    case select = "select"
    case summary = "summary"
    case tags = "tags"
    case text = "text"
    case textarea = "textarea"
}

// MARK: - Image
struct Image: Codable {
    var id: Int?
    var postAuthor, postDate, postDateGmt, postContent: String?
    var postTitle, postExcerpt: String?
    var postStatus: ImagePostStatus?
    var commentStatus: CommentStatus?
    var pingStatus: PingStatus?
    var postPassword, postName, toPing, pinged: String?
    var postModified, postModifiedGmt, postContentFiltered: String?
    var postParent: Int?
    var guid: String?
    var menuOrder: Int?
    var postType: ImagePostType?
    var postMIMEType: PostMIMEType?
    var commentCount: String?
    var filter: Filter?
    var ancestors: [Int]?
    var pageTemplate: String?
    var postCategory, tagsInput: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case id
        case postAuthor
        case postDate
        case postDateGmt
        case postContent
        case postTitle
        case postExcerpt
        case postStatus
        case commentStatus
        case pingStatus
        case postPassword
        case postName
        case toPing
        case pinged
        case postModified
        case postModifiedGmt
        case postContentFiltered
        case postParent
        case guid
        case menuOrder
        case postType
        case postMIMEType
        case commentCount
        case filter, ancestors
        case pageTemplate
        case postCategory
        case tagsInput
    }
}

enum PingStatus: String, Codable {
    case closed = "closed"
}

enum PostMIMEType: String, Codable {
    case imageJPEG = "image/jpeg"
}

enum ImagePostStatus: String, Codable {
    case inherit = "inherit"
}

enum ImagePostType: String, Codable {
    case attachment = "attachment"
}

// MARK: - Package
struct Package: Codable {
    var id, orderNum: String?
    var name: PackageName?
    var packageDescription, packageDuration, packageDurationUnit, packageNoExpiry: String?
    var numberOfListingsInPackage, changePackageID, hasFeatured, canBeBumpup: String?
    var hasSticky, categoryNumberAllowed, locationNumberAllowed, featuredPackage: String?
    var imagesAllowed, videosAllowed: String?
    var selectedCategories, selectedLocations, fields: [JSONAny]?
    var upgradeMeta: [String: UpgradeMeta]?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNum
        case name
        case packageDescription
        case packageDuration
        case packageDurationUnit
        case packageNoExpiry
        case numberOfListingsInPackage
        case changePackageID
        case hasFeatured
        case canBeBumpup
        case hasSticky
        case categoryNumberAllowed
        case locationNumberAllowed
        case featuredPackage
        case imagesAllowed
        case videosAllowed
        case selectedCategories
        case selectedLocations
        case fields
        case upgradeMeta
    }
}

enum PackageName: String, Codable {
    case freePackage = "Free Package"
}

// MARK: - UpgradeMeta
struct UpgradeMeta: Codable {
    var price: Int?
    var disabled, raiseup: Bool?
}

enum MessagePostStatus: String, Codable {
    case publish = "publish"
}

enum MessagePostType: String, Codable {
    case dpListing = "dp_listing"
}

enum Status: String, Codable {
    case active = "active"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

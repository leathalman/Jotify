import Foundation

@objc
public enum GridiconType: Int {
    case visible
    case videoRemove
    case videoCamera
    case video
    case userCircle
    case userAdd
    case user
    case undo
    case underline
    case types
    case trophy
    case trash
    case time
    case thumbsUp
    case themes
    case textColor
    case tag
    case tablet
    case sync
    case strikethrough
    case status
    case statsAlt
    case stats
    case starOutline
    case star
    case specialCharacter
    case speaker
    case spam
    case signOut
    case shipping
    case shareIOS
    case share
    case search
    case scheduled
    case rotate
    case resize
    case reply
    case refund
    case refresh
    case redo
    case reblog
    case readerFollowing
    case readerFollow
    case reader
    case readMore
    case quote
    case productVirtual
    case productExternal
    case productDownloadable
    case product
    case print
    case posts
    case popout
    case plusSmall
    case plus
    case plugins
    case play
    case plans
    case pin
    case phone
    case pencil
    case pause
    case pages
    case offline
    case noticeOutline
    case notice
    case notVisible
    case nextPage
    case mySitesHorizon
    case mySites
    case multipleUsers
    case money
    case minusSmall
    case minus
    case microphone
    case menus
    case menu
    case mention
    case mail
    case lock
    case location
    case listUnordered
    case listOrdered
    case listOrderedRTL
    case listCheckmark
    case linkBreak
    case link
    case layoutBlocks
    case layout
    case italic
    case institution
    case ink
    case infoOutline
    case info
    case indentRight
    case indentLeft
    case imageRemove
    case imageMultiple
    case image
    case house
    case history
    case helpOutline
    case help
    case heartOutline
    case heart
    case headingH6
    case headingH5
    case headingH4
    case headingH3
    case headingH2
    case headingH1
    case heading
    case grid
    case globe
    case fullscreenExit
    case fullscreen
    case folderMultiple
    case folder
    case flipVertical
    case flipHorizontal
    case flag
    case filter
    case external
    case ellipsisCircle
    case ellipsis
    case dropdown
    case domains
    case customize
    case customPostType
    case crossSmall
    case crossCircle
    case cross
    case crop
    case creditCard
    case create
    case coupon
    case computer
    case comment
    case cog
    case code
    case cloudUpload
    case cloudOutline
    case cloudDownload
    case cloud
    case clipboard
    case clearFormatting
    case chevronUp
    case chevronRight
    case chevronLeft
    case chevronDown
    case checkmarkCircle
    case checkmark
    case chat
    case cart
    case caption
    case camera
    case calendar
    case bug
    case briefcase
    case bookmarkOutline
    case bookmark
    case book
    case bold
    case block
    case bell
    case audio
    case attachment
    case aside
    case arrowUp
    case arrowRight
    case arrowLeft
    case arrowDown
    case alignRight
    case alignLeft
    case alignJustify
    case alignImageRight
    case alignImageNone
    case alignImageLeft
    case alignImageCenter
    case alignCenter
    case addOutline
    case addImage
    case add
}

public final class Gridicon: NSObject {
    public static let defaultSize = CGSize(width: 24.0, height: 24.0)

    fileprivate static let cache = NSCache<AnyObject, AnyObject>()
    static func clearCache() {
        cache.removeAllObjects()
    }
    
    /// - returns: A template image of the specified Gridicon type, at the default size.
    @objc
    public static func iconOfType(_ type: GridiconType) -> UIImage {
        return iconOfType(type, withSize: defaultSize)
    }
    
    // These are two separate methods (rather than one method with a default argument) because Obj-C
    
    /// - returns: A template image of the specified Gridicon type, at the specified size.
    @objc
    public static func iconOfType(_ type: GridiconType, withSize size: CGSize) -> UIImage {
        if let icon = cachedIconOfType(type, withSize: size) {
            return icon
        }
        
        let icon = generateIconOfType(type, withSize: size).withRenderingMode(.alwaysTemplate)
        cache.setObject(icon, forKey: "\(type.rawValue)-\(size.width)-\(size.height)" as AnyObject)
        
        return icon
    }
    
    fileprivate static func cachedIconOfType(_ type: GridiconType, withSize size: CGSize) -> UIImage? {
        return cache.object(forKey: "\(type.rawValue)-\(size.width)-\(size.height)" as AnyObject) as? UIImage
    }
    
    fileprivate static func generateIconOfType(_ type: GridiconType, withSize size: CGSize) -> UIImage {
        switch type {
        case .visible:
            return GridiconsGenerated.imageOfGridiconsvisible(size: size)
        case .video:
            return GridiconsGenerated.imageOfGridiconsvideo(size: size)
        case .videoCamera:
            return GridiconsGenerated.imageOfGridiconsvideocamera(size: size)
        case .videoRemove:
            return GridiconsGenerated.imageOfGridiconsvideoremove(size: size)
        case .user:
            return GridiconsGenerated.imageOfGridiconsuser(size: size)
        case .userAdd:
            return GridiconsGenerated.imageOfGridiconsuseradd(size: size)
        case .userCircle:
            return GridiconsGenerated.imageOfGridiconsusercircle(size: size)
        case .undo:
            return GridiconsGenerated.imageOfGridiconsundo(size: size)
        case .underline:
            return GridiconsGenerated.imageOfGridiconsunderline(size: size)
        case .types:
            return GridiconsGenerated.imageOfGridiconstypes(size: size)
        case .trophy:
            return GridiconsGenerated.imageOfGridiconstrophy(size: size)
        case .trash:
            return GridiconsGenerated.imageOfGridiconstrash(size: size)
        case .time:
            return GridiconsGenerated.imageOfGridiconstime(size: size)
        case .thumbsUp:
            return GridiconsGenerated.imageOfGridiconsthumbsup(size: size)
        case .themes:
            return GridiconsGenerated.imageOfGridiconsthemes(size: size)
        case .textColor:
            return GridiconsGenerated.imageOfGridiconstextcolor(size: size)
        case .tag:
            return GridiconsGenerated.imageOfGridiconstag(size: size)
        case .tablet:
            return GridiconsGenerated.imageOfGridiconstablet(size: size)
        case .sync:
            return GridiconsGenerated.imageOfGridiconssync(size: size)
        case .strikethrough:
            return GridiconsGenerated.imageOfGridiconsstrikethrough(size: size)
        case .status:
            return GridiconsGenerated.imageOfGridiconsstatus(size: size)
        case .stats:
            return GridiconsGenerated.imageOfGridiconsstats(size: size)
        case .statsAlt:
            return GridiconsGenerated.imageOfGridiconsstatsalt(size: size)
        case .star:
            return GridiconsGenerated.imageOfGridiconsstar(size: size)
        case .starOutline:
            return GridiconsGenerated.imageOfGridiconsstaroutline(size: size)
        case .specialCharacter:
            return GridiconsGenerated.imageOfGridiconsspecialcharacter(size: size)
        case .speaker:
            return GridiconsGenerated.imageOfGridiconsspeaker(size: size)
        case .spam:
            return GridiconsGenerated.imageOfGridiconsspam(size: size)
        case .signOut:
            return GridiconsGenerated.imageOfGridiconssignout(size: size)
        case .shipping:
            return GridiconsGenerated.imageOfGridiconsshipping(size: size)
        case .share:
            return GridiconsGenerated.imageOfGridiconsshare(size: size)
        case .shareIOS:
            return GridiconsGenerated.imageOfGridiconsshareios(size: size)
        case .search:
            return GridiconsGenerated.imageOfGridiconssearch(size: size)
        case .scheduled:
            return GridiconsGenerated.imageOfGridiconsscheduled(size: size)
        case .rotate:
            return GridiconsGenerated.imageOfGridiconsrotate(size: size)
        case .resize:
            return GridiconsGenerated.imageOfGridiconsresize(size: size)
        case .reply:
            return GridiconsGenerated.imageOfGridiconsreply(size: size)
        case .refund:
            return GridiconsGenerated.imageOfGridiconsrefund(size: size)
        case .refresh:
            return GridiconsGenerated.imageOfGridiconsrefresh(size: size)
        case .redo:
            return GridiconsGenerated.imageOfGridiconsredo(size: size)
        case .reblog:
            return GridiconsGenerated.imageOfGridiconsreblog(size: size)
        case .readMore:
            return GridiconsGenerated.imageOfGridiconsreadmore(size: size)
        case .readerFollowing:
            return GridiconsGenerated.imageOfGridiconsreaderfollowing(size: size)
        case .readerFollow:
            return GridiconsGenerated.imageOfGridiconsreaderfollow(size: size)
        case .reader:
            return GridiconsGenerated.imageOfGridiconsreader(size: size)
        case .quote:
            return GridiconsGenerated.imageOfGridiconsquote(size: size)
        case .print:
            return GridiconsGenerated.imageOfGridiconsprint(size: size)
        case .product:
            return GridiconsGenerated.imageOfGridiconsproduct(size: size)
        case .productDownloadable:
            return GridiconsGenerated.imageOfGridiconsproductdownloadable(size: size)
        case .productExternal:
            return GridiconsGenerated.imageOfGridiconsproductexternal(size: size)
        case .productVirtual:
            return GridiconsGenerated.imageOfGridiconsproductvirtual(size: size)
        case .posts:
            return GridiconsGenerated.imageOfGridiconsposts(size: size)
        case .popout:
            return GridiconsGenerated.imageOfGridiconspopout(size: size)
        case .plus:
            return GridiconsGenerated.imageOfGridiconsplus(size: size)
        case .plusSmall:
            return GridiconsGenerated.imageOfGridiconsplussmall(size: size)
        case .plugins:
            return GridiconsGenerated.imageOfGridiconsplugins(size: size)
        case .play:
            return GridiconsGenerated.imageOfGridiconsplay(size: size)
        case .plans:
            return GridiconsGenerated.imageOfGridiconsplans(size: size)
        case .pin:
            return GridiconsGenerated.imageOfGridiconspin(size: size)
        case .phone:
            return GridiconsGenerated.imageOfGridiconsphone(size: size)
        case .pencil:
            return GridiconsGenerated.imageOfGridiconspencil(size: size)
        case .pause:
            return GridiconsGenerated.imageOfGridiconspause(size: size)
        case .pages:
            return GridiconsGenerated.imageOfGridiconspages(size: size)
        case .offline:
            return GridiconsGenerated.imageOfGridiconsoffline(size: size)
        case .notice:
            return GridiconsGenerated.imageOfGridiconsnotice(size: size)
        case .noticeOutline:
            return GridiconsGenerated.imageOfGridiconsnoticeoutline(size: size)
        case .notVisible:
            return GridiconsGenerated.imageOfGridiconsnotvisible(size: size)
        case .nextPage:
            return GridiconsGenerated.imageOfGridiconsnextpage(size: size)
        case .mySites:
            return GridiconsGenerated.imageOfGridiconsmysites(size: size)
        case .mySitesHorizon:
            return GridiconsGenerated.imageOfGridiconsmysiteshorizon(size: size)
        case .multipleUsers:
            return GridiconsGenerated.imageOfGridiconsmultipleusers(size: size)
        case .money:
            return GridiconsGenerated.imageOfGridiconsmoney(size: size)
        case .minus:
            return GridiconsGenerated.imageOfGridiconsminus(size: size)
        case .minusSmall:
            return GridiconsGenerated.imageOfGridiconsminussmall(size: size)
        case .microphone:
            return GridiconsGenerated.imageOfGridiconsmicrophone(size: size)
        case .menus:
            return GridiconsGenerated.imageOfGridiconsmenus(size: size)
        case .menu:
            return GridiconsGenerated.imageOfGridiconsmenu(size: size)
        case .mention:
            return GridiconsGenerated.imageOfGridiconsmention(size: size)
        case .mail:
            return GridiconsGenerated.imageOfGridiconsmail(size: size)
        case .lock:
            return GridiconsGenerated.imageOfGridiconslock(size: size)
        case .location:
            return GridiconsGenerated.imageOfGridiconslocation(size: size)
        case .listUnordered:
            return GridiconsGenerated.imageOfGridiconslistunordered(size: size)
        case .listOrdered:
            return GridiconsGenerated.imageOfGridiconslistordered(size: size)
        case .listOrderedRTL:
            return GridiconsGenerated.imageOfGridiconslistorderedrtl(size: size)
        case .listCheckmark:
            return GridiconsGenerated.imageOfGridiconslistcheckmark(size: size)
        case .link:
            return GridiconsGenerated.imageOfGridiconslink(size: size)
        case .linkBreak:
            return GridiconsGenerated.imageOfGridiconslinkbreak(size: size)
        case .layout:
            return GridiconsGenerated.imageOfGridiconslayout(size: size)
        case .layoutBlocks:
            return GridiconsGenerated.imageOfGridiconslayoutblocks(size: size)
        case .italic:
            return GridiconsGenerated.imageOfGridiconsitalic(size: size)
        case .institution:
            return GridiconsGenerated.imageOfGridiconsinstitution(size: size)
        case .ink:
            return GridiconsGenerated.imageOfGridiconsink(size: size)
        case .info:
            return GridiconsGenerated.imageOfGridiconsinfo(size: size)
        case .infoOutline:
            return GridiconsGenerated.imageOfGridiconsinfooutline(size: size)
        case .indentRight:
            return GridiconsGenerated.imageOfGridiconsindentright(size: size)
        case .indentLeft:
            return GridiconsGenerated.imageOfGridiconsindentleft(size: size)
        case .image:
            return GridiconsGenerated.imageOfGridiconsimage(size: size)
        case .imageMultiple:
            return GridiconsGenerated.imageOfGridiconsimagemultiple(size: size)
        case .imageRemove:
            return GridiconsGenerated.imageOfGridiconsimageremove(size: size)
        case .house:
            return GridiconsGenerated.imageOfGridiconshouse(size: size)
        case .history:
            return GridiconsGenerated.imageOfGridiconshistory(size: size)
        case .help:
            return GridiconsGenerated.imageOfGridiconshelp(size: size)
        case .helpOutline:
            return GridiconsGenerated.imageOfGridiconshelpoutline(size: size)
        case .heart:
            return GridiconsGenerated.imageOfGridiconsheart(size: size)
        case .heartOutline:
            return GridiconsGenerated.imageOfGridiconsheartoutline(size: size)
        case .headingH6:
            return GridiconsGenerated.imageOfGridiconsheadingH6(size: size)
        case .headingH5:
            return GridiconsGenerated.imageOfGridiconsheadingH5(size: size)
        case .headingH4:
            return GridiconsGenerated.imageOfGridiconsheadingH4(size: size)
        case .headingH3:
            return GridiconsGenerated.imageOfGridiconsheadingH3(size: size)
        case .headingH2:
            return GridiconsGenerated.imageOfGridiconsheadingH2(size: size)
        case .headingH1:
            return GridiconsGenerated.imageOfGridiconsheadingH1(size: size)
        case .heading:
            return GridiconsGenerated.imageOfGridiconsheading(size: size)
        case .grid:
            return GridiconsGenerated.imageOfGridiconsgrid(size: size)
        case .globe:
            return GridiconsGenerated.imageOfGridiconsglobe(size: size)
        case .fullscreen:
            return GridiconsGenerated.imageOfGridiconsfullscreen(size: size)
        case .fullscreenExit:
            return GridiconsGenerated.imageOfGridiconsfullscreenexit(size: size)
        case .folder:
            return GridiconsGenerated.imageOfGridiconsfolder(size: size)
        case .folderMultiple:
            return GridiconsGenerated.imageOfGridiconsfoldermultiple(size: size)
        case .flipVertical:
            return GridiconsGenerated.imageOfGridiconsflipvertical(size: size)
        case .flipHorizontal:
            return GridiconsGenerated.imageOfGridiconsfliphorizontal(size: size)
        case .flag:
            return GridiconsGenerated.imageOfGridiconsflag(size: size)
        case .filter:
            return GridiconsGenerated.imageOfGridiconsfilter(size: size)
        case .external:
            return GridiconsGenerated.imageOfGridiconsexternal(size: size)
        case .ellipsis:
            return GridiconsGenerated.imageOfGridiconsellipsis(size: size)
        case .ellipsisCircle:
            return GridiconsGenerated.imageOfGridiconsellipsiscircle(size: size)
        case .dropdown:
            return GridiconsGenerated.imageOfGridiconsdropdown(size: size)
        case .domains:
            return GridiconsGenerated.imageOfGridiconsdomains(size: size)
        case .customize:
            return GridiconsGenerated.imageOfGridiconscustomize(size: size)
        case .customPostType:
            return GridiconsGenerated.imageOfGridiconscustomposttype(size: size)
        case .cross:
            return GridiconsGenerated.imageOfGridiconscross(size: size)
        case .crossCircle:
            return GridiconsGenerated.imageOfGridiconscrosscircle(size: size)
        case .crossSmall:
            return GridiconsGenerated.imageOfGridiconscrosssmall(size: size)
        case .crop:
            return GridiconsGenerated.imageOfGridiconscrop(size: size)
        case .creditCard:
            return GridiconsGenerated.imageOfGridiconscreditcard(size: size)
        case .create:
            return GridiconsGenerated.imageOfGridiconscreate(size: size)
        case .coupon:
            return GridiconsGenerated.imageOfGridiconscoupon(size: size)
        case .computer:
            return GridiconsGenerated.imageOfGridiconscomputer(size: size)
        case .comment:
            return GridiconsGenerated.imageOfGridiconscomment(size: size)
        case .cog:
            return GridiconsGenerated.imageOfGridiconscog(size: size)
        case .code:
            return GridiconsGenerated.imageOfGridiconscode(size: size)
        case .cloud:
            return GridiconsGenerated.imageOfGridiconscloud(size: size)
        case .cloudUpload:
            return GridiconsGenerated.imageOfGridiconscloudupload(size: size)
        case .cloudOutline:
            return GridiconsGenerated.imageOfGridiconscloudoutline(size: size)
        case .cloudDownload:
            return GridiconsGenerated.imageOfGridiconsclouddownload(size: size)
        case .clipboard:
            return GridiconsGenerated.imageOfGridiconsclipboard(size: size)
        case .clearFormatting:
            return GridiconsGenerated.imageOfGridiconsclearformatting(size: size)
        case .chevronUp:
            return GridiconsGenerated.imageOfGridiconschevronup(size: size)
        case .chevronRight:
            return GridiconsGenerated.imageOfGridiconschevronright(size: size)
        case .chevronLeft:
            return GridiconsGenerated.imageOfGridiconschevronleft(size: size)
        case .chevronDown:
            return GridiconsGenerated.imageOfGridiconschevrondown(size: size)
        case .checkmark:
            return GridiconsGenerated.imageOfGridiconscheckmark(size: size)
        case .checkmarkCircle:
            return GridiconsGenerated.imageOfGridiconscheckmarkcircle(size: size)
        case .chat:
            return GridiconsGenerated.imageOfGridiconschat(size: size)
        case .cart:
            return GridiconsGenerated.imageOfGridiconscart(size: size)
        case .caption:
            return GridiconsGenerated.imageOfGridiconscaption(size: size)
        case .camera:
            return GridiconsGenerated.imageOfGridiconscamera(size: size)
        case .calendar:
            return GridiconsGenerated.imageOfGridiconscalendar(size: size)
        case .bug:
            return GridiconsGenerated.imageOfGridiconsbug(size: size)
        case .briefcase:
            return GridiconsGenerated.imageOfGridiconsbriefcase(size: size)
        case .bookmark:
            return GridiconsGenerated.imageOfGridiconsbookmark(size: size)
        case .bookmarkOutline:
            return GridiconsGenerated.imageOfGridiconsbookmarkoutline(size: size)
        case .book:
            return GridiconsGenerated.imageOfGridiconsbook(size: size)
        case .bold:
            return GridiconsGenerated.imageOfGridiconsbold(size: size)
        case .block:
            return GridiconsGenerated.imageOfGridiconsblock(size: size)
        case .bell:
            return GridiconsGenerated.imageOfGridiconsbell(size: size)
        case .audio:
            return GridiconsGenerated.imageOfGridiconsaudio(size: size)
        case .attachment:
            return GridiconsGenerated.imageOfGridiconsattachment(size: size)
        case .aside:
            return GridiconsGenerated.imageOfGridiconsaside(size: size)
        case .arrowUp:
            return GridiconsGenerated.imageOfGridiconsarrowup(size: size)
        case .arrowRight:
            return GridiconsGenerated.imageOfGridiconsarrowright(size: size)
        case .arrowLeft:
            return GridiconsGenerated.imageOfGridiconsarrowleft(size: size)
        case .arrowDown:
            return GridiconsGenerated.imageOfGridiconsarrowdown(size: size)
        case .alignRight:
            return GridiconsGenerated.imageOfGridiconsalignright(size: size)
        case .alignLeft:
            return GridiconsGenerated.imageOfGridiconsalignleft(size: size)
        case .alignJustify:
            return GridiconsGenerated.imageOfGridiconsalignjustify(size: size)
        case .alignImageRight:
            return GridiconsGenerated.imageOfGridiconsalignimageright(size: size)
        case .alignImageNone:
            return GridiconsGenerated.imageOfGridiconsalignimagenone(size: size)
        case .alignImageLeft:
            return GridiconsGenerated.imageOfGridiconsalignimageleft(size: size)
        case .alignImageCenter:
            return GridiconsGenerated.imageOfGridiconsalignimagecenter(size: size)
        case .alignCenter:
            return GridiconsGenerated.imageOfGridiconsaligncenter(size: size)
        case .add:
            return GridiconsGenerated.imageOfGridiconsadd(size: size)
        case .addOutline:
            return GridiconsGenerated.imageOfGridiconsaddoutline(size: size)
        case .addImage:
            return GridiconsGenerated.imageOfGridiconsaddimage(size: size)
        }
    }
}

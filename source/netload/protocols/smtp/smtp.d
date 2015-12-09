module netload.protocols.smtp.smtp;
//
//import vibe.data.json;
//import netload.core.protocol;
//
//class SMTP : Protocol {
//  public:
//    this() {
//
//    }
//
//    this(string b) {
//      _body = b;
//    }
//
//    this(Json json) {
//      _body = json.body_.to!string;
//    }
//
//    this(ubyte[] encoded) {
//      this(cast(string)(encoded));
//    }
//
//    override @property inout string name() { return "SMTP"; };
//    override @property Protocol data() { return null; }
//    override @property void data(Protocol p) { }
//    override @property int osiLayer() const { return 7; }
//
//    override Json toJson() const {
//      Json json = Json.emptyObject;
//      json.body_ = _body;
//      json.name = name;
//      return json;
//    }
//
//    unittest {
//      SMTP packet = new SMTP("test");
//      auto json = Json.emptyObject;
//      json.name = "SMTP";
//      json.body_ = "test";
//      assert(packet.toJson == json);
//    }
//
//    override ubyte[] toBytes() const {
//      return cast(ubyte[])(_body.dup);
//    }
//
//    unittest {
//      SMTP packet = new SMTP("test");
//      assert(packet.toBytes == cast(ubyte[])("test"));
//    }
//
//    override string toString() const { return toJson.toPrettyString; }
//
//    @property string str() const { return _body; }
//    @property void str(string b) { _body = b; }
//
//  private:
//    string _body;
//}
//
//unittest {
//  Json json = Json.emptyObject;
//  json.body_ = "test";
//  SMTP packet = cast(SMTP)to!SMTP(json);
//  assert(packet.str == "test");
//}
//
//unittest {
//  ubyte[] encoded = [116, 101, 115, 116];
//  SMTP packet = cast(SMTP)encoded.to!SMTP();
//  assert(packet.str == "test");
//}

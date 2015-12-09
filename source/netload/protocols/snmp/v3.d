module netload.protocols.snmp.v3;
//
//import std.string;
//import std.bitmanip;
//
//import vibe.data.json;
//
//import netload.core.protocol;
//import netload.protocols.snmp.asn_1;
//
//class SNMPv3 : Protocol {
//  public:
//    this() {}
//
//    this(ubyte[] bytes) {
//      auto tmp = bytes.toASN1;
//      auto seq = tmp.data.toASN1Seq;
//      ver = seq[0].data[0];
//
//      auto globalData = seq[1].data.toASN1Seq;
//
//      _identifier = globalData[0].data.readUint;
//      _maxSize = globalData[1].data.readUint;
//      _flags = globalData[2].data[0];
//      _securityModel = globalData[3].data.readUint;
//
//      _securityParameters = seq[2].data.toASN1;
//      _pdu = seq[3];
//    }
//
//    this(Json json) {
//      ver = json.ver.to!int;
//      _identifier = json.identifier.to!uint;
//      _maxSize = json.max_size.to!uint;
//      _flags = json.flags.to!ubyte;
//      _securityModel = json.security_model.to!uint;
//      _securityParameters = deserializeJson!ASN1(json.security_parameters);
//      _pdu = deserializeJson!ASN1(json.pdu);
//      auto packetData = ("data" in json);
//      if (json.data.type != Json.Type.Null && packetData != null)
//        data = netload.protocols.conversion.protocolConversion[deserializeJson!string(packetData.name)](*packetData);
//    }
//
//    override Json toJson() const {
//      auto json = Json.emptyObject;
//      json.ver = this.ver;
//      json.identifier = this.identifier;
//      json.max_size = this.maxSize;
//      json.flags = this.flags;
//      json.security_model = this.securityModel;
//      json.security_parameters = serializeToJson(_securityParameters);
//      json.pdu = serializeToJson(_pdu);
//      json.name = name;
//      return json;
//    }
//
//    unittest {
//      ubyte[] raw = [
//        0x30, 0x81, 0xbb, 0x02, 0x01, 0x03, 0x30, 0x11,
//        0x02, 0x04, 0x45, 0xb6, 0x4b, 0x0b, 0x02, 0x03,
//        0x00, 0xff, 0xe3, 0x04, 0x01, 0x05, 0x02, 0x01,
//        0x03, 0x04, 0x30, 0x30, 0x2e, 0x04, 0x0d, 0x80,
//        0x00, 0x1f, 0x88, 0x80, 0x59, 0xdc, 0x48, 0x61,
//        0x45, 0xa2, 0x63, 0x22, 0x02, 0x01, 0x08, 0x02,
//        0x02, 0x0a, 0xba, 0x04, 0x06, 0x70, 0x69, 0x70,
//        0x70, 0x6f, 0x33, 0x04, 0x0c, 0xac, 0x46, 0x07,
//        0x0b, 0x60, 0x74, 0xb1, 0x6f, 0xcd, 0x6d, 0xba,
//        0x06, 0x04, 0x00, 0x30, 0x71, 0x04, 0x0d, 0x80,
//        0x00, 0x1f, 0x88, 0x80, 0x59, 0xdc, 0x48, 0x61,
//        0x45, 0xa2, 0x63, 0x22, 0x04, 0x00, 0xa1, 0x5e,
//        0x02, 0x04, 0x6d, 0xb7, 0x20, 0x58, 0x02, 0x01,
//        0x00, 0x02, 0x01, 0x00, 0x30, 0x50, 0x30, 0x0e,
//        0x06, 0x0a, 0x2b, 0x06, 0x01, 0x02, 0x01, 0x02,
//        0x02, 0x01, 0x08, 0x02, 0x05, 0x00, 0x30, 0x0e,
//        0x06, 0x0a, 0x2b, 0x06, 0x01, 0x02, 0x01, 0x02,
//        0x02, 0x01, 0x0b, 0x02, 0x05, 0x00, 0x30, 0x0e,
//        0x06, 0x0a, 0x2b, 0x06, 0x01, 0x02, 0x01, 0x02,
//        0x02, 0x01, 0x0c, 0x02, 0x05, 0x00, 0x30, 0x0e,
//        0x06, 0x0a, 0x2b, 0x06, 0x01, 0x02, 0x01, 0x02,
//        0x02, 0x01, 0x11, 0x02, 0x05, 0x00, 0x30, 0x0e,
//        0x06, 0x0a, 0x2b, 0x06, 0x01, 0x02, 0x01, 0x02,
//        0x02, 0x01, 0x12, 0x02, 0x05, 0x00
//      ];
//      auto snmp = raw.to!SNMPv3;
//
//      Json json = snmp.toJson;
//      assert(json.ver == 3);
//      assert(json.identifier == 1169574667);
//      assert(json.max_size == 65507);
//      assert(json.flags == 5);
//      assert(json.security_model == 3);
//
//      ubyte[] rawSecurityParameters = [
//        0x30, 0x2e, 0x04, 0x0d, 0x80, 0x00, 0x1f, 0x88,
//        0x80, 0x59, 0xdc, 0x48, 0x61, 0x45, 0xa2, 0x63,
//        0x22, 0x02, 0x01, 0x08, 0x02, 0x02, 0x0a, 0xba,
//        0x04, 0x06, 0x70, 0x69, 0x70, 0x70, 0x6f, 0x33,
//        0x04, 0x0c, 0xac, 0x46, 0x07, 0x0b, 0x60, 0x74,
//        0xb1, 0x6f, 0xcd, 0x6d, 0xba, 0x06, 0x04, 0x00
//      ];
//      auto securityParameters = rawSecurityParameters.toASN1;
//      assert(json.security_parameters == serializeToJson(securityParameters));
//
//      ASN1 pdu;
//      pdu.type = ASN1.Type.SEQUENCE;
//      pdu.data = [
//        0x04, 0x0d, 0x80, 0x00, 0x1f, 0x88, 0x80, 0x59,
//        0xdc, 0x48, 0x61, 0x45, 0xa2, 0x63, 0x22, 0x04,
//        0x00, 0xa1, 0x5e, 0x02, 0x04, 0x6d, 0xb7, 0x20,
//        0x58, 0x02, 0x01, 0x00, 0x02, 0x01, 0x00, 0x30,
//        0x50, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//        0x02, 0x01, 0x02, 0x02, 0x01, 0x08, 0x02, 0x05,
//        0x00, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//        0x02, 0x01, 0x02, 0x02, 0x01, 0x0b, 0x02, 0x05,
//        0x00, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//        0x02, 0x01, 0x02, 0x02, 0x01, 0x0c, 0x02, 0x05,
//        0x00, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//        0x02, 0x01, 0x02, 0x02, 0x01, 0x11, 0x02, 0x05,
//        0x00, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//        0x02, 0x01, 0x02, 0x02, 0x01, 0x12, 0x02, 0x05,
//        0x00
//      ];
//      assert(json.pdu == serializeToJson(pdu));
//    }
//
//    override ubyte[] toBytes() const {
//      ASN1 seq;
//      seq.type = ASN1.Type.SEQUENCE;
//
//      seq.data = _version.makeASN1(ASN1.Type.INTEGER, 1).toBytes;
//
//      ASN1 globalData;
//      globalData.type = ASN1.Type.SEQUENCE;
//
//      globalData.data ~= _identifier.makeASN1(ASN1.Type.INTEGER).toBytes;
//      globalData.data ~= _maxSize.makeASN1(ASN1.Type.INTEGER, 3).toBytes;
//      globalData.data ~= _flags.makeASN1(ASN1.Type.OCTET_STRING, 1).toBytes;
//      globalData.data ~= _securityModel.makeASN1(ASN1.Type.INTEGER, 1).toBytes;
//
//      seq.data ~= globalData.toBytes;
//      ASN1 secur;
//      secur.type = ASN1.Type.OCTET_STRING;
//      secur.data = _securityParameters.toBytes;
//      seq.data ~= secur.toBytes;
//      seq.data ~= _pdu.toBytes;
//
//      return seq.toBytes;
//    }
//
//    unittest {
//      ubyte[] raw = [
//        0x30, 0x81, 0xbb, 0x02, 0x01, 0x03, 0x30, 0x11,
//        0x02, 0x04, 0x45, 0xb6, 0x4b, 0x0b, 0x02, 0x03,
//        0x00, 0xff, 0xe3, 0x04, 0x01, 0x05, 0x02, 0x01,
//        0x03, 0x04, 0x30, 0x30, 0x2e, 0x04, 0x0d, 0x80,
//        0x00, 0x1f, 0x88, 0x80, 0x59, 0xdc, 0x48, 0x61,
//        0x45, 0xa2, 0x63, 0x22, 0x02, 0x01, 0x08, 0x02,
//        0x02, 0x0a, 0xba, 0x04, 0x06, 0x70, 0x69, 0x70,
//        0x70, 0x6f, 0x33, 0x04, 0x0c, 0xac, 0x46, 0x07,
//        0x0b, 0x60, 0x74, 0xb1, 0x6f, 0xcd, 0x6d, 0xba,
//        0x06, 0x04, 0x00, 0x30, 0x71, 0x04, 0x0d, 0x80,
//        0x00, 0x1f, 0x88, 0x80, 0x59, 0xdc, 0x48, 0x61,
//        0x45, 0xa2, 0x63, 0x22, 0x04, 0x00, 0xa1, 0x5e,
//        0x02, 0x04, 0x6d, 0xb7, 0x20, 0x58, 0x02, 0x01,
//        0x00, 0x02, 0x01, 0x00, 0x30, 0x50, 0x30, 0x0e,
//        0x06, 0x0a, 0x2b, 0x06, 0x01, 0x02, 0x01, 0x02,
//        0x02, 0x01, 0x08, 0x02, 0x05, 0x00, 0x30, 0x0e,
//        0x06, 0x0a, 0x2b, 0x06, 0x01, 0x02, 0x01, 0x02,
//        0x02, 0x01, 0x0b, 0x02, 0x05, 0x00, 0x30, 0x0e,
//        0x06, 0x0a, 0x2b, 0x06, 0x01, 0x02, 0x01, 0x02,
//        0x02, 0x01, 0x0c, 0x02, 0x05, 0x00, 0x30, 0x0e,
//        0x06, 0x0a, 0x2b, 0x06, 0x01, 0x02, 0x01, 0x02,
//        0x02, 0x01, 0x11, 0x02, 0x05, 0x00, 0x30, 0x0e,
//        0x06, 0x0a, 0x2b, 0x06, 0x01, 0x02, 0x01, 0x02,
//        0x02, 0x01, 0x12, 0x02, 0x05, 0x00
//      ];
//
//      auto snmp = raw.to!SNMPv3;
//      auto bytes = snmp.toBytes;
//
//      assert (snmp.toBytes == raw);
//    }
//
//    override string toString() const { return toJson.toPrettyString; }
//
//    @property {
//      Protocol data() { return null; }
//      void data(Protocol) {}
//
//      inout string name() { return "SNMPv3"; }
//
//      int osiLayer() const { return 7; }
//
//      int ver() const { return _version; }
//      void ver(int data) { _version = data; }
//
//      uint identifier() const { return _identifier; }
//      void identifier(uint data) { _identifier = data; }
//
//      uint maxSize() const { return _maxSize; }
//      void maxSize(uint data) { _maxSize = data; }
//
//      ubyte flags() const { return _flags; }
//      void flags(ubyte data) { _flags = data; }
//
//      uint securityModel() const { return _securityModel; }
//      void securityModel(uint data) { _securityModel = data; }
//
//      ref ASN1 securityParameters() { return _securityParameters; }
//      void securityParameters(ASN1 data) { _securityParameters = data; }
//
//      ref ASN1 pdu() { return _pdu; }
//      void pdu(ASN1 data) { _pdu = data; }
//    }
//
//  private:
//    int _version;
//    uint _identifier;
//    uint _maxSize;
//    ubyte _flags;
//    uint _securityModel;
//    ASN1 _securityParameters;
//    ASN1 _pdu;
//}
//
//unittest {
//  Json json = Json.emptyObject;
//  json.ver = 3;
//  json.identifier = 1169574667;
//  json.max_size = 65507;
//  json.flags = 5;
//  json.security_model = 3;
//
//  ubyte[] rawSecurityParameters = [
//    0x30, 0x2e, 0x04, 0x0d, 0x80, 0x00, 0x1f, 0x88,
//    0x80, 0x59, 0xdc, 0x48, 0x61, 0x45, 0xa2, 0x63,
//    0x22, 0x02, 0x01, 0x08, 0x02, 0x02, 0x0a, 0xba,
//    0x04, 0x06, 0x70, 0x69, 0x70, 0x70, 0x6f, 0x33,
//    0x04, 0x0c, 0xac, 0x46, 0x07, 0x0b, 0x60, 0x74,
//    0xb1, 0x6f, 0xcd, 0x6d, 0xba, 0x06, 0x04, 0x00
//  ];
//  auto securityParameters = rawSecurityParameters.toASN1;
//  json.security_parameters = serializeToJson(securityParameters);
//
//  ASN1 pdu;
//  pdu.type = ASN1.Type.SEQUENCE;
//  pdu.data = [
//    0x04, 0x0d, 0x80, 0x00, 0x1f, 0x88, 0x80, 0x59,
//    0xdc, 0x48, 0x61, 0x45, 0xa2, 0x63, 0x22, 0x04,
//    0x00, 0xa1, 0x5e, 0x02, 0x04, 0x6d, 0xb7, 0x20,
//    0x58, 0x02, 0x01, 0x00, 0x02, 0x01, 0x00, 0x30,
//    0x50, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//    0x02, 0x01, 0x02, 0x02, 0x01, 0x08, 0x02, 0x05,
//    0x00, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//    0x02, 0x01, 0x02, 0x02, 0x01, 0x0b, 0x02, 0x05,
//    0x00, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//    0x02, 0x01, 0x02, 0x02, 0x01, 0x0c, 0x02, 0x05,
//    0x00, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//    0x02, 0x01, 0x02, 0x02, 0x01, 0x11, 0x02, 0x05,
//    0x00, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//    0x02, 0x01, 0x02, 0x02, 0x01, 0x12, 0x02, 0x05,
//    0x00
//  ];
//  json.pdu = serializeToJson(pdu);
//
//  auto snmp = cast(SNMPv3)to!SNMPv3(json);
//  assert(snmp.ver == 3);
//  assert(snmp.identifier == 1169574667);
//  assert(snmp.maxSize == 65507);
//  assert(snmp.flags == 5);
//  assert(snmp.securityModel == 3);
//  assert(snmp.securityParameters.data.toASN1Seq.length == 6);
//  assert(snmp.pdu.type == ASN1.Type.SEQUENCE);
//  assert(snmp.pdu.length == 113);
//  assert(snmp.pdu.data == [
//    0x04, 0x0d, 0x80, 0x00, 0x1f, 0x88, 0x80, 0x59,
//    0xdc, 0x48, 0x61, 0x45, 0xa2, 0x63, 0x22, 0x04,
//    0x00, 0xa1, 0x5e, 0x02, 0x04, 0x6d, 0xb7, 0x20,
//    0x58, 0x02, 0x01, 0x00, 0x02, 0x01, 0x00, 0x30,
//    0x50, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//    0x02, 0x01, 0x02, 0x02, 0x01, 0x08, 0x02, 0x05,
//    0x00, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//    0x02, 0x01, 0x02, 0x02, 0x01, 0x0b, 0x02, 0x05,
//    0x00, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//    0x02, 0x01, 0x02, 0x02, 0x01, 0x0c, 0x02, 0x05,
//    0x00, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//    0x02, 0x01, 0x02, 0x02, 0x01, 0x11, 0x02, 0x05,
//    0x00, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//    0x02, 0x01, 0x02, 0x02, 0x01, 0x12, 0x02, 0x05,
//    0x00
//  ]);
//}
//
//unittest {
//  ubyte[] raw = [
//  0x30, 0x81, 0xbb, 0x02, 0x01, 0x03, 0x30, 0x11,
//  0x02, 0x04, 0x45, 0xb6, 0x4b, 0x0b, 0x02, 0x03,
//  0x00, 0xff, 0xe3, 0x04, 0x01, 0x05, 0x02, 0x01,
//  0x03, 0x04, 0x30, 0x30, 0x2e, 0x04, 0x0d, 0x80,
//  0x00, 0x1f, 0x88, 0x80, 0x59, 0xdc, 0x48, 0x61,
//  0x45, 0xa2, 0x63, 0x22, 0x02, 0x01, 0x08, 0x02,
//  0x02, 0x0a, 0xba, 0x04, 0x06, 0x70, 0x69, 0x70,
//  0x70, 0x6f, 0x33, 0x04, 0x0c, 0xac, 0x46, 0x07,
//  0x0b, 0x60, 0x74, 0xb1, 0x6f, 0xcd, 0x6d, 0xba,
//  0x06, 0x04, 0x00, 0x30, 0x71, 0x04, 0x0d, 0x80,
//  0x00, 0x1f, 0x88, 0x80, 0x59, 0xdc, 0x48, 0x61,
//  0x45, 0xa2, 0x63, 0x22, 0x04, 0x00, 0xa1, 0x5e,
//  0x02, 0x04, 0x6d, 0xb7, 0x20, 0x58, 0x02, 0x01,
//  0x00, 0x02, 0x01, 0x00, 0x30, 0x50, 0x30, 0x0e,
//  0x06, 0x0a, 0x2b, 0x06, 0x01, 0x02, 0x01, 0x02,
//  0x02, 0x01, 0x08, 0x02, 0x05, 0x00, 0x30, 0x0e,
//  0x06, 0x0a, 0x2b, 0x06, 0x01, 0x02, 0x01, 0x02,
//  0x02, 0x01, 0x0b, 0x02, 0x05, 0x00, 0x30, 0x0e,
//  0x06, 0x0a, 0x2b, 0x06, 0x01, 0x02, 0x01, 0x02,
//  0x02, 0x01, 0x0c, 0x02, 0x05, 0x00, 0x30, 0x0e,
//  0x06, 0x0a, 0x2b, 0x06, 0x01, 0x02, 0x01, 0x02,
//  0x02, 0x01, 0x11, 0x02, 0x05, 0x00, 0x30, 0x0e,
//  0x06, 0x0a, 0x2b, 0x06, 0x01, 0x02, 0x01, 0x02,
//  0x02, 0x01, 0x12, 0x02, 0x05, 0x00
//  ];
//
//  auto snmp = cast(SNMPv3)raw.to!SNMPv3;
//  assert(snmp.ver == 3);
//  assert(snmp.identifier == 1169574667);
//  assert(snmp.maxSize == 65507);
//  assert(snmp.flags == 5);
//  assert(snmp.securityModel == 3);
//  assert(snmp.securityParameters.data.toASN1Seq.length == 6);
//  assert(snmp.pdu.type == ASN1.Type.SEQUENCE);
//  assert(snmp.pdu.length == 113);
//  assert(snmp.pdu.data == [
//    0x04, 0x0d, 0x80, 0x00, 0x1f, 0x88, 0x80, 0x59,
//    0xdc, 0x48, 0x61, 0x45, 0xa2, 0x63, 0x22, 0x04,
//    0x00, 0xa1, 0x5e, 0x02, 0x04, 0x6d, 0xb7, 0x20,
//    0x58, 0x02, 0x01, 0x00, 0x02, 0x01, 0x00, 0x30,
//    0x50, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//    0x02, 0x01, 0x02, 0x02, 0x01, 0x08, 0x02, 0x05,
//    0x00, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//    0x02, 0x01, 0x02, 0x02, 0x01, 0x0b, 0x02, 0x05,
//    0x00, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//    0x02, 0x01, 0x02, 0x02, 0x01, 0x0c, 0x02, 0x05,
//    0x00, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//    0x02, 0x01, 0x02, 0x02, 0x01, 0x11, 0x02, 0x05,
//    0x00, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01,
//    0x02, 0x01, 0x02, 0x02, 0x01, 0x12, 0x02, 0x05,
//    0x00
//  ]);
//}
//
//// Internal
//private uint readUint(ubyte[] bytes) {
//  ubyte[] tmp = [0, 0, 0, 0];
//  tmp[$ - bytes.length .. $] = bytes;
//  return tmp.read!uint;
//}
//
//private ASN1 makeASN1(T)(T data, ASN1.Type type, ulong minifyTo = 4) {
//  ASN1 ret;
//  auto a = appender!(ubyte[])();
//  a.append!T(data);
//  ret.type = type;
//  uint i = 0;
//  while (a.data[i] == 0 && i < a.data.length) { ++i; }
//  if (i == a.data.length)
//    --i;
//  if (a.data.length - i < minifyTo)
//    i = cast(uint)(a.data.length - minifyTo);
//  ret.data = a.data[i .. $];
//  return ret;
//}

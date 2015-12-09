//module netload.protocols.snmp.asn_1;
//
//struct ASN1 {
//  enum Type : ubyte {
//    INTEGER = 0x02,
//    OCTET_STRING = 0x04,
//    NULL = 0x05,
//    OBJECT_IDENTIFIER = 0x06,
//    SEQUENCE = 0x30,
//    GET_REQUEST_PDU = 0xA0,
//    GET_RESPONSE_PDU = 0xA2,
//    SET_REQUEST_PDU = 0xA3
//  }
//
//  Type type;
//  ubyte[] data;
//  @property ushort length() const { return cast(ushort)(data.length); }
//}
//
//ASN1 toASN1(ref ubyte[] bytes) {
//  ASN1 asn;
//  asn.type = cast(ASN1.Type)(bytes[0]);
//  ushort length = 0;
//  if (bytes[1] & 0b10000000) {
//    length = (bytes[1] & 0b01111111) * 128 + (bytes[2] & 0b01111111);
//    asn.data = bytes[3 .. length + 3];
//    bytes = bytes[length + 3 .. $];
//  } else {
//    length = bytes[1] & 0b01111111;
//    asn.data = bytes[2 .. length + 2];
//    bytes = bytes[length + 2 .. $];
//  }
//  return asn;
//}
//
//unittest {
//  ubyte[] raw = [
//    0x30, 0x81, 0x85, 0x02, 0x01, 0x00, 0x04, 0x06,
//    0x70, 0x75, 0x62, 0x6c, 0x69, 0x63, 0xa3, 0x78,
//    0x02, 0x01, 0x3a, 0x02, 0x01, 0x00, 0x02, 0x01,
//    0x00, 0x30, 0x6d, 0x30, 0x13, 0x06, 0x0e, 0x2b,
//    0x06, 0x01, 0x04, 0x01, 0x81, 0x7d, 0x08, 0x33,
//    0x08, 0x02, 0x01, 0x02, 0x01, 0x02, 0x01, 0x04,
//    0x30, 0x21, 0x06, 0x0e, 0x2b, 0x06, 0x01, 0x04,
//    0x01, 0x81, 0x7d, 0x08, 0x33, 0x08, 0x02, 0x01,
//    0x03, 0x01, 0x04, 0x0f, 0x46, 0x75, 0x6a, 0x69,
//    0x58, 0x65, 0x72, 0x6f, 0x78, 0x45, 0x78, 0x6f,
//    0x64, 0x75, 0x73, 0x30, 0x1d, 0x06, 0x0e, 0x2b,
//    0x06, 0x01, 0x04, 0x01, 0x81, 0x7d, 0x08, 0x33,
//    0x08, 0x02, 0x01, 0x04, 0x01, 0x06, 0x0b, 0x2b,
//    0x06, 0x01, 0x04, 0x01, 0x81, 0x7d, 0x08, 0x33,
//    0x08, 0x02, 0x30, 0x14, 0x06, 0x0e, 0x2b, 0x06,
//    0x01, 0x04, 0x01, 0x81, 0x7d, 0x08, 0x33, 0x08,
//    0x02, 0x01, 0x05, 0x01, 0x02, 0x02, 0x01, 0x2c
//  ];
//  ASN1 seq = raw.toASN1;
//  assert(seq.type == ASN1.Type.SEQUENCE);
//  assert(seq.length == 133);
//  assert(seq.data == [
//    0x02, 0x01, 0x00, 0x04, 0x06, 0x70, 0x75, 0x62,
//    0x6c, 0x69, 0x63, 0xa3, 0x78, 0x02, 0x01, 0x3a,
//    0x02, 0x01, 0x00, 0x02, 0x01, 0x00, 0x30, 0x6d,
//    0x30, 0x13, 0x06, 0x0e, 0x2b, 0x06, 0x01, 0x04,
//    0x01, 0x81, 0x7d, 0x08, 0x33, 0x08, 0x02, 0x01,
//    0x02, 0x01, 0x02, 0x01, 0x04, 0x30, 0x21, 0x06,
//    0x0e, 0x2b, 0x06, 0x01, 0x04, 0x01, 0x81, 0x7d,
//    0x08, 0x33, 0x08, 0x02, 0x01, 0x03, 0x01, 0x04,
//    0x0f, 0x46, 0x75, 0x6a, 0x69, 0x58, 0x65, 0x72,
//    0x6f, 0x78, 0x45, 0x78, 0x6f, 0x64, 0x75, 0x73,
//    0x30, 0x1d, 0x06, 0x0e, 0x2b, 0x06, 0x01, 0x04,
//    0x01, 0x81, 0x7d, 0x08, 0x33, 0x08, 0x02, 0x01,
//    0x04, 0x01, 0x06, 0x0b, 0x2b, 0x06, 0x01, 0x04,
//    0x01, 0x81, 0x7d, 0x08, 0x33, 0x08, 0x02, 0x30,
//    0x14, 0x06, 0x0e, 0x2b, 0x06, 0x01, 0x04, 0x01,
//    0x81, 0x7d, 0x08, 0x33, 0x08, 0x02, 0x01, 0x05,
//    0x01, 0x02, 0x02, 0x01, 0x2c
//  ]);
//  assert(raw.length == 0);
//}
//
//ASN1[] toASN1Seq(ref ubyte[] bytes) {
//  ASN1[] sequence;
//  while (bytes.length) { sequence ~= bytes.toASN1; }
//  return sequence;
//}
//
//unittest {
//  ubyte[] raw = [
//    0x02, 0x01, 0x00, 0x04, 0x06, 0x70, 0x75, 0x62,
//    0x6c, 0x69, 0x63, 0xa3, 0x78, 0x02, 0x01, 0x3a,
//    0x02, 0x01, 0x00, 0x02, 0x01, 0x00, 0x30, 0x6d,
//    0x30, 0x13, 0x06, 0x0e, 0x2b, 0x06, 0x01, 0x04,
//    0x01, 0x81, 0x7d, 0x08, 0x33, 0x08, 0x02, 0x01,
//    0x02, 0x01, 0x02, 0x01, 0x04, 0x30, 0x21, 0x06,
//    0x0e, 0x2b, 0x06, 0x01, 0x04, 0x01, 0x81, 0x7d,
//    0x08, 0x33, 0x08, 0x02, 0x01, 0x03, 0x01, 0x04,
//    0x0f, 0x46, 0x75, 0x6a, 0x69, 0x58, 0x65, 0x72,
//    0x6f, 0x78, 0x45, 0x78, 0x6f, 0x64, 0x75, 0x73,
//    0x30, 0x1d, 0x06, 0x0e, 0x2b, 0x06, 0x01, 0x04,
//    0x01, 0x81, 0x7d, 0x08, 0x33, 0x08, 0x02, 0x01,
//    0x04, 0x01, 0x06, 0x0b, 0x2b, 0x06, 0x01, 0x04,
//    0x01, 0x81, 0x7d, 0x08, 0x33, 0x08, 0x02, 0x30,
//    0x14, 0x06, 0x0e, 0x2b, 0x06, 0x01, 0x04, 0x01,
//    0x81, 0x7d, 0x08, 0x33, 0x08, 0x02, 0x01, 0x05,
//    0x01, 0x02, 0x02, 0x01, 0x2c
//  ];
//  ASN1[] seq = raw.toASN1Seq;
//  assert(seq.length == 3);
//
//  assert(seq[0].type == ASN1.Type.INTEGER);
//  assert(seq[0].length == 1);
//  assert(seq[0].data == [ 0x00 ]);
//
//  assert(seq[1].type == ASN1.Type.OCTET_STRING);
//  assert(seq[1].length == 6);
//  assert(seq[1].data == [ 0x70, 0x75, 0x62, 0x6c, 0x69, 0x63 ]);
//
//  assert(seq[2].type == ASN1.Type.SET_REQUEST_PDU);
//  assert(seq[2].length == 120);
//  assert(seq[2].data == [
//    0x02, 0x01, 0x3a, 0x02, 0x01, 0x00, 0x02, 0x01,
//    0x00, 0x30, 0x6d, 0x30, 0x13, 0x06, 0x0e, 0x2b,
//    0x06, 0x01, 0x04, 0x01, 0x81, 0x7d, 0x08, 0x33,
//    0x08, 0x02, 0x01, 0x02, 0x01, 0x02, 0x01, 0x04,
//    0x30, 0x21, 0x06, 0x0e, 0x2b, 0x06, 0x01, 0x04,
//    0x01, 0x81, 0x7d, 0x08, 0x33, 0x08, 0x02, 0x01,
//    0x03, 0x01, 0x04, 0x0f, 0x46, 0x75, 0x6a, 0x69,
//    0x58, 0x65, 0x72, 0x6f, 0x78, 0x45, 0x78, 0x6f,
//    0x64, 0x75, 0x73, 0x30, 0x1d, 0x06, 0x0e, 0x2b,
//    0x06, 0x01, 0x04, 0x01, 0x81, 0x7d, 0x08, 0x33,
//    0x08, 0x02, 0x01, 0x04, 0x01, 0x06, 0x0b, 0x2b,
//    0x06, 0x01, 0x04, 0x01, 0x81, 0x7d, 0x08, 0x33,
//    0x08, 0x02, 0x30, 0x14, 0x06, 0x0e, 0x2b, 0x06,
//    0x01, 0x04, 0x01, 0x81, 0x7d, 0x08, 0x33, 0x08,
//    0x02, 0x01, 0x05, 0x01, 0x02, 0x02, 0x01, 0x2c
//  ]);
//}
//
//ubyte[] toBytes(const ASN1 asn) {
//  ubyte[] bytes;
//  bytes ~= asn.type;
//  if (asn.length & 0b10000000) {
//    bytes ~= cast(ubyte)(asn.length / 128 & 0b01111111 | 0b10000000);
//    bytes ~= cast(ubyte)(asn.length & 0b01111111 | 0b10000000);
//  } else {
//    bytes ~= cast(ubyte)(asn.length);
//  }
//  bytes ~= asn.data;
//  return bytes;
//}
//
//unittest {
//  ASN1 asn;
//  asn.type = ASN1.Type.OCTET_STRING;
//  asn.data = [ 0x70, 0x75, 0x62, 0x6c, 0x69, 0x63 ];
//  assert(asn.toBytes == [ 0x04, 0x06, 0x70, 0x75, 0x62, 0x6c, 0x69, 0x63 ]);
//}
//
//unittest {
//  ASN1 asn;
//  asn.type = ASN1.Type.SEQUENCE;
//  asn.data = [
//    0x02, 0x01, 0x00, 0x04, 0x06, 0x70, 0x75, 0x62,
//    0x6c, 0x69, 0x63, 0xa3, 0x78, 0x02, 0x01, 0x3a,
//    0x02, 0x01, 0x00, 0x02, 0x01, 0x00, 0x30, 0x6d,
//    0x30, 0x13, 0x06, 0x0e, 0x2b, 0x06, 0x01, 0x04,
//    0x01, 0x81, 0x7d, 0x08, 0x33, 0x08, 0x02, 0x01,
//    0x02, 0x01, 0x02, 0x01, 0x04, 0x30, 0x21, 0x06,
//    0x0e, 0x2b, 0x06, 0x01, 0x04, 0x01, 0x81, 0x7d,
//    0x08, 0x33, 0x08, 0x02, 0x01, 0x03, 0x01, 0x04,
//    0x0f, 0x46, 0x75, 0x6a, 0x69, 0x58, 0x65, 0x72,
//    0x6f, 0x78, 0x45, 0x78, 0x6f, 0x64, 0x75, 0x73,
//    0x30, 0x1d, 0x06, 0x0e, 0x2b, 0x06, 0x01, 0x04,
//    0x01, 0x81, 0x7d, 0x08, 0x33, 0x08, 0x02, 0x01,
//    0x04, 0x01, 0x06, 0x0b, 0x2b, 0x06, 0x01, 0x04,
//    0x01, 0x81, 0x7d, 0x08, 0x33, 0x08, 0x02, 0x30,
//    0x14, 0x06, 0x0e, 0x2b, 0x06, 0x01, 0x04, 0x01,
//    0x81, 0x7d, 0x08, 0x33, 0x08, 0x02, 0x01, 0x05,
//    0x01, 0x02, 0x02, 0x01, 0x2c
//  ];
//
//  assert(asn.toBytes == [
//    0x30, 0x81, 0x85, 0x02, 0x01, 0x00, 0x04, 0x06,
//    0x70, 0x75, 0x62, 0x6c, 0x69, 0x63, 0xa3, 0x78,
//    0x02, 0x01, 0x3a, 0x02, 0x01, 0x00, 0x02, 0x01,
//    0x00, 0x30, 0x6d, 0x30, 0x13, 0x06, 0x0e, 0x2b,
//    0x06, 0x01, 0x04, 0x01, 0x81, 0x7d, 0x08, 0x33,
//    0x08, 0x02, 0x01, 0x02, 0x01, 0x02, 0x01, 0x04,
//    0x30, 0x21, 0x06, 0x0e, 0x2b, 0x06, 0x01, 0x04,
//    0x01, 0x81, 0x7d, 0x08, 0x33, 0x08, 0x02, 0x01,
//    0x03, 0x01, 0x04, 0x0f, 0x46, 0x75, 0x6a, 0x69,
//    0x58, 0x65, 0x72, 0x6f, 0x78, 0x45, 0x78, 0x6f,
//    0x64, 0x75, 0x73, 0x30, 0x1d, 0x06, 0x0e, 0x2b,
//    0x06, 0x01, 0x04, 0x01, 0x81, 0x7d, 0x08, 0x33,
//    0x08, 0x02, 0x01, 0x04, 0x01, 0x06, 0x0b, 0x2b,
//    0x06, 0x01, 0x04, 0x01, 0x81, 0x7d, 0x08, 0x33,
//    0x08, 0x02, 0x30, 0x14, 0x06, 0x0e, 0x2b, 0x06,
//    0x01, 0x04, 0x01, 0x81, 0x7d, 0x08, 0x33, 0x08,
//    0x02, 0x01, 0x05, 0x01, 0x02, 0x02, 0x01, 0x2c
//  ]);
//}

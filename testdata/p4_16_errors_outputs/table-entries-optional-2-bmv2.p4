#include <core.p4>
#define V1MODEL_VERSION 20180101
#include <v1model.p4>

header hdr {
    bit<8>  e;
    bit<16> t;
    bit<8>  l;
    bit<8>  r;
    bit<8>  v;
}

struct Header_t {
    hdr h;
}

struct Meta_t {
}

parser p(packet_in b, out Header_t h, inout Meta_t m, inout standard_metadata_t sm) {
    state start {
        b.extract(h.h);
        transition accept;
    }
}

control vrfy(inout Header_t h, inout Meta_t m) {
    apply {
    }
}

control update(inout Header_t h, inout Meta_t m) {
    apply {
    }
}

control egress(inout Header_t h, inout Meta_t m, inout standard_metadata_t sm) {
    apply {
    }
}

control deparser(packet_out b, in Header_t h) {
    apply {
        b.emit(h.h);
    }
}

control ingress(inout Header_t h, inout Meta_t m, inout standard_metadata_t standard_meta) {
    action a() {
        standard_meta.egress_spec = 0;
    }
    action a_with_control_params(bit<9> x) {
        standard_meta.egress_spec = x;
    }
    table t_optional {
        key = {
            h.h.e: optional;
            h.h.t: optional;
        }
        actions = {
            a;
            a_with_control_params;
        }
        default_action = a;
        const entries = {
                        (0xaa &&& 0xf0, 0x1111 &&& 0xffff) : a_with_control_params(1);
                        (0x100, default) : a_with_control_params(2);
                        (default, 0x10000) : a_with_control_params(3);
        }
    }
    apply {
        t_optional.apply();
    }
}

V1Switch(p(), vrfy(), ingress(), egress(), update(), deparser()) main;


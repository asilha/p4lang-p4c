#include <core.p4>
#define V1MODEL_VERSION 20180101
#include <v1model.p4>

header ethernet_t {
    bit<48> dst_addr;
    bit<48> src_addr;
    bit<16> eth_type;
}

struct Headers {
    ethernet_t eth_hdr;
}

struct Meta {
}

parser p(packet_in pkt, out Headers hdr, inout Meta m, inout standard_metadata_t sm) {
    state start {
        pkt.extract<ethernet_t>(hdr.eth_hdr);
        transition accept;
    }
}

control ingress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    bool hasExited;
    bit<48> key_0;
    @noWarn("unused") @name(".NoAction") action NoAction_0() {
    }
    @name("ingress.dummy") action dummy() {
    }
    @name("ingress.simple_table") table simple_table_0 {
        key = {
            key_0: exact @name("key") ;
        }
        actions = {
            dummy();
            @defaultonly NoAction_0();
        }
        default_action = NoAction_0();
    }
    @hidden action gauntlet_exit_combination_2bmv2l40() {
        h.eth_hdr.src_addr = 48w1;
        hasExited = true;
    }
    @hidden action gauntlet_exit_combination_2bmv2l31() {
        hasExited = false;
        key_0 = 48w100;
    }
    @hidden action gauntlet_exit_combination_2bmv2l45() {
        h.eth_hdr.dst_addr = 48w5;
    }
    @hidden table tbl_gauntlet_exit_combination_2bmv2l31 {
        actions = {
            gauntlet_exit_combination_2bmv2l31();
        }
        const default_action = gauntlet_exit_combination_2bmv2l31();
    }
    @hidden table tbl_gauntlet_exit_combination_2bmv2l40 {
        actions = {
            gauntlet_exit_combination_2bmv2l40();
        }
        const default_action = gauntlet_exit_combination_2bmv2l40();
    }
    @hidden table tbl_gauntlet_exit_combination_2bmv2l45 {
        actions = {
            gauntlet_exit_combination_2bmv2l45();
        }
        const default_action = gauntlet_exit_combination_2bmv2l45();
    }
    apply {
        tbl_gauntlet_exit_combination_2bmv2l31.apply();
        switch (simple_table_0.apply().action_run) {
            dummy: {
                tbl_gauntlet_exit_combination_2bmv2l40.apply();
            }
            default: {
            }
        }
        if (!hasExited) {
            tbl_gauntlet_exit_combination_2bmv2l45.apply();
        }
    }
}

control vrfy(inout Headers h, inout Meta m) {
    apply {
    }
}

control update(inout Headers h, inout Meta m) {
    apply {
    }
}

control egress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    apply {
    }
}

control deparser(packet_out pkt, in Headers h) {
    apply {
        pkt.emit<ethernet_t>(h.eth_hdr);
    }
}

V1Switch<Headers, Meta>(p(), vrfy(), ingress(), egress(), update(), deparser()) main;


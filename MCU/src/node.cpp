#include <node.hpp>
#include <uavcan/uavcan.hpp>
#include <uavcan_stm32/uavcan_stm32.hpp>

#include <ch.hpp>
#include <hal.h>

namespace Node {

uavcan_stm32::CanInitHelper<> can;

uavcan::Node<NodePoolSize>& getNode() {
    static uavcan::Node<NodePoolSize> node(can.driver, uavcan_stm32::SystemClock::instance());
    return node;
}

void uavcanNodeThread::configureNodeInfo() {
    getNode().setName("org.kmti.gmm_controler");

    uavcan::protocol::SoftwareVersion swver;

    swver.vcs_commit = 0; //TODO: add git hash
    swver.optional_field_flags = swver.OPTIONAL_FIELD_FLAG_VCS_COMMIT;

    getNode().setSoftwareVersion(swver);

    uavcan::protocol::HardwareVersion hwver;
    //TODO: fill board UUID

    getNode().setHardwareVersion(hwver);
}
void uavcanNodeThread::main() {
    configureNodeInfo();

    const int node_init_res = getNode().start();
    if(node_init_res < 0) {
        //TODO: add board die
    }

    getNode().setModeOperational();
    while(true) {
        const int spin_res = getNode().spin(uavcan::MonotonicDuration::fromMSec(5000));
        if(spin_res < 0) {
            //TODO: log spin failure
        }

        //TODO: log board status
    }
}

void init() {
    uavcan::uint32_t bitrate = 1000000;
    can.init(bitrate);
}

}

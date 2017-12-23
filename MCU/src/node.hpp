#ifndef GCM_FIRMWARE_SRC_NODE_HPP_
#define GCM_FIRMWARE_SRC_NODE_HPP_

#include <uavcan/uavcan.hpp>
#include <ch.hpp>

namespace Node {

class uavcanNodeThread : public chibios_rt::BaseStaticThread<8192> {
    void configureNodeInfo();
public:
    void main();

};

constexpr unsigned NodePoolSize = 16384;
uavcan::Node<NodePoolSize>& getNode();
void init();

}


#endif /* GCM_FIRMWARE_SRC_NODE_HPP_ */

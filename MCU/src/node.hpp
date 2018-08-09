#ifndef NODE_HPP
#define NODE_HPP

#include <uavcan/uavcan.hpp>
#include <ch.hpp>

#include <uavcan/protocol/file/BeginFirmwareUpdate.hpp>
#include <uavcan_stm32/uavcan_stm32.hpp>

typedef struct _gimbalMessage{
    float x;
    float y;
    float z;
    float w;
    uint8_t cmd;
} __attribute__((packed)) gimbalMessage;

namespace Node {

    constexpr unsigned NodePoolSize = 1024;//2048;
    uavcan::Node<NodePoolSize>& getNode();
    void publishKeyValue(const char *key, float value);
    void send_gmb_cmd(gimbalMessage mess);
    void send_geo_cmd(float lat, float lng, float alt);

    uint32_t getCANBitRate();

    struct Lock : uavcan_stm32::MutexLocker
    {
        Lock();
    };

    using FirmwareUpdateRequestCallback =
        std::function<uavcan::StorageType<uavcan::protocol::file::BeginFirmwareUpdate::Response::FieldTypes::error>::Type
    (const uavcan::ReceivedDataStructure<uavcan::protocol::file::BeginFirmwareUpdate::Request>&)>;

void init(uint32_t bit_rate,
        uint8_t node_id,
        uint8_t firmware_vers_major,
        uint8_t firmware_vers_minor,
        uint32_t vcs_commit,
        uint64_t crc64,
        const FirmwareUpdateRequestCallback& on_firmware_update_requested);

    class uavcanNodeThread : public chibios_rt::BaseStaticThread<4096> {
    public:
        void main();
    };

}

#endif


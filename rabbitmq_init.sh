# !/bin/bash

# 启动脚本的前提
#    - 已完成RabbitMQ的初始配置
#    - 已启用rabbitmq_management & rabbitmq_auth_backend_http & rabbitmq_auth_backend_cache & rabbitmq_event_exchange插件

# server配置需要改动
server="192.168.29.96:15672"
username="admin"
password="Quectel@2022"

# 默认值不需要改
dmp_vhost="quec-open"
dmp_vhost_sys="quec-sys"
event_queue_name="exchange-event-queue"

# 创建vhost
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"name\":\"${dmp_vhost}\",\"description\":\"\",\"tags\":\"\"}" http://${server}/api/vhosts/${dmp_vhost}
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"name\":\"${dmp_vhost_sys}\",\"description\":\"\",\"tags\":\"\"}" http://${server}/api/vhosts/${dmp_vhost_sys}

# vhost授权
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"/\",\"username\":\"${username}\",\"configure\":\".*\",\"write\":\".*\",\"read\":\".*\"}" http://${server}/api/permissions/%2F/${username}
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost}\",\"username\":\"${username}\",\"configure\":\".*\",\"write\":\".*\",\"read\":\".*\"}" http://${server}/api/permissions/${dmp_vhost}/${username}
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost_sys}\",\"username\":\"${username}\",\"configure\":\".*\",\"write\":\".*\",\"read\":\".*\"}" http://${server}/api/permissions/${dmp_vhost_sys}/${username}

# 创建策略
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost}\",\"name\":\"ha-all\",\"pattern\":\"^\",\"apply-to\":\"all\",\"definition\":{\"ha-mode\":\"all\"}}" http://${server}/api/policies/${dmp_vhost}/ha-all
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost_sys}\",\"name\":\"ha-all\",\"pattern\":\"^\",\"apply-to\":\"all\",\"definition\":{\"ha-mode\":\"all\"}}" http://${server}/api/policies/${dmp_vhost_sys}/ha-all

# 创建exchange
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost}\",\"name\":\"quec.device.online\",\"type\":\"headers\",\"durable\":\"true\",\"auto_delete\":\"false\",\"internal\":\"false\",\"arguments\":{}}" http://${server}/api/exchanges/${dmp_vhost}/quec.device.online
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost}\",\"name\":\"quec.device.status\",\"type\":\"headers\",\"durable\":\"true\",\"auto_delete\":\"false\",\"internal\":\"false\",\"arguments\":{}}" http://${server}/api/exchanges/${dmp_vhost}/quec.device.status
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost}\",\"name\":\"quec.device.uplink\",\"type\":\"headers\",\"durable\":\"true\",\"auto_delete\":\"false\",\"internal\":\"false\",\"arguments\":{}}" http://${server}/api/exchanges/${dmp_vhost}/quec.device.uplink
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost}\",\"name\":\"quec.device.downlink\",\"type\":\"headers\",\"durable\":\"true\",\"auto_delete\":\"false\",\"internal\":\"false\",\"arguments\":{}}" http://${server}/api/exchanges/${dmp_vhost}/quec.device.downlink
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost}\",\"name\":\"quec.device.reqack\",\"type\":\"headers\",\"durable\":\"true\",\"auto_delete\":\"false\",\"internal\":\"false\",\"arguments\":{}}" http://${server}/api/exchanges/${dmp_vhost}/quec.device.reqack
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost}\",\"name\":\"quec.model.attr\",\"type\":\"headers\",\"durable\":\"true\",\"auto_delete\":\"false\",\"internal\":\"false\",\"arguments\":{}}" http://${server}/api/exchanges/${dmp_vhost}/quec.model.attr
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost}\",\"name\":\"quec.model.event-info\",\"type\":\"headers\",\"durable\":\"true\",\"auto_delete\":\"false\",\"internal\":\"false\",\"arguments\":{}}" http://${server}/api/exchanges/${dmp_vhost}/quec.model.event-info
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost}\",\"name\":\"quec.model.event-warn\",\"type\":\"headers\",\"durable\":\"true\",\"auto_delete\":\"false\",\"internal\":\"false\",\"arguments\":{}}" http://${server}/api/exchanges/${dmp_vhost}/quec.model.event-warn
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost}\",\"name\":\"quec.model.event-error\",\"type\":\"headers\",\"durable\":\"true\",\"auto_delete\":\"false\",\"internal\":\"false\",\"arguments\":{}}" http://${server}/api/exchanges/${dmp_vhost}/quec.model.event-error
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost}\",\"name\":\"quec.model.serv\",\"type\":\"headers\",\"durable\":\"true\",\"auto_delete\":\"false\",\"internal\":\"false\",\"arguments\":{}}" http://${server}/api/exchanges/${dmp_vhost}/quec.model.serv
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost}\",\"name\":\"quec.device.location\",\"type\":\"headers\",\"durable\":\"true\",\"auto_delete\":\"false\",\"internal\":\"false\",\"arguments\":{}}" http://${server}/api/exchanges/${dmp_vhost}/quec.device.location
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost}\",\"name\":\"quec.meta.event\",\"type\":\"headers\",\"durable\":\"true\",\"auto_delete\":\"false\",\"internal\":\"false\",\"arguments\":{}}" http://${server}/api/exchanges/${dmp_vhost}/quec.meta.event
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost}\",\"name\":\"quec.device.event\",\"type\":\"headers\",\"durable\":\"true\",\"auto_delete\":\"false\",\"internal\":\"false\",\"arguments\":{}}" http://${server}/api/exchanges/${dmp_vhost}/quec.device.event
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"${dmp_vhost}\",\"name\":\"quec.enduser.event\",\"type\":\"headers\",\"durable\":\"true\",\"auto_delete\":\"false\",\"internal\":\"false\",\"arguments\":{}}" http://${server}/api/exchanges/${dmp_vhost}/quec.enduser.event

# 启动事件监听插件
# rabbitmq-plugins enable rabbitmq_event_exchange

# 创建事件监听mq
curl -XPUT --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"/\",\"name\":\"${event_queue_name}\",\"durable\":\"true\",\"auto_delete\":\"false\",\"arguments\":{\"x-queue-type\":\"classic\"}}" http://${server}/api/queues/%2F/${event_queue_name}

# 绑定exchange和mq关系
curl -XPOST --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"/\",\"destination\":\"${event_queue_name}\",\"destination_type\":\"q\",\"source\":\"amq.rabbitmq.event\",\"routing_key\":\"binding.created\",\"arguments\":{}}" http://${server}/api/bindings/%2F/e/amq.rabbitmq.event/q/${event_queue_name}
curl -XPOST --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"/\",\"destination\":\"${event_queue_name}\",\"destination_type\":\"q\",\"source\":\"amq.rabbitmq.event\",\"routing_key\":\"binding.deleted\",\"arguments\":{}}" http://${server}/api/bindings/%2F/e/amq.rabbitmq.event/q/${event_queue_name}
curl -XPOST --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"/\",\"destination\":\"${event_queue_name}\",\"destination_type\":\"q\",\"source\":\"amq.rabbitmq.event\",\"routing_key\":\"consumer.created\",\"arguments\":{}}" http://${server}/api/bindings/%2F/e/amq.rabbitmq.event/q/${event_queue_name}
curl -XPOST --user ${username}:${password} -H "Content-Type: application/json" -d "{\"vhost\":\"/\",\"destination\":\"${event_queue_name}\",\"destination_type\":\"q\",\"source\":\"amq.rabbitmq.event\",\"routing_key\":\"consumer.deleted\",\"arguments\":{}}" http://${server}/api/bindings/%2F/e/amq.rabbitmq.event/q/${event_queue_name}

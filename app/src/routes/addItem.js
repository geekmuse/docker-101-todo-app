const db = require('../persistence');
const uuid = require('uuid/v4');
const pubsub = require('../pubsub');
const topic =
    process.env.SNS_TOPIC_ARN_ADDITEM || process.env.SNS_TOPIC_ARN_DEFAULT;

module.exports = async (req, res) => {
    const item = {
        id: uuid(),
        name: req.body.name,
        completed: false,
    };

    await db.storeItem(item);
    await pubsub.publish(topic, 'add', item.name);
    res.send(item);
};

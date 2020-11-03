const db = require('../persistence');
const pubsub = require('../pubsub');
const topic = process.env.SNS_TOPIC_ARN_DELETEITEM || process.env.SNS_TOPIC_ARN_DEFAULT;

module.exports = async (req, res) => {
	const item = await db.getItem(req.params.id);
    await db.removeItem(req.params.id);
    await pubsub.publish(topic, 'delete', item.name);
    res.sendStatus(200);
};

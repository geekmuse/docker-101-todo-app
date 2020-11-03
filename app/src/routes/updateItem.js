const db = require('../persistence');
const pubsub = require('../pubsub');
const topic = process.env.SNS_TOPIC_ARN_UPDATEITEM || process.env.SNS_TOPIC_ARN_DEFAULT;

module.exports = async (req, res) => {
	var op;
    await db.updateItem(req.params.id, {
        name: req.body.name,
        completed: req.body.completed,
    });
    const item = await db.getItem(req.params.id);
    console.log(`item => ${JSON.stringify(item)}`)
    switch (item.completed) {
    	case true:
    		op = 'complete';
    		break;
    	case false:
    		op = 'incomplete';
    		break;
   		default:
   			op = 'update';
   	}
    await pubsub.publish(topic, op, item.name);
    res.send(item);
};

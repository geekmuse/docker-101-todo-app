var AWS = require('aws-sdk');
const sns = new AWS.SNS({
    apiVersion: '2010-03-31',
    region: process.env.AWS_REGION || 'us-east-1',
});

const actionMappings = {
    update: 'Item was updated',
    add: 'Item was added',
    delete: 'Item was deleted',
    complete: 'Item was marked complete',
    incomplete: 'Item was marked incomplete',
};

async function publish(topicArn, op, itemName) {
    return new Promise((acc, rej) => {
        var params = {
            Message: `${actionMappings[op]}: ${itemName}`,
            TopicArn: topicArn,
        };
        sns.publish(params, function(err, data) {
            if (err) return rej(err);
            acc();
        });
    });
}

module.exports = {
    publish,
};

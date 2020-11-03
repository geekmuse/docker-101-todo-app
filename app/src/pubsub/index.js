if (process.env.SNS_TOPIC_ARN_DEFAULT) module.exports = require('./sns');
else module.exports = require('./dummy');

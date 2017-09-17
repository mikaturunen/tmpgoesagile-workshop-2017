/*
* TAMPERE GOES AGILE 2017, LAMBDA WORKSHOP.
*/


/**
 * Handler function for Lambda. AWS Lambda will execute this `handler` method when AWS invokes
 * this lambda. You have to invoke the context.done to properly terminate the Lambda in both
 * success and failure cases.
 *
 * @param {Object} event Full event data AWS sends this Lambda. Completely context dependant.   
 * @param {Object} context Lambda context object.
 * @param {Function} callback Lambda callback with normal node.js null, value callback pattern.
 */
exports.handler = (event, context, callback) =>  {
  // we just simply dumb the event into the aws cloudwatch logs to see what is going on for now
  console.log('Received event:', JSON.stringify(!event ? {} : event, null, 2));
  
  callback(null, 'Hello, World!')
}
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
export const handler = (event, context, callback) =>  {
  callback(null, 'Hello, World!')
}

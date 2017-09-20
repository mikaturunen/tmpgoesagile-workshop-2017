/*
* TAMPERE GOES AGILE 2017, LAMBDA WORKSHOP.
*/

const AWS = require('aws-sdk')

AWS.config.update({ region: 'eu-central-1' })
const dynamoClient = new AWS.DynamoDB.DocumentClient()
const TableName = "Workshop"

/**
 * Handler function for Lambda. AWS Lambda will execute this `handler` method when AWS invokes
 * this lambda. You have to invoke the callback to properly terminate the Lambda in both
 * success and failure cases.
 *
 * @param {Object} event Full event data AWS sends this Lambda. Completely context dependant.   
 * @param {Object} context Lambda context object.
 * @param {Function} callback Lambda callback with normal node.js null, value callback pattern.
 */
exports.handler = (event, context, callback) =>  {
  // we just simply dumb the event into the aws cloudwatch logs to see what is going on for now
  console.log('Received event: ', JSON.stringify(!event ? {} : event, null, 2))
  
  if (!event) {
    callback('Nothing received.')
    return
  } else if(!dynamoClient) {
    console.log('Loading aws dynamodb configuration.')
    AWS.config.update({ region: 'eu-central-1' })
    const dynamoClient = new AWS.DynamoDB.DocumentClient()
  }
  
  const dynamoParameters = {
    TableName,
    Item: event.item
  }
  
  // NOTE that I'm using the tower of doom callback pattern, didn't want to spin complexity in the example by using 
  //      promises or await/asyncs
  console.log("Adding a new item.")
  dynamoClient.put(dynamoParameters, (error, dynamoResponse) => {
      if (error) {
        const message = 'Unable to add item. Error JSON: ' + JSON.stringify(error, null, 2)
        console.error(message)
        callback(message)
        return
      } 
      
      console.log('Added item: ', JSON.stringify(dynamoResponse, null, 2))
    
      const dynamoGetParameters = {
        TableName,
        Key: {
          title: event.item.title
        }
      }
      
      console.log('Getting item.')
      dynamoClient.get(dynamoGetParameters, (error, dynamoResponse) => {
        if (error) {
          const message = 'Unable to get item. Error JSON: ' + JSON.stringify(error, null, 2)
          console.error(message)
          callback(null, message)
        } else {
          console.log('Got item: ', JSON.stringify(dynamoResponse, null, 2))
          callback(null, dynamoResponse)
        }
      })
  })
}
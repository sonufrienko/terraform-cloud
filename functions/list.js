module.exports.handler = async (event) => {
  console.log('Event: ', event);
  let pats = ['cat', 'dog', 'wolf'];

  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      pats,
    }),
  };
};

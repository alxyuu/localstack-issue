exports.handler = (event) => {
  console.log(JSON.stringify(event));
  return Promise.resolve('ok');
};
